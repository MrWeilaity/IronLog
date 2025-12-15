<template>
  <div class="common-layout">
    <el-container class="layout-container">
      <el-aside width="200px" class="sidebar">
        <div class="logo">IronLog</div>
        <el-menu
          :default-active="activeMenu"
          class="el-menu-vertical-demo"
          router
        >
          <el-menu-item index="/dashboard">
            <el-icon><Odometer /></el-icon>
            <span>仪表盘</span>
          </el-menu-item>
          <el-menu-item index="/training/worklog">
            <el-icon><Notebook /></el-icon>
            <span>训练日记</span>
          </el-menu-item>
          <el-menu-item index="/nutrition/dietrecord">
            <el-icon><Food /></el-icon>
            <span>营养膳食</span>
          </el-menu-item>
          <el-menu-item index="/schedule/mycalendar">
            <el-icon><Calendar /></el-icon>
            <span>我的日历</span>
          </el-menu-item>
          <el-menu-item index="/analysis/stats">
            <el-icon><TrendCharts /></el-icon>
            <span>社区排行</span>
          </el-menu-item>
          <el-menu-item index="/profile/settings">
            <el-icon><Setting /></el-icon>
            <span>个人设置</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-container>
        <el-header class="header">
          <div class="header-content">
            <el-breadcrumb separator="/">
              <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
              <el-breadcrumb-item>{{ currentRouteName }}</el-breadcrumb-item>
            </el-breadcrumb>
            <div class="user-info">
              <el-dropdown>
                <span class="el-dropdown-link">
                  {{ username }} <el-icon class="el-icon--right"><arrow-down /></el-icon>
                </span>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item @click="logout">退出登录</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </div>
        </el-header>
        <el-main>
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Odometer, Notebook, Food, Calendar, TrendCharts, Setting, ArrowDown } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const activeMenu = computed(() => route.path)
const currentRouteName = computed(() => route.name)
const username = ref('用户')

onMounted(() => {
  try {
    const userStr = localStorage.getItem('user')
    if (userStr) {
      const user = JSON.parse(userStr)
      username.value = user.nickname || user.username || '用户'
    }
  } catch (err) {
    console.error('Failed to parse user data', err)
  }
})

const logout = () => {
  localStorage.removeItem('user')
  router.push('/login')
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.sidebar {
  background-color: #304156;
  color: #fff;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  font-size: 20px;
  font-weight: bold;
  color: #fff;
  background-color: #2b3649;
}

.el-menu-vertical-demo {
  border-right: none;
}

.header {
  background-color: #fff;
  border-bottom: 1px solid #dcdfe6;
  display: flex;
  align-items: center;
  padding: 0 20px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  width: 100%;
  align-items: center;
}

.el-main {
  background-color: #f0f2f5;
  padding: 20px;
}
</style>
