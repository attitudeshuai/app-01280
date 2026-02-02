/**
 * 类型定义
 */

// 用户
export interface User {
  id: number
  phone: string
  email: string
  nickname: string
  avatar: string
  role: 'USER' | 'ADMIN'
  status: number
  createdAt: string
}

// 登录参数
export interface LoginParams {
  phone?: string
  email?: string
  password: string
}

// 注册参数
export interface RegisterParams {
  phone?: string
  email?: string
  password: string
  nickname?: string
}

// 影院
export interface Cinema {
  id: number
  name: string
  city: string
  district: string
  address: string
  phone: string
  coverImage: string
  description: string
  status: number
  halls?: Hall[]
  hallCount?: number
}

// 影厅
export interface Hall {
  id: number
  cinemaId: number
  name: string
  hallType: string
  seatRows: number
  seatCols: number
  totalSeats: number
  status: number
}

// 影片
export interface Movie {
  id: number
  title: string
  poster: string
  genre: string
  duration: number
  rating: number
  description: string
  director: string
  actors: string
  releaseDate: string
  country: string
  language: string
  status: 'COMING' | 'SHOWING' | 'OFFLINE'
}

// 场次
export interface Showtime {
  id: number
  movieId: number
  hallId: number
  showDate: string
  startTime: string
  endTime: string
  price: number
  availableSeats: number
  status: number
  movie?: Movie
  hall?: Hall
  cinema?: Cinema
}

// 座位
export interface Seat {
  id: number
  showtimeId: number
  rowNum: string
  colNum: number
  seatLabel: string
  seatType: 'NORMAL' | 'VIP' | 'COUPLE' | 'DISABLED'
  status: 'AVAILABLE' | 'LOCKED' | 'SOLD' | 'COMPANION'
}

// 订单
export interface Order {
  id: number
  orderNo: string
  userId: number
  showtimeId: number
  seatInfo: string
  seatCount: number
  unitPrice: number
  totalAmount: number
  status: 'PENDING' | 'PAID' | 'USED' | 'CANCELLED' | 'REFUNDED'
  ticketCode: string
  payType: string
  payTime: string
  expireTime: string
  createdAt: string
  showtime?: Showtime
}

// 分页结果
export interface PageResult<T> {
  records: T[]
  total: number
  size: number
  current: number
  pages: number
}

// API 响应
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
  timestamp: number
}
