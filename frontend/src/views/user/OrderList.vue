<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { orderApi } from '@/api'
import type { Order } from '@/types'
import {
  ClockCircleOutlined,
  EnvironmentOutlined,
  CheckCircleOutlined,
  CloseCircleOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons-vue'

const router = useRouter()

const loading = ref(true)
const orders = ref<Order[]>([])
const activeTab = ref('')

// 状态标签配置
const statusConfig: Record<string, { color: string; text: string; icon: any }> = {
  PENDING: { color: 'orange', text: '待支付', icon: ClockCircleOutlined },
  PAID: { color: 'green', text: '已支付', icon: CheckCircleOutlined },
  USED: { color: 'blue', text: '已取票', icon: CheckCircleOutlined },
  CANCELLED: { color: 'default', text: '已取消', icon: CloseCircleOutlined },
  REFUNDED: { color: 'purple', text: '已退款', icon: ExclamationCircleOutlined }
}

// 获取订单列表
const fetchOrders = async () => {
  loading.value = true
  try {
    const res = await orderApi.getMyOrders({
      status: activeTab.value || undefined,
      page: 1,
      size: 50
    })
    orders.value = res.data?.records || []
  } catch (error) {
    console.error('获取订单失败', error)
  } finally {
    loading.value = false
  }
}

// Tab 切换
const handleTabChange = (key: string) => {
  activeTab.value = key
  fetchOrders()
}

// 解析座位
const getSeatLabels = (order: Order) => {
  try {
    const seats = JSON.parse(order.seatInfo)
    return seats.map((s: any) => s.label).join(', ')
  } catch {
    return ''
  }
}

// 跳转订单详情/支付
const handleOrderClick = (order: Order) => {
  if (order.status === 'PENDING') {
    router.push(`/orders/${order.id}/confirm`)
  } else if (order.status === 'PAID') {
    router.push(`/orders/${order.id}/success`)
  }
}

onMounted(() => {
  fetchOrders()
})
</script>

<template>
  <div class="order-list-page">
    <h1>我的订单</h1>

    <!-- Tab 筛选 -->
    <a-tabs v-model:activeKey="activeTab" @change="handleTabChange">
      <a-tab-pane key="" tab="全部" />
      <a-tab-pane key="PENDING" tab="待支付" />
      <a-tab-pane key="PAID" tab="已支付" />
      <a-tab-pane key="USED" tab="已取票" />
      <a-tab-pane key="CANCELLED" tab="已取消" />
    </a-tabs>

    <a-spin :spinning="loading">
      <div class="order-list">
        <div
          v-for="order in orders"
          :key="order.id"
          class="order-card"
          @click="handleOrderClick(order)"
        >
          <!-- 订单头部 -->
          <div class="order-header">
            <span class="order-no">订单号: {{ order.orderNo }}</span>
            <a-tag :color="statusConfig[order.status]?.color">
              <component :is="statusConfig[order.status]?.icon" />
              {{ statusConfig[order.status]?.text }}
            </a-tag>
          </div>

          <!-- 订单内容 -->
          <div class="order-content">
            <div class="poster" v-if="order.showtime?.movie?.poster">
              <img :src="order.showtime.movie.poster" :alt="order.showtime.movie.title" />
            </div>
            <div class="info">
              <h3>{{ order.showtime?.movie?.title }}</h3>
              <p>
                <EnvironmentOutlined />
                {{ order.showtime?.cinema?.name }}
              </p>
              <p>
                <ClockCircleOutlined />
                {{ order.showtime?.showDate }} {{ order.showtime?.startTime?.slice(0, 5) }}
              </p>
              <p class="seats">座位: {{ getSeatLabels(order) }}</p>
            </div>
            <div class="price">
              <span class="amount">¥{{ order.totalAmount }}</span>
              <span class="count">{{ order.seatCount }}张</span>
            </div>
          </div>

          <!-- 取票码 (已支付) -->
          <div class="ticket-code" v-if="order.status === 'PAID' && order.ticketCode">
            <span class="label">取票码:</span>
            <span class="code">{{ order.ticketCode }}</span>
          </div>

          <!-- 操作按钮 -->
          <div class="order-footer" v-if="order.status === 'PENDING'">
            <a-button type="primary" size="small">去支付</a-button>
          </div>
        </div>

        <!-- 空状态 -->
        <a-empty v-if="!loading && orders.length === 0" description="暂无订单" />
      </div>
    </a-spin>
  </div>
</template>

<style scoped>
.order-list-page {
  max-width: 800px;
  margin: 0 auto;
}

.order-list-page h1 {
  font-size: 24px;
  margin-bottom: 24px;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* 订单卡片 */
.order-card {
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: var(--shadow-sm);
  cursor: pointer;
  transition: all 0.3s;
}

.order-card:hover {
  box-shadow: var(--shadow-md);
}

/* 订单头部 */
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f0f0f0;
}

.order-no {
  color: var(--text-secondary);
  font-size: 13px;
}

/* 订单内容 */
.order-content {
  display: flex;
  gap: 16px;
}

.poster {
  width: 80px;
  height: 100px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.poster img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info {
  flex: 1;
}

.info h3 {
  font-size: 18px;
  margin-bottom: 8px;
}

.info p {
  display: flex;
  align-items: center;
  gap: 6px;
  color: var(--text-secondary);
  font-size: 14px;
  margin-bottom: 4px;
}

.info .seats {
  color: var(--color-primary);
  font-weight: 500;
}

.price {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: center;
}

.price .amount {
  font-size: 20px;
  font-weight: 700;
  color: var(--color-primary);
}

.price .count {
  color: var(--text-secondary);
  font-size: 13px;
}

/* 取票码 */
.ticket-code {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 16px;
  padding: 12px;
  background: #f0f9eb;
  border-radius: 8px;
}

.ticket-code .label {
  color: #67c23a;
}

.ticket-code .code {
  font-size: 20px;
  font-weight: 700;
  letter-spacing: 2px;
  color: #67c23a;
}

/* 订单底部 */
.order-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}
</style>
