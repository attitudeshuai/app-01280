import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '@/api/auth'
import type { User, LoginParams, RegisterParams } from '@/types'

/**
 * 用户状态管理
 */
export const useUserStore = defineStore('user', () => {
  // 用户信息
  const user = ref<User | null>(null)
  
  // Token
  const token = ref<string>(localStorage.getItem('token') || '')

  // 计算属性
  const isLoggedIn = computed(() => !!token.value && !!user.value)
  const isAdmin = computed(() => user.value?.role === 'ADMIN')

  // 登录
  const login = async (params: LoginParams) => {
    const res = await authApi.login(params)
    token.value = res.data.token
    user.value = res.data.user
    localStorage.setItem('token', res.data.token)
    return res
  }

  // 注册
  const register = async (params: RegisterParams) => {
    const res = await authApi.register(params)
    return res
  }

  // 获取用户信息
  const fetchUserInfo = async () => {
    if (!token.value) return
    try {
      const res = await authApi.getUserInfo()
      user.value = res.data
    } catch (error) {
      logout()
    }
  }

  // 登出
  const logout = () => {
    user.value = null
    token.value = ''
    localStorage.removeItem('token')
  }

  // 初始化: 如果有 token 则获取用户信息
  const init = async () => {
    if (token.value) {
      await fetchUserInfo()
    }
  }

  return {
    user,
    token,
    isLoggedIn,
    isAdmin,
    login,
    register,
    fetchUserInfo,
    logout,
    init
  }
})
