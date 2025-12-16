import { createRouter, createWebHistory } from 'vue-router'
import Layout from '../layout/Layout.vue'
import AdminLayout from '../layout/AdminLayout.vue'

const routes = [
  {
    path: '/',
    component: Layout,
    // redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        meta: { title: '仪表盘' },
        component: () => import('../views/Dashboard.vue')
      },
      {
        path: 'training/worklog',
        name: 'WorkLog',
        meta: { title: '训练日记' },
        component: () => import('../views/WorkLog.vue')
      },
      {
        path: 'nutrition/dietrecord',
        name: 'DietRecord',
        meta: { title: '营养膳食' },
        component: () => import('../views/DietRecord.vue')
      },
      {
        path: 'schedule/mycalendar',
        name: 'MyCalendar',
        meta: { title: '我的日历' },
        component: () => import('../views/MyCalendar.vue')
      },
      {
        path: 'analysis/stats',
        name: 'Stats',
        meta: { title: '分析统计' },
        component: () => import('../views/Stats.vue')
      },
      {
        path: 'profile/settings',
        name: 'Settings',
        meta: { title: '个人设置' },
        component: () => import('../views/Settings.vue')
      }
    ]
  },
  {
    path: '/admin',
    component: AdminLayout,
    redirect: '/admin/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'AdminDashboard',
        meta: { title: '管理后台' },
        component: () => import('../views/admin/AdminDashboard.vue')
      },
      {
        path: 'users',
        name: 'UserManagement',
        meta: { title: '用户管理' },
        component: () => import('../views/admin/UserManagement.vue')
      },
      {
        path: 'settings',
        name: 'SystemSettings',
        meta: { title: '系统设置' },
        component: () => import('../views/admin/SystemSettings.vue')
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue')
  },
  {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: () => import('../views/NotFound.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Public routes that don't require authentication
const publicRoutes = ['/login', '/register']

// Navigation guard for authentication and authorization
router.beforeEach((to, from, next) => {
  // Get user info from localStorage
  let user = null
  try {
    const userStr = localStorage.getItem('user')
    if (userStr) {
      user = JSON.parse(userStr)
    }
  } catch (err) {
    console.error('Failed to parse user data', err)
  }
  if (to.path === '/') {
    if (user) {
      next('/dashboard') // 有用户 -> 去仪表盘
    } else {
      next('/login')     // 无用户 -> 去登录页
    }
    return
  }

  // Check if route is admin route
  const isAdminRoute = to.path.startsWith('/admin')
  
  // Check if route is public
  const isPublicRoute = publicRoutes.includes(to.path)

  // If accessing admin routes
  if (isAdminRoute) {
    // Check if user is logged in
    if (!user) {
      // Not logged in, redirect to login
      next('/login')
      return
    }
    // Check if user is admin
    if (user.role !== 'ADMIN') {
      // Not an admin, redirect to root
      next('/')
      return
    }
    // User is admin, allow access
    next()
    return
  }

  // If accessing protected routes (not public and not login/register)
  if (!isPublicRoute && to.name !== 'NotFound') {
    if (!user) {
      // Not logged in, redirect to login
      next('/login')
      return
    }
  }

  // Allow access
  next()
})

export default router
