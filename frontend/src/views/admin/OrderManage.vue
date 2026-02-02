<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { adminOrderApi } from '@/api/admin'
import type { Order } from '@/types'

const loading = ref(false)
const orders = ref<Order[]>([])
const total = ref(0)

// 查询参数
const query = reactive({
  status: '',
  orderNo: '',
  page: 1,
  size: 20
})

// 状态选项
const statusOptions = [
  { value: 'PENDING', label: '待支付', color: 'orange' },
  { value: 'PAID', label: '已支付', color: 'green' },
  { value: 'USED', label: '已取票', color: 'blue' },
  { value: 'CANCELLED', label: '已取消', color: 'default' },
  { value: 'REFUNDED', label: '已退款', color: 'purple' }
]

// 表格列
const columns = [
  { title: '订单号', dataIndex: 'orderNo', width: 180 },
  { title: '影片', key: 'movie', ellipsis: true },
  { title: '场次', key: 'showtime', width: 150 },
  { title: '座位数', dataIndex: 'seatCount', width: 80 },
  { title: '金额', dataIndex: 'totalAmount', width: 100 },
  { title: '状态', dataIndex: 'status', width: 100 },
  { title: '取票码', dataIndex: 'ticketCode', width: 100 },
  { title: '创建时间', dataIndex: 'createdAt', width: 160 }
]

// 获取列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await adminOrderApi.getList(query)
    orders.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (error) {
    console.error('获取订单列表失败', error)
  } finally {
    loading.value = false
  }
}

// 分页变化
const handleTableChange = (pagination: any) => {
  query.page = pagination.current
  query.size = pagination.pageSize
  fetchList()
}

// 获取状态配置
const getStatusConfig = (status: string) => {
  return statusOptions.find(o => o.value === status) || { label: status, color: 'default' }
}

onMounted(() => {
  fetchList()
})
</script>

<template>
  <div class="order-manage">
    <div class="toolbar">
      <a-space>
        <a-input-search
          v-model:value="query.orderNo"
          placeholder="搜索订单号"
          style="width: 200px"
          @search="fetchList"
        />
        <a-select
          v-model:value="query.status"
          placeholder="订单状态"
          style="width: 120px"
          allowClear
          @change="fetchList"
        >
          <a-select-option v-for="opt in statusOptions" :key="opt.value" :value="opt.value">
            {{ opt.label }}
          </a-select-option>
        </a-select>
      </a-space>
    </div>

    <a-table
      :dataSource="orders"
      :columns="columns"
      :loading="loading"
      :pagination="{ current: query.page, pageSize: query.size, total }"
      rowKey="id"
      @change="handleTableChange"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'movie'">
          {{ record.showtime?.movie?.title }}
        </template>
        <template v-else-if="column.key === 'showtime'">
          {{ record.showtime?.showDate }} {{ record.showtime?.startTime?.slice(0,5) }}
        </template>
        <template v-else-if="column.dataIndex === 'totalAmount'">
          ¥{{ record.totalAmount }}
        </template>
        <template v-else-if="column.dataIndex === 'status'">
          <a-tag :color="getStatusConfig(record.status).color">
            {{ getStatusConfig(record.status).label }}
          </a-tag>
        </template>
        <template v-else-if="column.dataIndex === 'ticketCode'">
          <span v-if="record.ticketCode" class="ticket-code">{{ record.ticketCode }}</span>
          <span v-else>-</span>
        </template>
      </template>
    </a-table>
  </div>
</template>

<style scoped>
.toolbar {
  margin-bottom: 16px;
}

.ticket-code {
  font-family: monospace;
  font-weight: 600;
  color: var(--color-primary);
}
</style>
