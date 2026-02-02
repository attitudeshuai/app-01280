<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import { adminMovieApi } from '@/api/admin'
import type { Movie } from '@/types'
import { PlusOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons-vue'

const loading = ref(false)
const movies = ref<Movie[]>([])
const total = ref(0)
const modalVisible = ref(false)
const modalTitle = ref('添加影片')
const submitting = ref(false)

// 查询参数
const query = reactive({
  keyword: '',
  status: '',
  page: 1,
  size: 10
})

// 表单
const form = reactive<Partial<Movie>>({
  id: undefined,
  title: '',
  poster: '',
  genre: '',
  duration: 120,
  rating: 0,
  description: '',
  director: '',
  actors: '',
  releaseDate: '',
  country: '中国',
  language: '普通话',
  status: 'SHOWING' as any
})

// 表格列
const columns = [
  { title: 'ID', dataIndex: 'id', width: 60 },
  { title: '海报', dataIndex: 'poster', width: 80 },
  { title: '片名', dataIndex: 'title', ellipsis: true },
  { title: '类型', dataIndex: 'genre', width: 100 },
  { title: '时长', dataIndex: 'duration', width: 80 },
  { title: '评分', dataIndex: 'rating', width: 80 },
  { title: '状态', dataIndex: 'status', width: 100 },
  { title: '操作', key: 'action', width: 150 }
]

// 状态选项
const statusOptions = [
  { value: 'SHOWING', label: '热映中' },
  { value: 'COMING', label: '即将上映' },
  { value: 'OFFLINE', label: '已下架' }
]

// 获取列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await adminMovieApi.getList(query)
    movies.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (error) {
    console.error('获取影片列表失败', error)
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

// 打开添加弹窗
const handleAdd = () => {
  modalTitle.value = '添加影片'
  Object.assign(form, {
    id: undefined,
    title: '',
    poster: 'https://picsum.photos/seed/' + Date.now() + '/300/450',
    genre: '',
    duration: 120,
    rating: 0,
    description: '',
    director: '',
    actors: '',
    releaseDate: '',
    country: '中国',
    language: '普通话',
    status: 'SHOWING'
  })
  modalVisible.value = true
}

// 打开编辑弹窗
const handleEdit = (record: Movie) => {
  modalTitle.value = '编辑影片'
  Object.assign(form, record)
  modalVisible.value = true
}

// 提交表单
const handleSubmit = async () => {
  submitting.value = true
  try {
    if (form.id) {
      await adminMovieApi.update(form.id, form)
      message.success('更新成功')
    } else {
      await adminMovieApi.create(form)
      message.success('添加成功')
    }
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
    content: '确定要删除这部影片吗？',
    async onOk() {
      await adminMovieApi.delete(id)
      message.success('删除成功')
      fetchList()
    }
  })
}

onMounted(() => {
  fetchList()
})
</script>

<template>
  <div class="movie-manage">
    <div class="toolbar">
      <a-space>
        <a-input-search
          v-model:value="query.keyword"
          placeholder="搜索影片"
          style="width: 200px"
          @search="fetchList"
        />
        <a-select
          v-model:value="query.status"
          placeholder="状态"
          style="width: 120px"
          allowClear
          @change="fetchList"
        >
          <a-select-option v-for="opt in statusOptions" :key="opt.value" :value="opt.value">
            {{ opt.label }}
          </a-select-option>
        </a-select>
      </a-space>
      <a-button type="primary" @click="handleAdd">
        <PlusOutlined /> 添加影片
      </a-button>
    </div>

    <a-table
      :dataSource="movies"
      :columns="columns"
      :loading="loading"
      :pagination="{ current: query.page, pageSize: query.size, total }"
      rowKey="id"
      @change="handleTableChange"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.dataIndex === 'poster'">
          <a-avatar shape="square" :size="50" :src="record.poster" />
        </template>
        <template v-else-if="column.dataIndex === 'duration'">
          {{ record.duration }}分钟
        </template>
        <template v-else-if="column.dataIndex === 'status'">
          <a-tag :color="record.status === 'SHOWING' ? 'green' : record.status === 'COMING' ? 'blue' : 'default'">
            {{ statusOptions.find(o => o.value === record.status)?.label }}
          </a-tag>
        </template>
        <template v-else-if="column.key === 'action'">
          <a-space>
            <a-button type="link" size="small" @click="handleEdit(record)">
              <EditOutlined /> 编辑
            </a-button>
            <a-button type="link" size="small" danger @click="handleDelete(record.id)">
              <DeleteOutlined /> 删除
            </a-button>
          </a-space>
        </template>
      </template>
    </a-table>

    <!-- 编辑弹窗 -->
    <a-modal
      v-model:open="modalVisible"
      :title="modalTitle"
      :confirmLoading="submitting"
      width="600px"
      @ok="handleSubmit"
    >
      <a-form :model="form" layout="vertical">
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="片名" required>
              <a-input v-model:value="form.title" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="类型">
              <a-input v-model:value="form.genre" placeholder="如: 科幻,动作" />
            </a-form-item>
          </a-col>
        </a-row>
        <a-row :gutter="16">
          <a-col :span="8">
            <a-form-item label="时长(分钟)">
              <a-input-number v-model:value="form.duration" :min="1" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="评分">
              <a-input-number v-model:value="form.rating" :min="0" :max="10" :step="0.1" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="状态">
              <a-select v-model:value="form.status">
                <a-select-option v-for="opt in statusOptions" :key="opt.value" :value="opt.value">
                  {{ opt.label }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="海报URL">
          <a-input v-model:value="form.poster" />
        </a-form-item>
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="导演">
              <a-input v-model:value="form.director" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="主演">
              <a-input v-model:value="form.actors" />
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="简介">
          <a-textarea v-model:value="form.description" :rows="3" />
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
