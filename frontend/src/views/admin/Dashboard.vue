<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { adminStatsApi } from '@/api/admin'
import {
  ShoppingCartOutlined,
  DollarOutlined,
  UserOutlined,
  VideoCameraOutlined,
  RiseOutlined
} from '@ant-design/icons-vue'

interface Stats {
  todayOrders: number
  todayRevenue: number
  totalOrders: number
  pendingOrders: number
  totalUsers: number
  showingMovies: number
}

const loading = ref(true)
const stats = ref<Stats>({
  todayOrders: 0,
  todayRevenue: 0,
  totalOrders: 0,
  pendingOrders: 0,
  totalUsers: 0,
  showingMovies: 0
})

const fetchStats = async () => {
  loading.value = true
  try {
    const res = await adminStatsApi.getStats()
    stats.value = res.data
  } catch (error) {
    console.error('获取统计数据失败', error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchStats()
})
</script>

<template>
  <div class="dashboard-page">
    <h2>数据概览</h2>
    
    <a-spin :spinning="loading">
      <a-row :gutter="24" class="stat-cards">
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card>
            <a-statistic
              title="今日订单"
              :value="stats.todayOrders"
              :value-style="{ color: '#d63384' }"
            >
              <template #prefix>
                <ShoppingCartOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card>
            <a-statistic
              title="今日营业额"
              :value="stats.todayRevenue"
              prefix="¥"
              :precision="2"
              :value-style="{ color: '#198754' }"
            >
              <template #prefix>
                <DollarOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card>
            <a-statistic
              title="总用户数"
              :value="stats.totalUsers"
              :value-style="{ color: '#0dcaf0' }"
            >
              <template #prefix>
                <UserOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        
        <a-col :xs="24" :sm="12" :lg="6">
          <a-card>
            <a-statistic
              title="热映影片"
              :value="stats.showingMovies"
              :value-style="{ color: '#ffc107' }"
            >
              <template #prefix>
                <VideoCameraOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
      </a-row>

      <a-row :gutter="24" style="margin-top: 24px">
        <a-col :xs="24" :lg="12">
          <a-card title="订单统计">
            <div class="stat-item">
              <span>总订单数</span>
              <span class="value">{{ stats.totalOrders }}</span>
            </div>
            <div class="stat-item">
              <span>待支付订单</span>
              <span class="value warning">{{ stats.pendingOrders }}</span>
            </div>
          </a-card>
        </a-col>
        
        <a-col :xs="24" :lg="12">
          <a-card title="快捷操作">
            <a-space wrap>
              <a-button type="primary" @click="$router.push('/admin/movies')">
                <VideoCameraOutlined /> 管理影片
              </a-button>
              <a-button @click="$router.push('/admin/showtimes')">
                <RiseOutlined /> 排片管理
              </a-button>
              <a-button @click="$router.push('/admin/orders')">
                <ShoppingCartOutlined /> 查看订单
              </a-button>
            </a-space>
          </a-card>
        </a-col>
      </a-row>
    </a-spin>
  </div>
</template>

<style scoped>
.dashboard-page h2 {
  margin-bottom: 24px;
}

.stat-cards .ant-card {
  margin-bottom: 16px;
}

.stat-item {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;
}

.stat-item:last-child {
  border-bottom: none;
}

.stat-item .value {
  font-size: 20px;
  font-weight: 600;
}

.stat-item .value.warning {
  color: #ffc107;
}
</style>
