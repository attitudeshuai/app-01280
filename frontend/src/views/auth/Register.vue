<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { message } from 'ant-design-vue'
import { UserOutlined, LockOutlined, MobileOutlined } from '@ant-design/icons-vue'

const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const form = reactive({
  phone: '',
  nickname: '',
  password: '',
  confirmPassword: ''
})

// 注册
const handleRegister = async () => {
  if (form.password !== form.confirmPassword) {
    message.warning('两次密码不一致')
    return
  }
  
  loading.value = true
  try {
    await userStore.register({
      phone: form.phone,
      nickname: form.nickname,
      password: form.password
    })
    message.success('注册成功，请登录')
    router.push('/login')
  } catch (error) {
    // 错误已在 request 拦截器中处理
  } finally {
    loading.value = false
  }
}

// 跳转登录
const goLogin = () => {
  router.push('/login')
}
</script>

<template>
  <div class="register-page">
    <div class="register-container">
      <div class="register-header">
        <h1>创建账号</h1>
        <p>注册成为会员，享受便捷购票体验</p>
      </div>

      <a-form
        :model="form"
        layout="vertical"
        class="register-form"
        @finish="handleRegister"
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

        <a-form-item name="nickname" :rules="[{ required: true, message: '请输入昵称' }]">
          <a-input
            v-model:value="form.nickname"
            size="large"
            placeholder="昵称"
          >
            <template #prefix>
              <UserOutlined />
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

        <a-form-item name="confirmPassword" :rules="[{ required: true, message: '请确认密码' }]">
          <a-input-password
            v-model:value="form.confirmPassword"
            size="large"
            placeholder="确认密码"
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
            注册
          </a-button>
        </a-form-item>
      </a-form>

      <div class="register-footer">
        <span>已有账号？</span>
        <a @click="goLogin">立即登录</a>
      </div>
    </div>
  </div>
</template>

<style scoped>
.register-page {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.register-container {
  width: 400px;
  padding: 48px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

.register-header {
  text-align: center;
  margin-bottom: 32px;
}

.register-header h1 {
  font-size: 28px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.register-header p {
  color: #666;
}

.register-form {
  margin-top: 24px;
}

.register-footer {
  text-align: center;
  margin-top: 16px;
}

.register-footer a {
  color: var(--color-primary);
  cursor: pointer;
}
</style>
