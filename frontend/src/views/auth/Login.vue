<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { message } from 'ant-design-vue'
import { UserOutlined, LockOutlined, MobileOutlined } from '@ant-design/icons-vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

const loading = ref(false)
const form = reactive({
  phone: '',
  password: ''
})

// 登录
const handleLogin = async () => {
  if (!form.phone || !form.password) {
    message.warning('请填写完整信息')
    return
  }
  
  loading.value = true
  try {
    await userStore.login({
      phone: form.phone,
      password: form.password
    })
    message.success('登录成功')
    
    // 跳转到之前的页面或首页 (使用 replace 避免登录页留在历史记录中)
    const redirect = route.query.redirect as string || '/'
    router.replace(redirect)
  } catch (error) {
    // 错误已在 request 拦截器中处理
  } finally {
    loading.value = false
  }
}

// 跳转注册
const goRegister = () => {
  router.push('/register')
}
</script>

<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-header">
        <h1>电影票预订系统</h1>
        <p>欢迎回来，请登录您的账号</p>
      </div>

      <a-form
        :model="form"
        layout="vertical"
        class="login-form"
        @finish="handleLogin"
      >
        <a-form-item name="phone" :rules="[{ required: true, message: '请输入手机号' }]">
          <a-input
            v-model:value="form.phone"
            size="large"
            placeholder="手机号"
          >
            <template #prefix>
              <MobileOutlined />
            </template>
          </a-input>
        </a-form-item>

        <a-form-item name="password" :rules="[{ required: true, message: '请输入密码' }]">
          <a-input-password
            v-model:value="form.password"
            size="large"
            placeholder="密码"
          >
            <template #prefix>
              <LockOutlined />
            </template>
          </a-input-password>
        </a-form-item>

        <a-form-item>
          <a-button
            type="primary"
            html-type="submit"
            size="large"
            block
            :loading="loading"
          >
            登录
          </a-button>
        </a-form-item>
      </a-form>

      <div class="login-footer">
        <span>还没有账号？</span>
        <a @click="goRegister">立即注册</a>
      </div>

      <div class="test-account">
        <a-divider>测试账号</a-divider>
        <p>普通用户: 13800138000 / 123456</p>
        <p>管理员: admin / 123456</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-container {
  width: 400px;
  padding: 48px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.login-header {
  text-align: center;
  margin-bottom: 32px;
}

.login-header h1 {
  font-size: 28px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.login-header p {
  color: #666;
}

.login-form {
  margin-top: 24px;
}

.login-footer {
  text-align: center;
  margin-top: 16px;
}

.login-footer a {
  color: var(--color-primary);
  cursor: pointer;
}

.test-account {
  margin-top: 24px;
  text-align: center;
  color: #999;
  font-size: 12px;
}

.test-account p {
  margin: 4px 0;
}
</style>
