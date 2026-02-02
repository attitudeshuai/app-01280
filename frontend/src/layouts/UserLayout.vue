<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useAppStore } from '@/stores/app'
import {
  HomeOutlined,
  VideoCameraOutlined,
  UserOutlined,
  LogoutOutlined,
  SettingOutlined,
  DownOutlined,
  UnorderedListOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const appStore = useAppStore()

// 退出登录
const handleLogout = () => {
  userStore.logout()
  router.push({ name: 'Home' })
}

// 前往登录
const goLogin = () => {
  router.push({ name: 'Login' })
}
</script>

<template>
  <a-layout class="user-layout">
    <!-- 顶部导航 -->
    <a-layout-header class="header">
      <div class="header-content">
        <!-- Logo -->
        <div class="logo" @click="router.push('/')">
          <VideoCameraOutlined class="logo-icon" />
          <span class="logo-text">电影票预订</span>
        </div>

        <!-- 导航菜单 -->
        <a-menu mode="horizontal" :selectedKeys="[]" class="nav-menu">
          <a-menu-item key="home" @click="router.push('/')">
            <HomeOutlined />
            首页
          </a-menu-item>
          <a-menu-item key="cinemas" @click="router.push('/cinemas')">
            选择影院
          </a-menu-item>
          <a-menu-item key="movies" @click="router.push('/movies')">
            正在热映
          </a-menu-item>
        </a-menu>

        <!-- 右侧操作区 -->
        <div class="header-right">
          <!-- 城市选择 -->
          <a-dropdown>
            <a-button type="text">
              {{ appStore.currentCity }}
              <DownOutlined />
            </a-button>
            <template #overlay>
              <a-menu @click="({ key }) => appStore.setCity(key as string)">
                <a-menu-item key="北京">北京</a-menu-item>
                <a-menu-item key="上海">上海</a-menu-item>
                <a-menu-item key="广州">广州</a-menu-item>
                <a-menu-item key="深圳">深圳</a-menu-item>
              </a-menu>
            </template>
          </a-dropdown>

          <!-- 用户菜单 -->
          <template v-if="userStore.isLoggedIn">
            <a-dropdown>
              <a-avatar
                :src="userStore.user?.avatar"
                class="user-avatar"
              >
                {{ userStore.user?.nickname?.charAt(0) }}
              </a-avatar>
              <template #overlay>
                <a-menu>
                  <a-menu-item key="center" @click="router.push('/user')">
                    <UserOutlined />
                    个人中心
                  </a-menu-item>
                  <a-menu-item key="orders" @click="router.push('/user/orders')">
                    <UnorderedListOutlined />
                    我的订单
                  </a-menu-item>
                  <a-menu-divider />
                  <a-menu-item v-if="userStore.isAdmin" key="admin" @click="router.push('/admin')">
                    <SettingOutlined />
                    管理后台
                  </a-menu-item>
                  <a-menu-item key="logout" @click="handleLogout">
                    <LogoutOutlined />
                    退出登录
                  </a-menu-item>
                </a-menu>
              </template>
            </a-dropdown>
          </template>
          <template v-else>
            <a-button type="primary" @click="goLogin">登录</a-button>
          </template>
        </div>
      </div>
    </a-layout-header>

    <!-- 主体内容 -->
    <a-layout-content class="main-content">
      <router-view v-slot="{ Component }">
        <transition name="page" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </a-layout-content>

    <!-- 页脚 -->
    <a-layout-footer class="footer">
      <div class="footer-content">
        <p>© 2026 星影票务. All rights reserved.</p>
        <div class="footer-links">
          <router-link to="/about">关于我们</router-link>
          <router-link to="/contact">联系方式</router-link>
          <router-link to="/terms">用户协议</router-link>
          <router-link to="/privacy">隐私政策</router-link>
        </div>
      </div>
    </a-layout-footer>
  </a-layout>
</template>

<style scoped>
.user-layout {
  min-height: 100vh;
}

.header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  padding: 0 24px;
  height: 64px;
  line-height: 64px;
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  display: flex;
  align-items: center;
  cursor: pointer;
  gap: 8px;
}

.logo-icon {
  font-size: 28px;
  color: var(--color-primary);
}

.logo-text {
  font-size: 20px;
  font-weight: 600;
  color: #333;
}

.nav-menu {
  flex: 1;
  border-bottom: none;
  margin-left: 48px;
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

.main-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 24px;
  width: 100%;
  min-height: calc(100vh - 64px - 80px);
}

.footer {
  background: #f5f5f5;
  padding: 24px;
  text-align: center;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
}

.footer-links {
  margin-top: 8px;
}

.footer-links a {
  margin: 0 12px;
  color: #666;
}

.footer-links a:hover {
  color: var(--color-primary);
}

/* 响应式 */
@media (max-width: 768px) {
  .nav-menu {
    display: none;
  }
  
  .header-content {
    padding: 0 16px;
  }
}
</style>
