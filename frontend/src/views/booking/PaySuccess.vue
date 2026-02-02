<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { message } from 'ant-design-vue'
import { orderApi } from '@/api'
import type { Order } from '@/types'
import QrcodeVue from 'qrcode.vue'
import {
  CheckCircleFilled,
  EnvironmentOutlined,
  ClockCircleOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const route = useRoute()

const orderId = Number(route.params.id)
const loading = ref(true)
const order = ref<Order | null>(null)

// 解析座位信息
const seatLabels = computed(() => {
  if (!order.value?.seatInfo) return ''
  try {
    const seats = JSON.parse(order.value.seatInfo)
    return seats.map((s: any) => s.label).join(', ')
  } catch {
    return ''
  }
})

// 二维码内容
const qrcodeValue = computed(() => {
  if (!order.value) return ''
  return `TICKET:${order.value.ticketCode}|ORDER:${order.value.orderNo}`
})

// 获取订单
const fetchOrder = async () => {
  loading.value = true
  try {
    const res = await orderApi.getDetail(orderId)
    order.value = res.data

    // 检查订单状态
    if (order.value.status !== 'PAID' && order.value.status !== 'USED') {
      message.error('订单状态异常')
      router.replace('/user/orders')
    }
  } catch (error) {
    message.error('获取订单失败')
    router.back()
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchOrder()
})
</script>

<template>
  <div class="pay-success-page">
    <a-spin :spinning="loading">
      <div class="success-card" v-if="order">
        <!-- 成功图标 -->
        <div class="success-header">
          <CheckCircleFilled class="success-icon" />
          <h1>支付成功</h1>
          <p>请凭取票码到影院自助机取票</p>
        </div>

        <!-- 取票码 -->
        <div class="ticket-code-section">
          <div class="qrcode">
            <QrcodeVue :value="qrcodeValue" :size="160" level="H" />
          </div>
          <div class="code-info">
            <span class="label">取票码</span>
            <div class="code-value">
              <span>{{ order.ticketCode }}</span>
            </div>
          </div>
        </div>

        <!-- 订单信息 -->
        <a-divider />
        <div class="order-info">
          <h3>{{ order.showtime?.movie?.title }}</h3>
          <div class="info-row">
            <EnvironmentOutlined />
            <span>{{ order.showtime?.cinema?.name }} - {{ order.showtime?.hall?.name }}</span>
          </div>
          <div class="info-row">
            <ClockCircleOutlined />
            <span>{{ order.showtime?.showDate }} {{ order.showtime?.startTime?.slice(0, 5) }}</span>
          </div>
          <div class="info-row">
            <span class="seat-label">座位:</span>
            <span class="seat-value">{{ seatLabels }}</span>
          </div>
        </div>

        <!-- 订单详情 -->
        <div class="order-detail">
          <div class="detail-item">
            <span class="label">订单编号</span>
            <span class="value">{{ order.orderNo }}</span>
          </div>
          <div class="detail-item">
            <span class="label">支付方式</span>
            <span class="value">{{ order.payType === 'MOCK' ? '模拟支付' : order.payType }}</span>
          </div>
          <div class="detail-item">
            <span class="label">支付金额</span>
            <span class="value price">¥{{ order.totalAmount }}</span>
          </div>
          <div class="detail-item">
            <span class="label">支付时间</span>
            <span class="value">{{ order.payTime }}</span>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="actions">
          <a-button size="large" @click="router.push('/user/orders')">
            查看订单
          </a-button>
          <a-button type="primary" size="large" @click="router.push('/')">
            返回首页
          </a-button>
        </div>

        <!-- 温馨提示 -->
        <div class="tips">
          <h4>温馨提示</h4>
          <ul>
            <li>请在开场前30分钟到达影院取票</li>
            <li>凭取票码在自助取票机上取票</li>
            <li>如有疑问请联系影院工作人员</li>
          </ul>
        </div>
      </div>
    </a-spin>
  </div>
</template>

<style scoped>
.pay-success-page {
  max-width: 500px;
  margin: 0 auto;
}

.success-card {
  background: white;
  border-radius: 16px;
  padding: 32px;
  box-shadow: var(--shadow-md);
}

/* 成功头部 */
.success-header {
  text-align: center;
  margin-bottom: 32px;
}

.success-icon {
  font-size: 64px;
  color: var(--color-success);
}

.success-header h1 {
  font-size: 28px;
  margin: 16px 0 8px;
}

.success-header p {
  color: var(--text-secondary);
}

/* 取票码区域 */
.ticket-code-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 24px;
  background: #f8f9fa;
  border-radius: 12px;
}

.qrcode {
  padding: 16px;
  background: white;
  border-radius: 8px;
  margin-bottom: 16px;
}

.code-info {
  text-align: center;
}

.code-info .label {
  color: var(--text-secondary);
  font-size: 14px;
}

.code-value {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
}

.code-value span:first-child {
  font-size: 32px;
  font-weight: 700;
  letter-spacing: 4px;
  color: var(--color-primary);
}

/* 订单信息 */
.order-info {
  margin-bottom: 24px;
}

.order-info h3 {
  font-size: 20px;
  margin-bottom: 12px;
}

.info-row {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--text-secondary);
  margin-bottom: 8px;
}

.seat-label {
  color: var(--text-secondary);
}

.seat-value {
  color: var(--color-primary);
  font-weight: 500;
}

/* 订单详情 */
.order-detail {
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
  margin-bottom: 24px;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.detail-item:last-child {
  margin-bottom: 0;
}

.detail-item .label {
  color: var(--text-secondary);
}

.detail-item .price {
  color: var(--color-primary);
  font-weight: 600;
}

/* 操作按钮 */
.actions {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
}

.actions .ant-btn {
  flex: 1;
  height: 48px;
}

/* 温馨提示 */
.tips {
  padding: 16px;
  background: #e7f3ff;
  border-radius: 8px;
}

.tips h4 {
  font-size: 14px;
  margin-bottom: 8px;
  color: #0d6efd;
}

.tips ul {
  margin: 0;
  padding-left: 20px;
  color: #666;
  font-size: 13px;
}

.tips li {
  margin-bottom: 4px;
}
</style>
