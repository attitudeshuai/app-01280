<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { message, Modal } from 'ant-design-vue'
import { adminCinemaApi } from '@/api/admin'
import type { Cinema, Hall } from '@/types'
import { PlusOutlined, EditOutlined, DeleteOutlined, SettingOutlined } from '@ant-design/icons-vue'

const loading = ref(false)
const cinemas = ref<Cinema[]>([])
const total = ref(0)
const modalVisible = ref(false)
const modalTitle = ref('添加影院')
const submitting = ref(false)

// 影厅管理
const hallModalVisible = ref(false)
const currentCinema = ref<Cinema | null>(null)
const halls = ref<Hall[]>([])

// 查询参数
const query = reactive({
  keyword: '',
  page: 1,
  size: 10
})

// 表单
const form = reactive<Partial<Cinema>>({
  id: undefined,
  name: '',
  city: '北京',
  district: '',
  address: '',
  phone: '',
  coverImage: '',
  description: ''
})

// 影厅表单
const hallForm = reactive({
  id: undefined as number | undefined,
  name: '',
  hallType: 'NORMAL',
  seatRows: 10,
  seatCols: 12
})

// 表格列
const columns = [
  { title: 'ID', dataIndex: 'id', width: 60 },
  { title: '名称', dataIndex: 'name', ellipsis: true },
  { title: '城市', dataIndex: 'city', width: 80 },
  { title: '地址', dataIndex: 'address', ellipsis: true },
  { title: '电话', dataIndex: 'phone', width: 120 },
  { title: '状态', dataIndex: 'status', width: 80 },
  { title: '操作', key: 'action', width: 200 }
]

// 获取列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await adminCinemaApi.getList(query)
    cinemas.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (error) {
    console.error('获取影院列表失败', error)
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
  modalTitle.value = '添加影院'
  Object.assign(form, {
    id: undefined,
    name: '',
    city: '北京',
    district: '',
    address: '',
    phone: '',
    coverImage: 'https://picsum.photos/seed/' + Date.now() + '/800/400',
    description: ''
  })
  modalVisible.value = true
}

// 编辑
const handleEdit = (record: Cinema) => {
  modalTitle.value = '编辑影院'
  Object.assign(form, record)
  modalVisible.value = true
}

// 提交
const handleSubmit = async () => {
  submitting.value = true
  try {
    if (form.id) {
      await adminCinemaApi.update(form.id, form)
      message.success('更新成功')
    } else {
      await adminCinemaApi.create(form)
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
    content: '删除影院将同时删除所有影厅，确定要删除吗？',
    async onOk() {
      await adminCinemaApi.delete(id)
      message.success('删除成功')
      fetchList()
    }
  })
}

// 管理影厅
const handleManageHalls = async (cinema: Cinema) => {
  currentCinema.value = cinema
  const res = await adminCinemaApi.getHalls(cinema.id)
  halls.value = res.data || []
  hallModalVisible.value = true
}

// 添加影厅
const handleAddHall = async () => {
  if (!currentCinema.value) return
  await adminCinemaApi.createHall(currentCinema.value.id, {
    name: `${halls.value.length + 1}号厅`,
    hallType: 'NORMAL',
    seatRows: 10,
    seatCols: 12
  })
  message.success('添加成功')
  const res = await adminCinemaApi.getHalls(currentCinema.value.id)
  halls.value = res.data || []
}

// 删除影厅
const handleDeleteHall = async (id: number) => {
  await adminCinemaApi.deleteHall(id)
  message.success('删除成功')
  if (currentCinema.value) {
    const res = await adminCinemaApi.getHalls(currentCinema.value.id)
    halls.value = res.data || []
  }
}

onMounted(() => {
  fetchList()
})
</script>

<template>
  <div class="cinema-manage">
    <div class="toolbar">
      <a-input-search
        v-model:value="query.keyword"
        placeholder="搜索影院"
        style="width: 250px"
        @search="fetchList"
      />
      <a-button type="primary" @click="handleAdd">
        <PlusOutlined /> 添加影院
      </a-button>
    </div>

    <a-table
      :dataSource="cinemas"
      :columns="columns"
      :loading="loading"
      :pagination="{ current: query.page, pageSize: query.size, total }"
      rowKey="id"
      @change="handleTableChange"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.dataIndex === 'status'">
          <a-tag :color="record.status === 1 ? 'green' : 'red'">
            {{ record.status === 1 ? '营业' : '关闭' }}
          </a-tag>
        </template>
        <template v-else-if="column.key === 'action'">
          <a-space>
            <a-button type="link" size="small" @click="handleManageHalls(record)">
              <SettingOutlined /> 影厅
            </a-button>
            <a-button type="link" size="small" @click="handleEdit(record)">
              <EditOutlined /> 编辑
            </a-button>
            <a-button type="link" size="small" danger @click="handleDelete(record.id)">
              <DeleteOutlined />
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
            <a-form-item label="名称" required>
              <a-input v-model:value="form.name" />
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="城市">
              <a-input v-model:value="form.city" />
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="区域">
              <a-input v-model:value="form.district" />
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="地址" required>
          <a-input v-model:value="form.address" />
        </a-form-item>
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="电话">
              <a-input v-model:value="form.phone" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="封面图">
              <a-input v-model:value="form.coverImage" />
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="简介">
          <a-textarea v-model:value="form.description" :rows="3" />
        </a-form-item>
      </a-form>
    </a-modal>

    <!-- 影厅管理弹窗 -->
    <a-modal
      v-model:open="hallModalVisible"
      :title="`影厅管理 - ${currentCinema?.name}`"
      :footer="null"
      width="500px"
    >
      <a-list :dataSource="halls" :loading="false">
        <template #header>
          <a-button type="primary" block @click="handleAddHall">
            <PlusOutlined /> 添加影厅
          </a-button>
        </template>
        <template #renderItem="{ item }">
          <a-list-item>
            <a-list-item-meta
              :title="item.name"
              :description="`${item.hallType} | ${item.seatRows}行 × ${item.seatCols}列 = ${item.totalSeats}座`"
            />
            <template #actions>
              <a-button type="link" danger size="small" @click="handleDeleteHall(item.id)">
                删除
              </a-button>
            </template>
          </a-list-item>
        </template>
      </a-list>
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
