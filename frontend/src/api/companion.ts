import request from './request'

/**
 * 陪伴功能 API
 */

// 玩偶相关
export const dollApi = {
  // 获取可用玩偶列表
  getList() {
    return request.get('/companion/dolls')
  },
  // 获取玩偶详情
  getDetail(id: number) {
    return request.get(`/companion/dolls/${id}`)
  }
}

// 路人匹配
export const matchApi = {
  // 加入匹配池
  join(showtimeId: number, seatId: number) {
    return request.post('/companion/match/join', null, {
      params: { showtimeId, seatId }
    })
  },
  // 查询匹配状态
  getStatus(showtimeId: number) {
    return request.get('/companion/match/status', {
      params: { showtimeId }
    })
  },
  // 取消匹配
  cancel(showtimeId: number) {
    return request.post('/companion/match/cancel', null, {
      params: { showtimeId }
    })
  }
}

// 获取订单的陪伴信息
export const companionApi = {
  getByOrderId(orderId: number) {
    return request.get(`/companion/order/${orderId}`)
  }
}
