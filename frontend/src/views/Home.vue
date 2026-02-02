<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { movieApi, cinemaApi } from '@/api'
import { useAppStore } from '@/stores/app'
import type { Movie, Cinema } from '@/types'
import {
  RightOutlined,
  EnvironmentOutlined,
  StarFilled
} from '@ant-design/icons-vue'

const router = useRouter()
const appStore = useAppStore()

// 数据
const showingMovies = ref<Movie[]>([])
const comingMovies = ref<Movie[]>([])
const cinemas = ref<Cinema[]>([])
const loading = ref(true)
const activeTab = ref('showing')

// 获取数据
onMounted(async () => {
  try {
    const [showingRes, comingRes, cinemaRes] = await Promise.all([
      movieApi.getShowing({ size: 8 }),
      movieApi.getComing({ size: 4 }),
      cinemaApi.getList({ city: appStore.currentCity })
    ])
    showingMovies.value = showingRes.data?.records || []
    comingMovies.value = comingRes.data?.records || []
    cinemas.value = cinemaRes.data?.records || cinemaRes.data || []
  } catch (error) {
    console.error('获取数据失败', error)
  } finally {
    loading.value = false
  }
})

// 跳转到影片详情
const goMovieDetail = (id: number) => {
  router.push(`/movies/${id}`)
}

// 跳转到影院详情
const goCinemaDetail = (id: number) => {
  router.push(`/cinemas/${id}`)
}
</script>

<template>
  <div class="home-page">
    <!-- 轮播图 -->
    <section class="banner-section">
      <a-carousel autoplay :dots="true" class="banner-carousel">
        <div v-for="movie in showingMovies.slice(0, 4)" :key="movie.id" class="banner-item">
          <div
            class="banner-bg"
            :style="{ backgroundImage: `url(${movie.poster})` }"
          ></div>
          <div class="banner-content">
            <h2>{{ movie.title }}</h2>
            <p>{{ movie.genre }} | {{ movie.duration }}分钟</p>
            <a-button type="primary" size="large" @click="goMovieDetail(movie.id)">
              立即购票
            </a-button>
          </div>
        </div>
      </a-carousel>
    </section>

    <!-- 影片列表 -->
    <section class="movie-section">
      <div class="section-header">
        <a-tabs v-model:activeKey="activeTab" size="large">
          <a-tab-pane key="showing" tab="正在热映" />
          <a-tab-pane key="coming" tab="即将上映" />
        </a-tabs>
        <a-button type="link" @click="router.push('/movies')">
          查看全部 <RightOutlined />
        </a-button>
      </div>

      <a-spin :spinning="loading">
        <div class="movie-grid">
          <div
            v-for="movie in (activeTab === 'showing' ? showingMovies : comingMovies)"
            :key="movie.id"
            class="movie-card"
            @click="goMovieDetail(movie.id)"
          >
            <div class="movie-poster">
              <img :src="movie.poster" :alt="movie.title" />
              <div class="movie-rating" v-if="movie.rating">
                <StarFilled /> {{ movie.rating }}
              </div>
            </div>
            <div class="movie-info">
              <h3 class="movie-title">{{ movie.title }}</h3>
              <p class="movie-meta">{{ movie.genre }}</p>
            </div>
          </div>
        </div>
      </a-spin>
    </section>

    <!-- 附近影院 -->
    <section class="cinema-section">
      <div class="section-header">
        <h2>
          <EnvironmentOutlined /> 
          {{ appStore.currentCity }}的影院
        </h2>
        <a-button type="link" @click="router.push('/cinemas')">
          查看全部 <RightOutlined />
        </a-button>
      </div>

      <a-spin :spinning="loading">
        <div class="cinema-list">
          <div
            v-for="cinema in cinemas.slice(0, 5)"
            :key="cinema.id"
            class="cinema-card"
            @click="goCinemaDetail(cinema.id)"
          >
            <div class="cinema-info">
              <h3>{{ cinema.name }}</h3>
              <p class="cinema-address">{{ cinema.address }}</p>
            </div>
            <a-button type="primary">
              查看场次
            </a-button>
          </div>
        </div>
      </a-spin>
    </section>
  </div>
</template>

<style scoped>
.home-page {
  max-width: 1200px;
  margin: 0 auto;
}

/* 轮播图 */
.banner-section {
  margin-bottom: 40px;
  border-radius: 16px;
  overflow: hidden;
}

.banner-carousel {
  height: 400px;
}

.banner-item {
  position: relative;
  height: 400px;
}

.banner-bg {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center;
  filter: blur(20px) brightness(0.4);
}

.banner-content {
  position: relative;
  z-index: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  text-align: center;
}

.banner-content h2 {
  font-size: 48px;
  font-weight: 700;
  margin-bottom: 16px;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
}

.banner-content p {
  font-size: 18px;
  margin-bottom: 24px;
  opacity: 0.9;
}

/* 区块头部 */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.section-header h2 {
  font-size: 24px;
  font-weight: 600;
}

/* 影片网格 */
.movie-section {
  margin-bottom: 48px;
}

.movie-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 24px;
}

.movie-card {
  cursor: pointer;
  transition: transform 0.3s ease;
}

.movie-card:hover {
  transform: translateY(-8px);
}

.movie-poster {
  position: relative;
  aspect-ratio: 2/3;
  border-radius: 12px;
  overflow: hidden;
}

.movie-poster img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.movie-rating {
  position: absolute;
  top: 8px;
  right: 8px;
  background: rgba(0, 0, 0, 0.7);
  color: #ffc107;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
}

.movie-info {
  padding: 12px 0;
}

.movie-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.movie-meta {
  color: var(--text-secondary);
  font-size: 14px;
}

/* 影院列表 */
.cinema-section {
  margin-bottom: 48px;
}

.cinema-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.cinema-card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: var(--bg-secondary);
  border-radius: 12px;
  box-shadow: var(--shadow-sm);
  cursor: pointer;
  transition: all 0.3s ease;
}

.cinema-card:hover {
  box-shadow: var(--shadow-md);
}

.cinema-info h3 {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 4px;
}

.cinema-address {
  color: var(--text-secondary);
  font-size: 14px;
}

/* 响应式 */
@media (max-width: 992px) {
  .movie-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .movie-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .banner-carousel {
    height: 280px;
  }
  
  .banner-item {
    height: 280px;
  }
  
  .banner-content h2 {
    font-size: 28px;
  }
}
</style>
