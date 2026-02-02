<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { matchApi } from '@/api/companion'
import { LoadingOutlined, UserOutlined, CloseOutlined } from '@ant-design/icons-vue'

const props = defineProps<{
  visible: boolean
  showtimeId: number
  seatId: number
}>()

const emit = defineEmits<{
  (e: 'update:visible', val: boolean): void
  (e: 'matched'): void
  (e: 'skip'): void
}>()

const status = ref<'waiting' | 'matched' | 'expired'>('waiting')
const countdown = ref(300) // 5分钟
let pollTimer: number
let countdownTimer: number

// 加入匹配池
const joinPool = async () => {
  try {
    await matchApi.join(props.showtimeId, props.seatId)
    startPolling()
    startCountdown()
  } catch (error) {
    console.error('加入匹配池失败', error)
  }
}

// 轮询匹配状态
const startPolling = () => {
  pollTimer = window.setInterval(async () => {
    try {
      const res = await matchApi.getStatus(props.showtimeId)
      if (res.data?.status === 'MATCHED') {
        status.value = 'matched'
        clearInterval(pollTimer)
        clearInterval(countdownTimer)
        setTimeout(() => {
          emit('matched')
          emit('update:visible', false)
        }, 2000)
      }
    } catch (error) {
      console.error('查询匹配状态失败', error)
    }
  }, 3000)
}

// 倒计时
const startCountdown = () => {
  countdownTimer = window.setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      status.value = 'expired'
      clearInterval(pollTimer)
      clearInterval(countdownTimer)
    }
  }, 1000)
}

// 取消匹配
const handleCancel = async () => {
  try {
    await matchApi.cancel(props.showtimeId)
  } catch (error) {
    console.error('取消匹配失败', error)
  }
  clearInterval(pollTimer)
  clearInterval(countdownTimer)
  emit('skip')
  emit('update:visible', false)
}

// 格式化倒计时
const formatCountdown = () => {
  const min = Math.floor(countdown.value / 60)
  const sec = countdown.value % 60
  return `${min}:${String(sec).padStart(2, '0')}`
}

onMounted(() => {
  if (props.visible) {
    joinPool()
  }
})

onUnmounted(() => {
  clearInterval(pollTimer)
  clearInterval(countdownTimer)
})
</script>

<template>
  <a-modal
    :open="visible"
    :closable="false"
    :footer="null"
    width="400px"
    centered
  >
    <div class="match-waiting">
      <!-- 等待中 -->
      <template v-if="status === 'waiting'">
        <div class="waiting-animation">
          <div class="radar">
            <LoadingOutlined class="icon" spin />
          </div>
        </div>
        <h2>正在寻找观影伙伴...</h2>
        <p class="tip">正在为你匹配同场次的观影伙伴</p>
        <div class="countdown">
          剩余时间: <span>{{ formatCountdown() }}</span>
        </div>
        <a-button type="link" @click="handleCancel">
          <CloseOutlined /> 取消匹配
        </a-button>
      </template>

      <!-- 匹配成功 -->
      <template v-else-if="status === 'matched'">
        <div class="success-animation">
          <UserOutlined class="icon" />
          <UserOutlined class="icon" />
        </div>
        <h2>🎉 匹配成功!</h2>
        <p class="tip">已为你找到观影伙伴，一起享受电影吧~</p>
      </template>

      <!-- 超时 -->
      <template v-else>
        <div class="expired-icon">
          <CloseOutlined />
        </div>
        <h2>匹配超时</h2>
        <p class="tip">暂时没有找到合适的观影伙伴</p>
        <a-button type="primary" @click="handleCancel">
          继续购票
        </a-button>
      </template>
    </div>
  </a-modal>
</template>

<style scoped>
.match-waiting {
  text-align: center;
  padding: 32px 16px;
}

/* 等待动画 */
.waiting-animation {
  margin-bottom: 24px;
}

.radar {
  width: 120px;
  height: 120px;
  margin: 0 auto;
  background: linear-gradient(135deg, #fff0f6 0%, #ffeef8 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: pulse 2s infinite;
}

.radar .icon {
  font-size: 48px;
  color: var(--color-primary);
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.1); opacity: 0.8; }
}

/* 成功动画 */
.success-animation {
  display: flex;
  justify-content: center;
  gap: 24px;
  margin-bottom: 24px;
}

.success-animation .icon {
  width: 60px;
  height: 60px;
  background: #f0f9eb;
  color: #67c23a;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  animation: bounce 0.5s ease;
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* 超时图标 */
.expired-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 24px;
  background: #fef0f0;
  color: #f56c6c;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
}

h2 {
  font-size: 22px;
  margin-bottom: 8px;
}

.tip {
  color: #999;
  margin-bottom: 16px;
}

.countdown {
  font-size: 18px;
  margin-bottom: 16px;
}

.countdown span {
  font-weight: 700;
  color: var(--color-primary);
}
</style>
