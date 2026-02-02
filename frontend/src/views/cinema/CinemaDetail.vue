<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { cinemaApi, showtimeApi } from '@/api'
import { useAppStore } from '@/stores/app'
import type { Cinema, Showtime } from '@/types'
import {
  EnvironmentOutlined,
  PhoneOutlined,
  LeftOutlined,
  ClockCircleOutlined
} from '@ant-design/icons-vue'
import dayjs from 'dayjs'
import 'dayjs/locale/zh-cn'

// 设置 dayjs 使用中文
dayjs.locale('zh-cn')

// 星期中文映射
const weekDayMap: Record<number, string> = {
  0: '周日',
  1: '周一',
  2: '周二',
  3: '周三',
  4: '周四',
  5: '周五',
  6: '周六'
}

const router = useRouter()
const route = useRoute()
const appStore = useAppStore()

// 监听城市变化，返回影院列表页
watch(() => appStore.currentCity, () => {
  router.replace('/cinemas')
})

const cinemaId = Number(route.params.id)
const loading = ref(true)
const cinema = ref<Cinema | null>(null)
const showtimes = ref<Showtime[]>([])
const selectedDate = ref(dayjs().format('YYYY-MM-DD'))

// 日期列表 (未来7天)
const dateList = Array.from({ length: 7 }, (_, i) => {
  const date = dayjs().add(i, 'day')
  return {
    value: date.format('YYYY-MM-DD'),
    label: i === 0 ? '今天' : i === 1 ? '明天' : date.format('MM-DD'),
    week: weekDayMap[date.day()]
  }
})

// 获取影院详情
const fetchCinema = async () => {
  loading.value = true
  try {
    const res = await cinemaApi.getDetail(cinemaId)
    cinema.value = res.data
  } catch (error) {
    console.error('获取影院失败', error)
    router.back()
  } finally {
    loading.value = false
  }
}

// 获取场次
const fetchShowtimes = async () => {
  try {
    const res = await showtimeApi.getList({
      cinemaId,
      date: selectedDate.value,
      page: 1,
      size: 100
    })
    showtimes.value = res.data?.records || []
  } catch (error) {
    console.error('获取场次失败', error)
  }
}

// 切换日期
const handleDateChange = (date: string) => {
  selectedDate.value = date
  fetchShowtimes()
}

// 去选座
const goSeatSelection = (showtimeId: number) => {
  router.push(`/showtimes/${showtimeId}/seats`)
}

// 按影片分组场次
const groupedShowtimes = () => {
  const groups: Record<string, { movie: any; times: Showtime[] }> = {}
  showtimes.value.forEach(st => {
    const movieTitle = st.movie?.title || '未知影片'
    if (!groups[movieTitle]) {
      groups[movieTitle] = { movie: st.movie, times: [] }
    }
    groups[movieTitle].times.push(st)
  })
  return groups
}

onMounted(() => {
  fetchCinema()
  fetchShowtimes()
})
</script>

