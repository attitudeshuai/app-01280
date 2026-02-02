<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import {
  DashboardOutlined,
  VideoCameraOutlined,
  HomeOutlined,
  ScheduleOutlined,
  OrderedListOutlined,
  UserOutlined,
  LogoutOutlined,
  MenuFoldOutlined,
  MenuUnfoldOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

// 侧边栏折叠状态
const collapsed = ref(false)

// 当前选中菜单
const selectedKeys = computed(() => {
  const path = route.path
  if (path.includes('/admin/cinemas')) return ['cinemas']
  if (path.includes('/admin/movies')) return ['movies']
  if (path.includes('/admin/showtimes')) return ['showtimes']
  if (path.includes('/admin/orders')) return ['orders']
  if (path.includes('/admin/users')) return ['users']
  return ['dashboard']
})

// 菜单项
const menuItems = [
  { key: 'dashboard', icon: DashboardOutlined, label: '数据概览', path: '/admin' },
  { key: 'cinemas', icon: HomeOutlined, label: '影院管理', path: '/admin/cinemas' },
  { key: 'movies', icon: VideoCameraOutlined, label: '影片管理', path: '/admin/movies' },
  { key: 'showtimes', icon: ScheduleOutlined, label: '场次管理', path: '/admin/showtimes' },
  { key: 'orders', icon: OrderedListOutlined, label: '订单管理', path: '/admin/orders' },
  { key: 'users', icon: UserOutlined, label: '用户管理', path: '/admin/users' }
]

// 菜单点击
const handleMenuClick = ({ key }: { key: string }) => {
  const item = menuItems.find(m => m.key === key)
  if (item) {
    router.push(item.path)
  }
}

// 退出登录
const handleLogout = () => {
  userStore.logout()
  router.push('/')
}

// 返回用户端
const goUserSite = () => {
  router.push('/')
}
</script>

<template>
  <a-layout class="admin-layout">
    <!-- 侧边栏 -->
    <a-layout-sider
      v-model:collapsed="collapsed"
      :trigger="null"
      collapsible
      width="260"
      :collapsedWidth="64"
      class="sider"
    >
      <!-- Logo -->
      <div class="sider-logo">
        <VideoCameraOutlined class="logo-icon" />
        <span v-if="!collapsed" class="logo-text">管理后台</span>
      </div>

      <!-- 菜单 -->
      <a-menu
        mode="inline"
        :selectedKeys="selectedKeys"
        theme="dark"
        @click="handleMenuClick"
      >
        <a-menu-item v-for="item in menuItems" :key="item.key">
          <component :is="item.icon" />
          <span>{{ item.label }}</span>
        </a-menu-item>
      </a-menu>
    </a-layout-sider>

    <a-layout>
      <!-- 顶部栏 -->
      <a-layout-header class="admin-header">
        <!-- 折叠按钮 -->
        <a-button type="text" @click="collapsed = !collapsed" class="trigger-btn">
          <MenuUnfoldOutlined v-if="collapsed" />
          <MenuFoldOutlined v-else />
        </a-button>

        <!-- 面包屑 -->
        <a-breadcrumb class="breadcrumb">
          <a-breadcrumb-item>管理后台</a-breadcrumb-item>
          <a-breadcrumb-item>{{ route.meta.title }}</a-breadcrumb-item>
        </a-breadcrumb>

        <!-- 右侧操作 -->
        <div class="header-right">
          <a-button type="text" @click="goUserSite">返回用户端</a-button>
          <a-dropdown>
            <a-avatar :src="userStore.user?.avatar" class="user-avatar">
              {{ userStore.user?.nickname?.charAt(0) }}
            </a-avatar>
            <template #overlay>
              <a-menu>
                <a-menu-item disabled>
                  <UserOutlined />
                  {{ userStore.user?.nickname }}
                </a-menu-item>
                <a-menu-divider />
                <a-menu-item key="logout" @click="handleLogout">
                  <LogoutOutlined />
                  退出登录
                </a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>
        </div>
      </a-layout-header>

      <!-- 内容区 -->
      <a-layout-content class="admin-content">
        <router-view v-slot="{ Component }">
          <transition name="page" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </a-layout-content>
    </a-layout>
  </a-layout>
</template>

<style scoped>
.admin-layout {
  min-height: 100vh;
}

.sider {
  background: #001529;
}

.sider-logo {
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo-icon {
  font-size: 28px;
  color: var(--color-primary);
}

.logo-text {
  font-size: 18px;
  font-weight: 600;
  color: #fff;
}

.admin-header {
  background: #fff;
  padding: 0 24px;
  display: flex;
  align-items: center;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
}

.trigger-btn {
  font-size: 18px;
}

.breadcrumb {
  margin-left: 24px;
  flex: 1;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-avatar {
  cursor: pointer;
  background: var(--color-primary);
}

.admin-content {
  margin: 24px;
  padding: 24px;
  background: #fff;
  border-radius: 8px;
  min-height: calc(100vh - 64px - 48px);
}
</style>
