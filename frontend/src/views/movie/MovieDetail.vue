<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { movieApi, showtimeApi } from '@/api'
import type { Movie, Showtime } from '@/types'
import {
  StarFilled,
  ClockCircleOutlined,
  GlobalOutlined,
  UserOutlined,
  LeftOutlined
} from '@ant-design/icons-vue'
import dayjs from 'dayjs'

const router = useRouter()
const route = useRoute()

const movieId = Number(route.params.id)
const loading = ref(true)
const movie = ref<Movie | null>(null)
const showtimes = ref<Showtime[]>([])
const selectedDate = ref(dayjs().format('YYYY-MM-DD'))

// 日期列表 (未来7天)
const dateList = Array.from({ length: 7 }, (_, i) => {
  const date = dayjs().add(i, 'day')
  return {
    value: date.format('YYYY-MM-DD'),
    label: i === 0 ? '今天' : i === 1 ? '明天' : date.format('MM-DD'),
    week: date.format('ddd')
  }
})

// 获取影片详情
const fetchMovie = async () => {
  loading.value = true
  try {
    const res = await movieApi.getDetail(movieId)
    movie.value = res.data
  } catch (error) {
    console.error('获取影片失败', error)
    router.back()
  } finally {
    loading.value = false
  }
}

// 获取场次
const fetchShowtimes = async () => {
  try {
    const res = await showtimeApi.getList({
      movieId,
      date: selectedDate.value,
      page: 1,
      size: 50
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

// 按影院分组场次
const groupedShowtimes = () => {
  const groups: Record<string, Showtime[]> = {}
  showtimes.value.forEach(st => {
    const cinemaName = st.cinema?.name || '未知影院'
    if (!groups[cinemaName]) {
      groups[cinemaName] = []
    }
    groups[cinemaName].push(st)
  })
  return groups
}

onMounted(() => {
  fetchMovie()
  fetchShowtimes()
})
</script>

<template>
  <div class="movie-detail-page">
    <!-- 返回按钮 -->
    <a-button type="text" class="back-btn" @click="router.back()">
      <LeftOutlined /> 返回
    </a-button>

    <a-spin :spinning="loading">
      <!-- 影片信息 -->
      <div class="movie-header" v-if="movie">
        <div class="poster">
          <img :src="movie.poster" :alt="movie.title" />
        </div>
        <div class="info">
          <h1>{{ movie.title }}</h1>
          <div class="rating" v-if="movie.rating">
            <StarFilled />
            <span class="score">{{ movie.rating }}</span>
            <span class="label">评分</span>
          </div>
          <div class="meta">
            <p><ClockCircleOutlined /> {{ movie.duration }}分钟</p>
            <p><GlobalOutlined /> {{ movie.country }} / {{ movie.language }}</p>
            <p>{{ movie.genre }}</p>
          </div>
          <div class="crew">
            <p><UserOutlined /> 导演: {{ movie.director }}</p>
            <p><UserOutlined /> 主演: {{ movie.actors }}</p>
          </div>
        </div>
      </div>

      <!-- 简介 -->
      <div class="section" v-if="movie?.description">
        <h2>剧情简介</h2>
        <p class="description">{{ movie.description }}</p>
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

        <!-- 场次列表 -->
        <div class="showtime-list">
          <div
            v-for="(times, cinema) in groupedShowtimes()"
            :key="cinema"
            class="cinema-group"
          >
            <div class="cinema-name">{{ cinema }}</div>
            <div class="times">
              <div
                v-for="st in times"
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
.movie-detail-page {
  max-width: 900px;
  margin: 0 auto;
}

.back-btn {
  margin-bottom: 16px;
}

/* 影片头部 */
.movie-header {
  display: flex;
  gap: 32px;
  padding: 32px;
  background: linear-gradient(135deg, #2b2b2b 0%, #1a1a1a 100%);
  border-radius: 16px;
  color: white;
  margin-bottom: 24px;
}

.poster {
  width: 200px;
  height: 280px;
  border-radius: 12px;
  overflow: hidden;
  flex-shrink: 0;
}

.poster img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info h1 {
  font-size: 28px;
  color: white;
  margin-bottom: 16px;
}

.rating {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
}

.rating .anticon {
  color: #ffc107;
  font-size: 24px;
}

.rating .score {
  font-size: 32px;
  font-weight: 700;
  color: #ffc107;
}

.rating .label {
  color: #999;
}

.meta p, .crew p {
  color: #ccc;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 区块 */
.section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 24px;
}

.section h2 {
  font-size: 18px;
  margin-bottom: 16px;
}

.description {
  color: #666;
  line-height: 1.8;
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

/* 场次列表 */
.cinema-group {
  margin-bottom: 24px;
}

.cinema-name {
  font-weight: 600;
  margin-bottom: 12px;
  color: #333;
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
  padding: 16px 24px;
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
  font-size: 20px;
  font-weight: 700;
  color: var(--color-primary);
}

.time-card .hall {
  color: #666;
  font-size: 13px;
  margin: 4px 0;
}

.time-card .price {
  color: #ff6b6b;
  font-weight: 600;
}

@media (max-width: 768px) {
  .movie-header {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }
  
  .poster {
    width: 160px;
    height: 220px;
  }
}
</style>
