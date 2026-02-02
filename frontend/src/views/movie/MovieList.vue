<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { movieApi } from '@/api'
import type { Movie } from '@/types'
import { StarFilled, SearchOutlined } from '@ant-design/icons-vue'

const router = useRouter()

const loading = ref(true)
const movies = ref<Movie[]>([])
const activeTab = ref('SHOWING')
const keyword = ref('')

// 获取影片列表
const fetchMovies = async () => {
  loading.value = true
  try {
    const res = await movieApi.getList({
      status: activeTab.value,
      keyword: keyword.value,
      page: 1,
      size: 20
    })
    movies.value = res.data?.records || []
  } catch (error) {
    console.error('获取影片失败', error)
  } finally {
    loading.value = false
  }
}

// Tab 切换
const handleTabChange = () => {
  fetchMovies()
}

// 搜索
const handleSearch = () => {
  fetchMovies()
}

// 跳转详情
const goDetail = (id: number) => {
  router.push(`/movies/${id}`)
}

onMounted(() => {
  fetchMovies()
})
</script>

<template>
  <div class="movie-list-page">
    <div class="page-header">
      <a-tabs v-model:activeKey="activeTab" size="large" @change="handleTabChange">
        <a-tab-pane key="SHOWING" tab="正在热映" />
        <a-tab-pane key="COMING" tab="即将上映" />
      </a-tabs>
      <a-input-search
        v-model:value="keyword"
        placeholder="搜索影片"
        style="width: 250px"
        @search="handleSearch"
      />
    </div>

    <a-spin :spinning="loading">
      <div class="movie-grid">
        <div
          v-for="movie in movies"
          :key="movie.id"
          class="movie-card"
          @click="goDetail(movie.id)"
        >
          <div class="poster">
            <img :src="movie.poster" :alt="movie.title" />
            <div class="rating" v-if="movie.rating">
              <StarFilled /> {{ movie.rating }}
            </div>
            <div class="status-tag" :class="movie.status.toLowerCase()">
              {{ movie.status === 'SHOWING' ? '热映' : '待映' }}
            </div>
          </div>
          <div class="info">
            <h3>{{ movie.title }}</h3>
            <p class="meta">{{ movie.genre }} | {{ movie.duration }}分钟</p>
            <p class="date" v-if="movie.status === 'COMING'">
              {{ movie.releaseDate }} 上映
            </p>
          </div>
          <a-button type="primary" block>
            {{ movie.status === 'SHOWING' ? '购票' : '想看' }}
          </a-button>
        </div>
      </div>

      <a-empty v-if="!loading && movies.length === 0" description="暂无影片" />
    </a-spin>
  </div>
</template>

<style scoped>
.movie-list-page {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.movie-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 24px;
}

.movie-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  cursor: pointer;
  transition: all 0.3s;
}

.movie-card:hover {
  transform: translateY(-8px);
  box-shadow: var(--shadow-lg);
}

.poster {
  position: relative;
  aspect-ratio: 2/3;
}

.poster img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.rating {
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

.status-tag {
  position: absolute;
  top: 8px;
  left: 8px;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
  color: white;
}

.status-tag.showing {
  background: var(--color-danger);
}

.status-tag.coming {
  background: var(--color-info);
}

.info {
  padding: 16px;
}

.info h3 {
  font-size: 16px;
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.info .meta {
  color: var(--text-secondary);
  font-size: 13px;
  margin-bottom: 4px;
}

.info .date {
  color: var(--color-primary);
  font-size: 13px;
}

.movie-card .ant-btn {
  margin: 0 16px 16px;
  width: calc(100% - 32px);
}

@media (max-width: 1200px) {
  .movie-grid { grid-template-columns: repeat(4, 1fr); }
}

@media (max-width: 992px) {
  .movie-grid { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 768px) {
  .movie-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
