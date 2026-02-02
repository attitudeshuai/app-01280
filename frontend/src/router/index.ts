import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import { useUserStore } from '@/stores/user'

// 路由配置
const routes: RouteRecordRaw[] = [
  // ===== 用户端路由 =====
  {
    path: '/',
    component: () => import('@/layouts/UserLayout.vue'),
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('@/views/Home.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'cinemas',
        name: 'Cinemas',
        component: () => import('@/views/cinema/CinemaList.vue'),
        meta: { title: '选择影院' }
      },
      {
        path: 'cinemas/:id',
        name: 'CinemaDetail',
        component: () => import('@/views/cinema/CinemaDetail.vue'),
        meta: { title: '影院详情' }
      },
      {
        path: 'movies',
        name: 'Movies',
        component: () => import('@/views/movie/MovieList.vue'),
        meta: { title: '正在热映' }
      },
      {
        path: 'movies/:id',
        name: 'MovieDetail',
        component: () => import('@/views/movie/MovieDetail.vue'),
        meta: { title: '影片详情' }
      },
      {
        path: 'showtimes/:id/seats',
        name: 'SeatSelection',
        component: () => import('@/views/booking/SeatSelection.vue'),
        meta: { title: '选择座位', requireAuth: true }
      },
      {
        path: 'orders/:id/confirm',
        name: 'OrderConfirm',
        component: () => import('@/views/booking/OrderConfirm.vue'),
        meta: { title: '确认订单', requireAuth: true }
      },
      {
        path: 'orders/:id/success',
        name: 'PaySuccess',
        component: () => import('@/views/booking/PaySuccess.vue'),
        meta: { title: '支付成功', requireAuth: true }
      },
      {
        path: 'user',
        name: 'UserCenter',
        component: () => import('@/views/user/UserCenter.vue'),
        meta: { title: '个人中心', requireAuth: true }
      },
      {
        path: 'user/orders',
        name: 'UserOrders',
        component: () => import('@/views/user/OrderList.vue'),
        meta: { title: '我的订单', requireAuth: true }
      }
    ]
  },
  // ===== 认证页面 =====
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/auth/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/auth/Register.vue'),
    meta: { title: '注册' }
  },
  // ===== 管理后台路由 =====
  {
    path: '/admin',
    component: () => import('@/layouts/AdminLayout.vue'),
    meta: { requireAuth: true, requireAdmin: true },
    children: [
      {
        path: '',
        name: 'AdminDashboard',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: { title: '数据概览' }
      },
      {
        path: 'cinemas',
        name: 'AdminCinemas',
        component: () => import('@/views/admin/CinemaManage.vue'),
        meta: { title: '影院管理' }
      },
      {
        path: 'movies',
        name: 'AdminMovies',
        component: () => import('@/views/admin/MovieManage.vue'),
        meta: { title: '影片管理' }
      },
      {
        path: 'showtimes',
        name: 'AdminShowtimes',
        component: () => import('@/views/admin/ShowtimeManage.vue'),
        meta: { title: '场次管理' }
      },
      {
        path: 'orders',
        name: 'AdminOrders',
        component: () => import('@/views/admin/OrderManage.vue'),
        meta: { title: '订单管理' }
      },
      {
        path: 'users',
        name: 'AdminUsers',
        component: () => import('@/views/admin/UserManage.vue'),
        meta: { title: '用户管理' }
      }
    ]
  },
  // ===== 404 =====
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/NotFound.vue'),
    meta: { title: '页面不存在' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 设置页面标题
  document.title = `${to.meta.title || '电影票预订'} - 电影票预订系统`

  const userStore = useUserStore()

  // 需要登录的页面 (使用 replace 避免登录页留在历史记录)
  if (to.meta.requireAuth && !userStore.isLoggedIn) {
    next({ name: 'Login', query: { redirect: to.fullPath }, replace: true })
    return
  }

  // 需要管理员权限的页面
  if (to.meta.requireAdmin && !userStore.isAdmin) {
    next({ name: 'Home' })
    return
  }

  next()
})

export default router
