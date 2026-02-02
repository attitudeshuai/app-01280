<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { message } from 'ant-design-vue'
import { orderApi } from '@/api'
import type { Order } from '@/types'
import {
  ClockCircleOutlined,
  EnvironmentOutlined,
  VideoCameraOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const route = useRoute()

const orderId = Number(route.params.id)
const loading = ref(true)
const paying = ref(false)

const order = ref<Order | null>(null)
const payType = ref('MOCK')

// 倒计时
const countdown = ref(0)
let countdownTimer: number

// 解析座位信息
const seatList = computed(() => {
  if (!order.value?.seatInfo) return []
  try {
    return JSON.parse(order.value.seatInfo)
  } catch {
    return []
  }
})

// 座位标签
const seatLabels = computed(() => {
  return seatList.value.map((s: any) => s.label).join(', ')
})

// 倒计时格式化
const countdownText = computed(() => {
  const minutes = Math.floor(countdown.value / 60)
  const seconds = countdown.value % 60
  return `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
})

// 获取订单
const fetchOrder = async () => {
  loading.value = true
  try {
    const res = await orderApi.getDetail(orderId)
    order.value = res.data

    // 检查订单状态
    if (order.value.status !== 'PENDING') {
      if (order.value.status === 'PAID') {
        router.replace(`/orders/${orderId}/success`)
      } else {
        message.error('订单状态异常')
        router.replace('/user/orders')
      }
      return
    }

    // 计算倒计时
    const expireTime = new Date(order.value.expireTime).getTime()
    const now = Date.now()
    countdown.value = Math.max(0, Math.floor((expireTime - now) / 1000))

    // 启动倒计时
    countdownTimer = window.setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) {
        clearInterval(countdownTimer)
        message.error('订单已过期')
        router.replace('/user/orders')
      }
    }, 1000)
  } catch (error) {
    message.error('获取订单失败')
    router.back()
  } finally {
    loading.value = false
  }
}

// 支付
const handlePay = async () => {
  paying.value = true
  try {
    await orderApi.pay(orderId, payType.value)
    message.success('支付成功!')
    router.replace(`/orders/${orderId}/success`)
  } catch (error) {
    // 错误已在拦截器处理
  } finally {
    paying.value = false
  }
}

// 取消订单
const handleCancel = async () => {
  try {
    await orderApi.cancel(orderId)
    message.success('订单已取消')
    router.replace('/user/orders')
  } catch (error) {
    // 错误已在拦截器处理
  }
}

onMounted(() => {
  fetchOrder()
})

onUnmounted(() => {
  clearInterval(countdownTimer)
})
</script>

<template>
  <div class="order-confirm-page">
    <a-spin :spinning="loading">
      <div class="order-card" v-if="order">
        <!-- 倒计时 -->
        <div class="countdown-bar">
          <ClockCircleOutlined />
          <span>请在 <strong>{{ countdownText }}</strong> 内完成支付</span>
        </div>

        <!-- 影片信息 -->
        <div class="movie-info">
          <div class="poster">
            <img :src="order.showtime?.movie?.poster" :alt="order.showtime?.movie?.title" />
          </div>
          <div class="info">
            <h2>{{ order.showtime?.movie?.title }}</h2>
            <p>
              <VideoCameraOutlined />
              {{ order.showtime?.movie?.genre }} | {{ order.showtime?.movie?.duration }}分钟
            </p>
            <p>
              <EnvironmentOutlined />
              {{ order.showtime?.cinema?.name }} - {{ order.showtime?.hall?.name }}
            </p>
            <p>
              <ClockCircleOutlined />
              {{ order.showtime?.showDate }} {{ order.showtime?.startTime?.slice(0, 5) }}
            </p>
          </div>
        </div>

        <!-- 订单详情 -->
        <a-divider />
        <div class="order-detail">
          <div class="detail-row">
            <span class="label">订单编号</span>
            <span class="value">{{ order.orderNo }}</span>
          </div>
          <div class="detail-row">
            <span class="label">座位</span>
            <span class="value seats">{{ seatLabels }}</span>
          </div>
          <div class="detail-row">
            <span class="label">票价</span>
            <span class="value">{{ order.seatCount }}张 × ¥{{ order.unitPrice }}</span>
          </div>
          <div class="detail-row total">
            <span class="label">应付金额</span>
            <span class="value price">¥{{ order.totalAmount }}</span>
          </div>
        </div>

        <!-- 支付方式 -->
        <a-divider />
        <div class="pay-method">
          <h3>选择支付方式</h3>
          <a-radio-group v-model:value="payType" size="large">
            <a-radio-button value="MOCK">快捷支付</a-radio-button>
            <a-radio-button value="ALIPAY" disabled>支付宝</a-radio-button>
            <a-radio-button value="WECHAT" disabled>微信支付</a-radio-button>
          </a-radio-group>
        </div>

        <!-- 操作按钮 -->
        <div class="actions">
          <a-button size="large" @click="handleCancel">取消订单</a-button>
          <a-button
            type="primary"
            size="large"
            :loading="paying"
            @click="handlePay"
          >
            立即支付 ¥{{ order.totalAmount }}
          </a-button>
        </div>
      </div>
    </a-spin>
  </div>
</template>

<style scoped>
.order-confirm-page {
  max-width: 600px;
  margin: 0 auto;
}

.order-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: var(--shadow-md);
}

/* 倒计时 */
.countdown-bar {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px;
  background: #fff3cd;
  color: #856404;
  border-radius: 8px;
  margin-bottom: 24px;
}

.countdown-bar strong {
  font-size: 20px;
  color: #dc3545;
}

/* 影片信息 */
.movie-info {
  display: flex;
  gap: 20px;
}

.poster {
  width: 120px;
  height: 160px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
}

.poster img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.movie-info .info {
  flex: 1;
}

.movie-info h2 {
  font-size: 22px;
  margin-bottom: 12px;
}

.movie-info p {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--text-secondary);
  margin-bottom: 8px;
}

/* 订单详情 */
.order-detail {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-row .label {
  color: var(--text-secondary);
}

.detail-row .value {
  font-weight: 500;
}

.detail-row .seats {
  color: var(--color-primary);
}

.detail-row.total {
  padding-top: 12px;
  border-top: 1px dashed #eee;
}

.detail-row .price {
  font-size: 24px;
  font-weight: 700;
  color: var(--color-primary);
}

/* 支付方式 */
.pay-method h3 {
  font-size: 16px;
  margin-bottom: 16px;
}

/* 操作按钮 */
.actions {
  display: flex;
  gap: 16px;
  margin-top: 24px;
}

.actions .ant-btn {
  flex: 1;
  height: 48px;
}
</style>
