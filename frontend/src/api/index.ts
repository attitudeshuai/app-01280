import request from './request'

/**
 * 影院 API
 */
export const cinemaApi = {
  // 获取影院列表
  getList(params?: { city?: string; keyword?: string }) {
    return request.get('/cinemas', { params })
  },
  // 获取影院详情
  getDetail(id: number | string) {
    return request.get(`/cinemas/${id}`)
  }
}

/**
 * 影片 API
 */
export const movieApi = {
  // 获取影片列表 (通用)
  getList(params?: { status?: string; keyword?: string; page?: number; size?: number }) {
    return request.get('/movies', { params })
  },
  // 获取热映影片
  getShowing(params?: { page?: number; size?: number }) {
    return request.get('/movies', { params: { ...params, status: 'SHOWING' } })
  },
  // 获取即将上映
  getComing(params?: { page?: number; size?: number }) {
    return request.get('/movies', { params: { ...params, status: 'COMING' } })
  },
  // 获取影片详情
  getDetail(id: number | string) {
    return request.get(`/movies/${id}`)
  }
}

/**
 * 场次 API
 */
export const showtimeApi = {
  // 获取场次列表 (按影院+日期)
  getList(params: { cinemaId?: number; movieId?: number; date?: string }) {
    return request.get('/showtimes', { params })
  },
  // 获取场次详情
  getDetail(id: number | string) {
    return request.get(`/showtimes/${id}`)
  }
}

/**
 * 座位 API
 */
export const seatApi = {
  // 获取座位图
  getSeatMap(showtimeId: number | string) {
    return request.get(`/showtimes/${showtimeId}/seats`)
  },
  // 锁定座位
  lockSeats(showtimeId: number | string, seatIds: number[]) {
    return request.post(`/showtimes/${showtimeId}/seats/lock`, { seatIds })
  },
  // 释放座位
  releaseSeats(showtimeId: number | string, seatIds: number[]) {
    return request.post(`/showtimes/${showtimeId}/seats/release`, { seatIds })
  }
}

/**
 * 订单 API
 */
export const orderApi = {
  // 创建订单
  create(data: { 
    showtimeId: number
    seatIds: number[]
    companionType?: string
    dollTypeId?: number 
  }) {
    return request.post('/orders', data)
  },
  // 获取订单详情
  getDetail(id: number | string) {
    return request.get(`/orders/${id}`)
  },
  // 获取我的订单列表
  getMyOrders(params?: { page?: number; size?: number; status?: string }) {
    return request.get('/orders/my', { params })
  },
  // 支付订单 (模拟)
  pay(id: number | string, payType: string) {
    return request.post(`/orders/${id}/pay`, { payType })
  },
  // 取消订单
  cancel(id: number | string) {
    return request.post(`/orders/${id}/cancel`)
  }
}

export { authApi } from './auth'
export { dollApi, matchApi, companionApi } from './companion'
