<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { message } from 'ant-design-vue'
import { showtimeApi, seatApi, orderApi } from '@/api'
import type { Showtime, Seat } from '@/types'
import { LeftOutlined } from '@ant-design/icons-vue'
import DollSelector from '@/components/DollSelector.vue'
import MatchWaiting from '@/components/MatchWaiting.vue'

interface DollType {
  id: number
  name: string
  price: number
}

const router = useRouter()
const route = useRoute()

const showtimeId = Number(route.params.id)
const loading = ref(true)
const submitting = ref(false)

// 数据
const showtime = ref<Showtime | null>(null)
const seats = ref<Seat[]>([])
const selectedSeats = ref<Seat[]>([])

// 陪伴功能
const showCompanionModal = ref(false)
const showDollSelector = ref(false)
const showMatchWaiting = ref(false)
const selectedDoll = ref<DollType | null>(null)
const companionType = ref<'NONE' | 'DOLL' | 'STRANGER'>('NONE')

// 座位网格 (按行分组)
const seatGrid = computed(() => {
  const grid: Record<string, Seat[]> = {}
  seats.value.forEach(seat => {
    if (!grid[seat.rowNum]) {
      grid[seat.rowNum] = []
    }
    grid[seat.rowNum].push(seat)
  })
  // 每行按列号排序
  Object.keys(grid).forEach(row => {
    grid[row].sort((a, b) => a.colNum - b.colNum)
  })
  return grid
})

// 行号列表 (排序)
const rowList = computed(() => {
  return Object.keys(seatGrid.value).sort()
})

// 列号列表 (用于表头)
const colList = computed(() => {
  const cols = new Set<number>()
  seats.value.forEach(seat => cols.add(seat.colNum))
  return Array.from(cols).sort((a, b) => a - b)
})

// 总价 (含玩偶费用)
const totalPrice = computed(() => {
  if (!showtime.value) return 0
  let price = selectedSeats.value.length * Number(showtime.value.price)
  if (selectedDoll.value) {
    price += selectedDoll.value.price
  }
  return price
})

// 获取数据
const fetchData = async () => {
  loading.value = true
  try {
    const [showtimeRes, seatsRes] = await Promise.all([
      showtimeApi.getDetail(showtimeId),
      seatApi.getSeatMap(showtimeId)
    ])
    showtime.value = showtimeRes.data
    seats.value = seatsRes.data || []
  } catch (error) {
    message.error('获取数据失败')
    router.back()
  } finally {
    loading.value = false
  }
}

// 座位点击
const handleSeatClick = (seat: Seat) => {
  // 不可选状态
  if (seat.status === 'SOLD' || seat.status === 'LOCKED' || seat.status === 'COMPANION') {
    return
  }

  const index = selectedSeats.value.findIndex(s => s.id === seat.id)
  if (index > -1) {
    // 取消选择
    selectedSeats.value.splice(index, 1)
  } else {
    // 限制最多选5个
    if (selectedSeats.value.length >= 5) {
      message.warning('最多选择5个座位')
      return
    }
    selectedSeats.value.push(seat)
  }
}

// 是否选中
const isSelected = (seat: Seat) => {
  return selectedSeats.value.some(s => s.id === seat.id)
}

// 获取座位样式类
const getSeatClass = (seat: Seat) => {
  if (isSelected(seat)) return 'selected'
  return seat.status.toLowerCase()
}

// 点击确认选座
const handleSubmit = async () => {
  if (selectedSeats.value.length === 0) {
    message.warning('请选择座位')
    return
  }

  // 如果只选了1个座位，显示陪伴选项
  if (selectedSeats.value.length === 1 && companionType.value === 'NONE') {
    showCompanionModal.value = true
    return
  }

  // 创建订单
  await createOrder()
}

// 创建订单
const createOrder = async () => {
  submitting.value = true
  try {
    const res = await orderApi.create({
      showtimeId,
      seatIds: selectedSeats.value.map(s => s.id),
      companionType: companionType.value,
      dollTypeId: selectedDoll.value?.id
    })
    message.success('订单创建成功')
    router.push(`/orders/${res.data.id}/confirm`)
  } catch (error) {
    // 错误已在拦截器处理
  } finally {
    submitting.value = false
  }
}

// 选择陪伴类型
const handleCompanionChoice = (type: 'DOLL' | 'STRANGER' | 'NONE') => {
  showCompanionModal.value = false
  companionType.value = type
  
  if (type === 'DOLL') {
    showDollSelector.value = true
  } else if (type === 'STRANGER') {
    showMatchWaiting.value = true
  } else {
    createOrder()
  }
}

