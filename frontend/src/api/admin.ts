import request from './request'

/**
 * 管理后台 API
 */

// 统计数据
export const adminStatsApi = {
  getStats() {
    return request.get('/admin/orders/stats')
  }
}

// 影院管理
export const adminCinemaApi = {
  getList(params?: { keyword?: string; page?: number; size?: number }) {
    return request.get('/admin/cinemas', { params })
  },
  getDetail(id: number) {
    return request.get(`/admin/cinemas/${id}`)
  },
  create(data: any) {
    return request.post('/admin/cinemas', data)
  },
  update(id: number, data: any) {
    return request.put(`/admin/cinemas/${id}`, data)
  },
  delete(id: number) {
    return request.delete(`/admin/cinemas/${id}`)
  },
  // 影厅
  getHalls(cinemaId: number) {
    return request.get(`/admin/cinemas/${cinemaId}/halls`)
  },
  createHall(cinemaId: number, data: any) {
    return request.post(`/admin/cinemas/${cinemaId}/halls`, data)
  },
  updateHall(id: number, data: any) {
    return request.put(`/admin/cinemas/halls/${id}`, data)
  },
  deleteHall(id: number) {
    return request.delete(`/admin/cinemas/halls/${id}`)
  }
}

// 影片管理
export const adminMovieApi = {
  getList(params?: { keyword?: string; status?: string; page?: number; size?: number }) {
    return request.get('/admin/movies', { params })
  },
  getDetail(id: number) {
    return request.get(`/admin/movies/${id}`)
  },
  create(data: any) {
    return request.post('/admin/movies', data)
  },
  update(id: number, data: any) {
    return request.put(`/admin/movies/${id}`, data)
  },
  delete(id: number) {
    return request.delete(`/admin/movies/${id}`)
  },
  updateStatus(id: number, status: string) {
    return request.put(`/admin/movies/${id}/status`, null, { params: { status } })
  }
}

// 场次管理
export const adminShowtimeApi = {
  getList(params?: { cinemaId?: number; movieId?: number; page?: number; size?: number }) {
    return request.get('/admin/showtimes', { params })
  },
  create(data: any) {
    return request.post('/admin/showtimes', data)
  },
  update(id: number, data: any) {
    return request.put(`/admin/showtimes/${id}`, data)
  },
  delete(id: number) {
    return request.delete(`/admin/showtimes/${id}`)
  }
}

// 订单管理
export const adminOrderApi = {
  getList(params?: { status?: string; orderNo?: string; page?: number; size?: number }) {
    return request.get('/admin/orders', { params })
  },
  getDetail(id: number) {
    return request.get(`/admin/orders/${id}`)
  }
}

// 用户管理
export const adminUserApi = {
  getList(params?: { keyword?: string; role?: string; page?: number; size?: number }) {
    return request.get('/admin/users', { params })
  },
  getDetail(id: number) {
    return request.get(`/admin/users/${id}`)
  },
  updateStatus(id: number, status: number) {
    return request.put(`/admin/users/${id}/status`, null, { params: { status } })
  },
  updateRole(id: number, role: string) {
    return request.put(`/admin/users/${id}/role`, null, { params: { role } })
  }
}