<template>
  <div class="cinema-detail-page">
    <!-- 返回按钮 -->
    <a-button type="text" class="back-btn" @click="router.back()">
      <LeftOutlined /> 返回
    </a-button>

    <a-spin :spinning="loading">
      <!-- 影院信息 -->
      <div class="cinema-header" v-if="cinema">
        <div class="cover" v-if="cinema.coverImage">
          <img :src="cinema.coverImage" :alt="cinema.name" />
        </div>
        <div class="info">
          <h1>{{ cinema.name }}</h1>
          <p class="address">
            <EnvironmentOutlined />
            {{ cinema.address }}
          </p>
          <p class="phone" v-if="cinema.phone">
            <PhoneOutlined />
            {{ cinema.phone }}
          </p>
          <p class="desc" v-if="cinema.description">
            {{ cinema.description }}
          </p>
          <div class="halls" v-if="cinema.halls?.length">
            <span class="label">影厅:</span>
            <a-tag v-for="hall in cinema.halls" :key="hall.id">
              {{ hall.name }}
            </a-tag>
          </div>
        </div>
      </div>

      <!-- 场次选择 -->
      <div class="section">
        <h2>选择场次</h2>

        <!-- 日期选择 -->
        <div class="date-tabs">
          <div
            v-for="date in dateList"
            :key="date.value"
            class="date-item"
            :class="{ active: selectedDate === date.value }"
            @click="handleDateChange(date.value)"
          >
            <span class="day">{{ date.label }}</span>
            <span class="week">{{ date.week }}</span>
          </div>
        </div>

        <!-- 场次列表 (按影片分组) -->
        <div class="showtime-list">
          <div
            v-for="(group, movieTitle) in groupedShowtimes()"
            :key="movieTitle"
            class="movie-group"
          >
            <div class="movie-info">
              <img :src="group.movie?.poster" class="mini-poster" />
              <div>
                <h3>{{ movieTitle }}</h3>
                <span class="meta">{{ group.movie?.genre }} | {{ group.movie?.duration }}分钟</span>
              </div>
            </div>
            <div class="times">
              <div
                v-for="st in group.times"
                :key="st.id"
                class="time-card"
                @click="goSeatSelection(st.id)"
              >
                <div class="time">{{ st.startTime?.slice(0, 5) }}</div>
                <div class="hall">{{ st.hall?.name }}</div>
                <div class="price">¥{{ st.price }}</div>
              </div>
            </div>
          </div>

          <a-empty v-if="showtimes.length === 0" description="暂无场次" />
        </div>
      </div>
    </a-spin>
  </div>
</template>

<style scoped>
.cinema-detail-page {
  max-width: 900px;
  margin: 0 auto;
}

.back-btn {
  margin-bottom: 16px;
}

/* 影院头部 */
.cinema-header {
  display: flex;
  gap: 24px;
  padding: 24px;
  background: white;
  border-radius: 12px;
  margin-bottom: 24px;
}

.cover {
  width: 200px;
  height: 120px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info h1 {
  font-size: 24px;
  margin-bottom: 12px;
}

.info p {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--text-secondary);
  margin-bottom: 8px;
}

.info .desc {
  color: #666;
  margin: 12px 0;
}

.halls {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.halls .label {
  color: var(--text-secondary);
}

/* 区块 */
.section {
  background: white;
  border-radius: 12px;
  padding: 24px;
}

.section h2 {
  font-size: 18px;
  margin-bottom: 16px;
}

/* 日期选择 */
.date-tabs {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  overflow-x: auto;
}

.date-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 12px 20px;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}

.date-item:hover {
  border-color: var(--color-primary);
}

.date-item.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.date-item .day {
  font-weight: 600;
}

.date-item .week {
  font-size: 12px;
  color: #999;
}

.date-item.active .week {
  color: rgba(255, 255, 255, 0.8);
}

/* 影片分组 */
.movie-group {
  padding: 20px;
  border: 1px solid #f0f0f0;
  border-radius: 12px;
  margin-bottom: 16px;
}

.movie-info {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
}

.mini-poster {
  width: 60px;
  height: 84px;
  border-radius: 6px;
  object-fit: cover;
}

.movie-info h3 {
  font-size: 18px;
  margin-bottom: 4px;
}

.movie-info .meta {
  color: var(--text-secondary);
  font-size: 13px;
}

.times {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.time-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 12px 20px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.time-card:hover {
  border-color: var(--color-primary);
  box-shadow: 0 2px 8px rgba(214, 51, 132, 0.2);
}

.time-card .time {
  font-size: 18px;
  font-weight: 700;
  color: var(--color-primary);
}

.time-card .hall {
  color: #666;
  font-size: 12px;
  margin: 4px 0;
}

.time-card .price {
  color: #ff6b6b;
  font-weight: 600;
  font-size: 14px;
}

@media (max-width: 768px) {
  .cinema-header {
    flex-direction: column;
  }
  
  .cover {
    width: 100%;
    height: 160px;
  }
}
</style>
