<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import { adminShowtimeApi, adminMovieApi, adminCinemaApi } from '@/api/admin'
import type { Showtime, Movie, Cinema, Hall } from '@/types'
import { PlusOutlined, DeleteOutlined } from '@ant-design/icons-vue'
import dayjs from 'dayjs'

const loading = ref(false)
const showtimes = ref<Showtime[]>([])
const total = ref(0)
const modalVisible = ref(false)
const submitting = ref(false)

// 选项数据
const movies = ref<Movie[]>([])
const cinemas = ref<Cinema[]>([])
const halls = ref<Hall[]>([])

// 查询参数
const query = reactive({
  movieId: undefined as number | undefined,
  page: 1,
  size: 20
})

// 表单
const form = reactive({
  movieId: undefined as number | undefined,
  hallId: undefined as number | undefined,
  showDate: dayjs().format('YYYY-MM-DD'),
  startTime: '10:00',
  endTime: '12:00',
  price: 45
})

const selectedCinemaId = ref<number>()

// 表格列
const columns = [
  { title: 'ID', dataIndex: 'id', width: 60 },
  { title: '影片', key: 'movie', width: 150 },
  { title: '影院', key: 'cinema', width: 150 },
  { title: '影厅', key: 'hall', width: 100 },
  { title: '日期', dataIndex: 'showDate', width: 100 },
  { title: '时间', key: 'time', width: 120 },
  { title: '票价', dataIndex: 'price', width: 80 },
  { title: '剩余', dataIndex: 'availableSeats', width: 80 },
  { title: '操作', key: 'action', width: 80 }
]

// 获取列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await adminShowtimeApi.getList(query)
    showtimes.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (error) {
    console.error('获取场次列表失败', error)
  } finally {
    loading.value = false
  }
}

// 获取影片和影院选项
const fetchOptions = async () => {
  const [moviesRes, cinemasRes] = await Promise.all([
    adminMovieApi.getList({ size: 100 }),
    adminCinemaApi.getList({ size: 100 })
  ])
  movies.value = moviesRes.data?.records || []
  cinemas.value = cinemasRes.data?.records || []
}

// 影院变化时加载影厅
const handleCinemaChange = async (cinemaId: number) => {
  selectedCinemaId.value = cinemaId
  form.hallId = undefined
  if (cinemaId) {
    const res = await adminCinemaApi.getHalls(cinemaId)
    halls.value = res.data || []
  } else {
    halls.value = []
  }
}

// 分页变化
const handleTableChange = (pagination: any) => {
  query.page = pagination.current
  query.size = pagination.pageSize
  fetchList()
}

// 打开添加弹窗
const handleAdd = () => {
  Object.assign(form, {
    movieId: undefined,
    hallId: undefined,
    showDate: dayjs().format('YYYY-MM-DD'),
    startTime: '10:00',
    endTime: '12:00',
    price: 45
  })
  selectedCinemaId.value = undefined
  halls.value = []
  modalVisible.value = true
}

// 提交
const handleSubmit = async () => {
  if (!form.movieId || !form.hallId) {
    message.warning('请选择影片和影厅')
    return
  }
  submitting.value = true
  try {
    await adminShowtimeApi.create(form)
    message.success('添加成功')
    modalVisible.value = false
    fetchList()
  } catch (error) {
    // 错误已处理
  } finally {
    submitting.value = false
  }
}

// 删除
const handleDelete = (id: number) => {
  Modal.confirm({
    title: '确认删除',
    content: '删除场次将同时删除所有座位数据，确定要删除吗？',
    async onOk() {
      await adminShowtimeApi.delete(id)
      message.success('删除成功')
      fetchList()
    }
  })
}

onMounted(() => {
  fetchList()
  fetchOptions()
})
</script>

<template>
  <div class="showtime-manage">
    <div class="toolbar">
      <a-select
        v-model:value="query.movieId"
        placeholder="筛选影片"
        style="width: 200px"
        allowClear
        @change="fetchList"
      >
        <a-select-option v-for="m in movies" :key="m.id" :value="m.id">
          {{ m.title }}
        </a-select-option>
      </a-select>
      <a-button type="primary" @click="handleAdd">
        <PlusOutlined /> 添加场次
      </a-button>
    </div>

    <a-table
      :dataSource="showtimes"
      :columns="columns"
      :loading="loading"
      :pagination="{ current: query.page, pageSize: query.size, total }"
      rowKey="id"
      @change="handleTableChange"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'movie'">
          {{ record.movie?.title }}
        </template>
        <template v-else-if="column.key === 'cinema'">
          {{ record.cinema?.name }}
        </template>
        <template v-else-if="column.key === 'hall'">
          {{ record.hall?.name }}
        </template>
        <template v-else-if="column.key === 'time'">
          {{ record.startTime?.slice(0,5) }} - {{ record.endTime?.slice(0,5) }}
        </template>
        <template v-else-if="column.dataIndex === 'price'">
          ¥{{ record.price }}
        </template>
        <template v-else-if="column.key === 'action'">
          <a-button type="link" size="small" danger @click="handleDelete(record.id)">
            <DeleteOutlined /> 删除
          </a-button>
        </template>
      </template>
    </a-table>

    <!-- 添加弹窗 -->
    <a-modal
      v-model:open="modalVisible"
      title="添加场次"
      :confirmLoading="submitting"
      @ok="handleSubmit"
    >
      <a-form :model="form" layout="vertical">
        <a-form-item label="影片" required>
          <a-select v-model:value="form.movieId" placeholder="选择影片">
            <a-select-option v-for="m in movies" :key="m.id" :value="m.id">
              {{ m.title }}
            </a-select-option>
          </a-select>
        </a-form-item>
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="影院" required>
              <a-select v-model:value="selectedCinemaId" placeholder="选择影院" @change="handleCinemaChange">
                <a-select-option v-for="c in cinemas" :key="c.id" :value="c.id">
                  {{ c.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="影厅" required>
              <a-select v-model:value="form.hallId" placeholder="选择影厅" :disabled="!selectedCinemaId">
                <a-select-option v-for="h in halls" :key="h.id" :value="h.id">
                  {{ h.name }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
        </a-row>
        <a-row :gutter="16">
          <a-col :span="8">
            <a-form-item label="日期">
              <a-input v-model:value="form.showDate" type="date" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="开始时间">
              <a-input v-model:value="form.startTime" type="time" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="结束时间">
              <a-input v-model:value="form.endTime" type="time" />
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="票价">
          <a-input-number v-model:value="form.price" :min="1" prefix="¥" style="width: 100%" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<style scoped>
.toolbar {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16px;
}
</style>
