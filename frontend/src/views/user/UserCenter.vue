<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import {
  UserOutlined,
  MobileOutlined,
  MailOutlined,
  OrderedListOutlined,
  RightOutlined,
  SettingOutlined
} from '@ant-design/icons-vue'

const router = useRouter()
const userStore = useUserStore()
</script>

<template>
  <div class="user-center-page">
    <!-- 用户信息卡片 -->
    <div class="user-card">
      <a-avatar :size="80" :src="userStore.user?.avatar">
        {{ userStore.user?.nickname?.charAt(0) }}
      </a-avatar>
      <div class="user-info">
        <h2>{{ userStore.user?.nickname }}</h2>
        <a-tag v-if="userStore.isAdmin" color="gold">管理员</a-tag>
        <a-tag v-else color="blue">普通用户</a-tag>
      </div>
    </div>

    <!-- 账号信息 -->
    <div class="info-section">
      <h3>账号信息</h3>
      <div class="info-list">
        <div class="info-item">
          <MobileOutlined />
          <span class="label">手机号</span>
          <span class="value">{{ userStore.user?.phone || '未绑定' }}</span>
        </div>
        <div class="info-item">
          <MailOutlined />
          <span class="label">邮箱</span>
          <span class="value">{{ userStore.user?.email || '未绑定' }}</span>
        </div>
        <div class="info-item">
          <UserOutlined />
          <span class="label">注册时间</span>
          <span class="value">{{ userStore.user?.createdAt?.slice(0, 10) }}</span>
        </div>
      </div>
    </div>

    <!-- 功能入口 -->
    <div class="menu-section">
      <div class="menu-item" @click="router.push('/user/orders')">
        <div class="menu-left">
          <OrderedListOutlined />
          <span>我的订单</span>
        </div>
        <RightOutlined class="arrow" />
      </div>
      
      <div class="menu-item" v-if="userStore.isAdmin" @click="router.push('/admin')">
        <div class="menu-left">
          <SettingOutlined />
          <span>管理后台</span>
        </div>
        <RightOutlined class="arrow" />
      </div>
    </div>

    <!-- 退出登录 -->
    <a-button 
      type="primary" 
      danger 
      block 
      size="large"
      class="logout-btn"
      @click="userStore.logout(); router.push('/')"
    >
      退出登录
    </a-button>
  </div>
</template>

<style scoped>
.user-center-page {
  max-width: 600px;
  margin: 0 auto;
}

/* 用户卡片 */
.user-card {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 32px;
  background: linear-gradient(135deg, var(--color-primary) 0%, #6610f2 100%);
  border-radius: 16px;
  color: white;
  margin-bottom: 24px;
}

.user-info h2 {
  color: white;
  font-size: 24px;
  margin-bottom: 8px;
}

/* 信息区块 */
.info-section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  margin-bottom: 24px;
}

.info-section h3 {
  font-size: 16px;
  color: var(--text-secondary);
  margin-bottom: 16px;
}

.info-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 12px;
}

.info-item .anticon {
  font-size: 18px;
  color: var(--color-primary);
}

.info-item .label {
  color: var(--text-secondary);
  width: 80px;
}

.info-item .value {
  flex: 1;
  font-weight: 500;
}

/* 菜单 */
.menu-section {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 24px;
}

.menu-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  cursor: pointer;
  transition: background 0.2s;
}

.menu-item:hover {
  background: #f8f9fa;
}

.menu-item:not(:last-child) {
  border-bottom: 1px solid #f0f0f0;
}

.menu-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.menu-left .anticon {
  font-size: 20px;
  color: var(--color-primary);
}

.menu-left span {
  font-size: 16px;
}

.arrow {
  color: #ccc;
}

/* 退出按钮 */
.logout-btn {
  height: 48px;
  font-size: 16px;
}
</style>
