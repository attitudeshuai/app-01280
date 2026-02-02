<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { message } from 'ant-design-vue'
import { adminUserApi } from '@/api/admin'
import type { User } from '@/types'

const loading = ref(false)
const users = ref<User[]>([])
const total = ref(0)

// 查询参数
const query = reactive({
  keyword: '',
  role: '',
  page: 1,
  size: 20
})

// 表格列
const columns = [
  { title: 'ID', dataIndex: 'id', width: 60 },
  { title: '头像', dataIndex: 'avatar', width: 60 },
  { title: '昵称', dataIndex: 'nickname', width: 120 },
  { title: '手机号', dataIndex: 'phone', width: 120 },
  { title: '邮箱', dataIndex: 'email', ellipsis: true },
  { title: '角色', dataIndex: 'role', width: 100 },
  { title: '状态', dataIndex: 'status', width: 100 },
  { title: '注册时间', dataIndex: 'createdAt', width: 160 },
  { title: '操作', key: 'action', width: 150 }
]

// 获取列表
const fetchList = async () => {
  loading.value = true
  try {
    const res = await adminUserApi.getList(query)
    users.value = res.data?.records || []
    total.value = res.data?.total || 0
  } catch (error) {
    console.error('获取用户列表失败', error)
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

// 切换状态
const handleToggleStatus = async (user: User) => {
  const newStatus = user.status === 1 ? 0 : 1
  await adminUserApi.updateStatus(user.id, newStatus)
  message.success(newStatus === 1 ? '已启用' : '已禁用')
  fetchList()
}

// 切换角色
const handleToggleRole = async (user: User) => {
  const newRole = user.role === 'ADMIN' ? 'USER' : 'ADMIN'
  await adminUserApi.updateRole(user.id, newRole)
  message.success('角色已更新')
  fetchList()
}

onMounted(() => {
  fetchList()
})
</script>

<template>
  <div class="user-manage">
    <div class="toolbar">
      <a-space>
        <a-input-search
          v-model:value="query.keyword"
          placeholder="搜索用户"
          style="width: 200px"
          @search="fetchList"
        />
        <a-select
          v-model:value="query.role"
          placeholder="角色"
          style="width: 120px"
          allowClear
          @change="fetchList"
        >
          <a-select-option value="USER">普通用户</a-select-option>
          <a-select-option value="ADMIN">管理员</a-select-option>
        </a-select>
      </a-space>
    </div>

    <a-table
      :dataSource="users"
      :columns="columns"
      :loading="loading"
      :pagination="{ current: query.page, pageSize: query.size, total }"
      rowKey="id"
      @change="handleTableChange"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.dataIndex === 'avatar'">
          <a-avatar :src="record.avatar" :size="36">
            {{ record.nickname?.charAt(0) }}
          </a-avatar>
        </template>
        <template v-else-if="column.dataIndex === 'role'">
          <a-tag :color="record.role === 'ADMIN' ? 'gold' : 'blue'">
            {{ record.role === 'ADMIN' ? '管理员' : '用户' }}
          </a-tag>
        </template>
        <template v-else-if="column.dataIndex === 'status'">
          <a-tag :color="record.status === 1 ? 'green' : 'red'">
            {{ record.status === 1 ? '正常' : '禁用' }}
          </a-tag>
        </template>
        <template v-else-if="column.key === 'action'">
          <a-space>
            <a-button type="link" size="small" @click="handleToggleRole(record)">
              {{ record.role === 'ADMIN' ? '取消管理员' : '设为管理员' }}
            </a-button>
            <a-button 
              type="link" 
              size="small" 
              :danger="record.status === 1"
              @click="handleToggleStatus(record)"
            >
              {{ record.status === 1 ? '禁用' : '启用' }}
            </a-button>
          </a-space>
        </template>
      </template>
    </a-table>
  </div>
</template>

<style scoped>
.toolbar {
  margin-bottom: 16px;
}
</style>
