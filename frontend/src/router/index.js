import { createRouter, createWebHistory } from 'vue-router'
import Layout from '../layout/Layout.vue'
import AdminLayout from '../layout/AdminLayout.vue'

const routes = [
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
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
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: () => import('../views/NotFound.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
