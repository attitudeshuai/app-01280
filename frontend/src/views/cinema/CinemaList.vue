<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { cinemaApi } from '@/api'
import { useAppStore } from '@/stores/app'
import type { Cinema } from '@/types'
import { EnvironmentOutlined, SearchOutlined } from '@ant-design/icons-vue'

const router = useRouter()
const appStore = useAppStore()

const cinemas = ref<Cinema[]>([])
const loading = ref(true)
const keyword = ref('')

// 获取影院列表
const fetchCinemas = async () => {
  loading.value = true
  try {
    const res = await cinemaApi.getList({
      city: appStore.currentCity,
      keyword: keyword.value
    })
    cinemas.value = res.data?.records || res.data || []
  } catch (error) {
    console.error('获取影院列表失败', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchCinemas()
})

// 搜索
const handleSearch = () => {
  fetchCinemas()
}

// 跳转详情
const goDetail = (id: number) => {
  router.push(`/cinemas/${id}`)
}
</script>

<template>
  <div class="cinema-list-page">
    <div class="page-header">
      <h1>
        <EnvironmentOutlined />
        {{ appStore.currentCity }}的影院
      </h1>
      <a-input-search
        v-model:value="keyword"
        placeholder="搜索影院名称"
        style="width: 300px"
        size="large"
        @search="handleSearch"
      />
    </div>

    <a-spin :spinning="loading">
      <div class="cinema-list">
        <div
          v-for="cinema in cinemas"
          :key="cinema.id"
          class="cinema-card"
          @click="goDetail(cinema.id)"
        >
          <div class="cinema-cover">
            <img :src="cinema.coverImage || 'https://picsum.photos/300/200'" :alt="cinema.name" />
          </div>
          <div class="cinema-info">
            <h3>{{ cinema.name }}</h3>
            <p class="cinema-address">
              <EnvironmentOutlined /> {{ cinema.address }}
            </p>
            <p class="cinema-desc">{{ cinema.description }}</p>
          </div>
          <div class="cinema-action">
            <a-button type="primary">查看场次</a-button>
          </div>
        </div>

        <a-empty v-if="!loading && cinemas.length === 0" description="暂无影院" />
      </div>
    </a-spin>
  </div>
</template>

<style scoped>
.cinema-list-page {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;
}

.page-header h1 {
  font-size: 28px;
  font-weight: 600;
}

.cinema-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.cinema-card {
  display: flex;
  gap: 24px;
  padding: 20px;
  background: white;
  border-radius: 12px;
  box-shadow: var(--shadow-sm);
  cursor: pointer;
  transition: all 0.3s ease;
}

.cinema-card:hover {
  box-shadow: var(--shadow-md);
}

.cinema-cover {
  width: 200px;
  height: 120px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.cinema-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.cinema-info {
  flex: 1;
}

.cinema-info h3 {
  font-size: 20px;
  font-weight: 600;
  margin-bottom: 8px;
}

.cinema-address {
  color: var(--text-secondary);
  margin-bottom: 8px;
}

.cinema-desc {
  color: #666;
  font-size: 14px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.cinema-action {
  display: flex;
  align-items: center;
}

@media (max-width: 768px) {
  .cinema-card {
    flex-direction: column;
  }
  
  .cinema-cover {
    width: 100%;
    height: 160px;
  }
}
</style>
