import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from 'axios'
import { message } from 'ant-design-vue'
import router from '@/router'

// 创建 Axios 实例
const request = axios.create({
  baseURL: '/api',
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
request.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    // 从 localStorage 获取 token
    const token = localStorage.getItem('token')
    if (token && config.headers) {
      config.headers['satoken'] = token
    }
    return config
  },
  (error: AxiosError) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  (response: AxiosResponse) => {
    const res = response.data
    
    // 如果 code 不是 200, 说明请求有错误
    if (res.code !== 200) {
      message.error(res.message || '请求失败')
      
      // 401: 未登录或 Token 过期
      if (res.code === 401) {
        localStorage.removeItem('token')
        router.push({ name: 'Login' })
      }
      
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    
    return res
  },
  (error: AxiosError<{ message?: string }>) => {
    // 网络错误或服务器错误
    const errorMessage = error.response?.data?.message || error.message || '网络错误'
    message.error(errorMessage)
    
    // 401 重定向到登录页
    if (error.response?.status === 401) {
      localStorage.removeItem('token')
      router.push({ name: 'Login' })
    }
    
    return Promise.reject(error)
  }
)

export default request
