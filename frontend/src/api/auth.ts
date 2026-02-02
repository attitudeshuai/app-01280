import request from './request'
import type { LoginParams, RegisterParams, User } from '@/types'

/**
 * 认证相关 API
 */
export const authApi = {
  /**
   * 用户登录
   */
  login(params: LoginParams) {
    return request.post<any, { code: number; data: { token: string; user: User }; message: string }>(
      '/auth/login',
      params
    )
  },

  /**
   * 用户注册
   */
  register(params: RegisterParams) {
    return request.post<any, { code: number; data: User; message: string }>(
      '/auth/register',
      params
    )
  },

  /**
   * 获取当前用户信息
   */
  getUserInfo() {
    return request.get<any, { code: number; data: User; message: string }>('/auth/info')
  },

  /**
   * 退出登录
   */
  logout() {
    return request.post('/auth/logout')
  }
}