// 选择玩偶
const handleDollSelect = (doll: DollType) => {
  selectedDoll.value = doll
  createOrder()
}

// 跳过陪伴
const handleSkipCompanion = () => {
  companionType.value = 'NONE'
  selectedDoll.value = null
  createOrder()
}

// 匹配成功
const handleMatchSuccess = () => {
  createOrder()
}

// 定时刷新座位状态
let refreshTimer: number
onMounted(() => {
  fetchData()
  // 每30秒刷新一次座位状态
  refreshTimer = window.setInterval(() => {
    seatApi.getSeatMap(showtimeId).then(res => {
      seats.value = res.data || []
      // 移除已被其他人锁定/购买的座位
      selectedSeats.value = selectedSeats.value.filter(selected => {
        const current = seats.value.find(s => s.id === selected.id)
        return current && current.status === 'AVAILABLE'
      })
    })
  }, 30000)
})

onUnmounted(() => {
  clearInterval(refreshTimer)
})
</script>

<template>
  <div class="seat-selection-page">
    <!-- 顶部信息 -->
    <div class="page-header">
      <a-button type="text" @click="router.back()">
        <LeftOutlined /> 返回
      </a-button>
      <div class="showtime-info" v-if="showtime">
        <h2>{{ showtime.movie?.title }}</h2>
        <p>
          {{ showtime.cinema?.name }} - {{ showtime.hall?.name }} |
          {{ showtime.showDate }} {{ showtime.startTime?.slice(0, 5) }}
        </p>
      </div>
    </div>

    <a-spin :spinning="loading">
      <div class="seat-container">
        <!-- 银幕 -->
        <div class="screen">
          <div class="screen-inner">银 幕</div>
        </div>

        <!-- 座位图 -->
        <div class="seat-map">
          <!-- 列号表头 -->
          <div class="seat-row header-row">
            <div class="row-label"></div>
            <div class="seat-header" v-for="col in colList" :key="col">
              {{ col }}
            </div>
          </div>

          <!-- 座位行 -->
          <div
            v-for="row in rowList"
            :key="row"
            class="seat-row"
          >
            <div class="row-label">{{ row }}</div>
            <div
              v-for="seat in seatGrid[row]"
              :key="seat.id"
              class="seat"
              :class="getSeatClass(seat)"
              @click="handleSeatClick(seat)"
            >
              {{ seat.colNum }}
            </div>
          </div>
        </div>

        <!-- 图例 -->
        <div class="legend">
          <div class="legend-item">
            <span class="seat-demo available"></span>
            <span>可选</span>
          </div>
          <div class="legend-item">
            <span class="seat-demo selected"></span>
            <span>已选</span>
          </div>
          <div class="legend-item">
            <span class="seat-demo sold"></span>
            <span>已售</span>
          </div>
          <div class="legend-item">
            <span class="seat-demo locked"></span>
            <span>锁定</span>
          </div>
        </div>
      </div>
    </a-spin>

    <!-- 底部操作栏 -->
    <div class="bottom-bar">
      <div class="selected-info">
        <div class="selected-seats" v-if="selectedSeats.length > 0">
          <span>已选: </span>
          <a-tag v-for="seat in selectedSeats" :key="seat.id" color="pink">
            {{ seat.seatLabel }}
          </a-tag>
          <a-tag v-if="selectedDoll" color="purple">
            🧸 {{ selectedDoll.name }}
          </a-tag>
        </div>
        <div class="price-info">
          <span class="price-label">总计:</span>
          <span class="price-value">¥{{ totalPrice.toFixed(2) }}</span>
          <span class="price-detail" v-if="showtime">
            ({{ selectedSeats.length }}张 × ¥{{ showtime.price }}{{ selectedDoll ? ` + ¥${selectedDoll.price}玩偶` : '' }})
          </span>
        </div>
      </div>
      <a-button
        type="primary"
        size="large"
        :disabled="selectedSeats.length === 0"
        :loading="submitting"
        @click="handleSubmit"
      >
        确认选座
      </a-button>
    </div>

    <!-- 陪伴选项弹窗 -->
    <a-modal
      v-model:open="showCompanionModal"
      title="🎬 一个人看电影?"
      :footer="null"
      width="450px"
      centered
    >
      <div class="companion-choice">
        <p class="tip">选择一位陪伴，让观影更有趣~</p>
        <div class="choice-cards">
          <div class="choice-card" @click="handleCompanionChoice('DOLL')">
            <div class="icon">🧸</div>
            <h4>玩偶陪伴</h4>
            <p>选择一只可爱玩偶，占据旁边座位陪你看电影</p>
          </div>
          <div class="choice-card" @click="handleCompanionChoice('STRANGER')">
            <div class="icon">👥</div>
            <h4>随机匹配</h4>
            <p>匹配一位同场次的陌生人，一起观影聊电影</p>
          </div>
        </div>
        <a-button type="link" block @click="handleCompanionChoice('NONE')">
          不需要，我就喜欢一个人
        </a-button>
      </div>
    </a-modal>

    <!-- 玩偶选择器 -->
    <DollSelector
      v-model:visible="showDollSelector"
      @select="handleDollSelect"
      @skip="handleSkipCompanion"
    />

    <!-- 匹配等待 -->
    <MatchWaiting
      v-model:visible="showMatchWaiting"
      :showtime-id="showtimeId"
      :seat-id="selectedSeats[0]?.id"
      @matched="handleMatchSuccess"
      @skip="handleSkipCompanion"
    />
  </div>
