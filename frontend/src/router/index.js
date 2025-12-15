import { createRouter, createWebHistory } from 'vue-router'
import Layout from '../layout/Layout.vue'

const routes = [
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue')
      },
      {
        path: 'training/worklog',
        name: 'WorkLog',
        component: () => import('../views/WorkLog.vue')
      },
      {
        path: 'nutrition/dietrecord',
        name: 'DietRecord',
        component: () => import('../views/DietRecord.vue')
      },
      {
        path: 'schedule/mycalendar',
        name: 'MyCalendar',
        component: () => import('../views/MyCalendar.vue')
      },
      {
        path: 'analysis/stats',
        name: 'Stats',
        component: () => import('../views/Stats.vue')
      },
      {
        path: 'profile/settings',
        name: 'Settings',
        component: () => import('../views/Settings.vue')
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