</template>

<style scoped>
.seat-selection-page {
  max-width: 900px;
  margin: 0 auto;
  padding-bottom: 100px;
}

.page-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  padding: 16px;
  background: white;
  border-radius: 12px;
}

.showtime-info h2 {
  font-size: 20px;
  margin: 0;
}

.showtime-info p {
  color: var(--text-secondary);
  margin: 4px 0 0;
}

.seat-container {
  background: white;
  border-radius: 16px;
  padding: 32px;
}

/* 银幕 */
.screen {
  text-align: center;
  margin-bottom: 32px;
}

.screen-inner {
  display: inline-block;
  padding: 8px 80px;
  background: linear-gradient(180deg, #e0e0e0 0%, #bdbdbd 100%);
  border-radius: 4px;
  color: #666;
  font-size: 14px;
  letter-spacing: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

/* 座位图 */
.seat-map {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  overflow-x: auto;
  padding: 16px 0;
}

.seat-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.header-row {
  margin-bottom: 8px;
}

.row-label {
  width: 24px;
  text-align: center;
  font-weight: 600;
  color: #666;
}

.seat-header {
  width: 36px;
  height: 20px;
  text-align: center;
  font-size: 12px;
  color: #999;
}

.seat {
  width: 36px;
  height: 36px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  color: white;
}

.seat.available {
  background: var(--seat-available);
}

.seat.available:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
}

.seat.selected {
  background: var(--seat-selected);
  animation: pulse 0.3s ease;
}

.seat.sold {
  background: var(--seat-sold);
  cursor: not-allowed;
  opacity: 0.6;
}

.seat.locked {
  background: var(--seat-locked);
  cursor: not-allowed;
  color: #333;
}

.seat.companion {
  background: var(--seat-companion);
  cursor: not-allowed;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.15); }
}

/* 图例 */
.legend {
  display: flex;
  justify-content: center;
  gap: 24px;
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1px solid #eee;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #666;
  font-size: 14px;
}

.seat-demo {
  width: 24px;
  height: 24px;
  border-radius: 4px;
}

.seat-demo.available { background: var(--seat-available); }
.seat-demo.selected { background: var(--seat-selected); }
.seat-demo.sold { background: var(--seat-sold); opacity: 0.6; }
.seat-demo.locked { background: var(--seat-locked); }

/* 底部操作栏 */
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: white;
  padding: 16px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.1);
  z-index: 100;
}

.selected-info {
  flex: 1;
}

.selected-seats {
  margin-bottom: 8px;
}

.price-info {
  display: flex;
  align-items: baseline;
  gap: 8px;
}

.price-label {
  color: #666;
}

.price-value {
  font-size: 24px;
  font-weight: 700;
  color: var(--color-primary);
}

.price-detail {
  color: #999;
  font-size: 14px;
}

/* 响应式 */
@media (max-width: 768px) {
  .seat {
    width: 28px;
    height: 28px;
    font-size: 10px;
  }
  
  .seat-row {
    gap: 4px;
  }
  
  .seat-container {
    padding: 16px;
  }
  
  .legend {
    flex-wrap: wrap;
    gap: 12px;
  }
}

/* 陪伴选项 */
.companion-choice {
  padding: 16px 0;
}

.companion-choice .tip {
  text-align: center;
  color: #666;
  margin-bottom: 24px;
}

.choice-cards {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
}

.choice-card {
  flex: 1;
  padding: 24px 16px;
  border: 2px solid #f0f0f0;
  border-radius: 12px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
}

.choice-card:hover {
  border-color: var(--color-primary);
  background: #fff0f6;
}

.choice-card .icon {
  font-size: 48px;
  margin-bottom: 12px;
}

.choice-card h4 {
  font-size: 16px;
  margin-bottom: 8px;
}

.choice-card p {
  font-size: 12px;
  color: #999;
  margin: 0;
}
</style>
