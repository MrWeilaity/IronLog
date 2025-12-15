<template>
  <div class="common-layout">
    <el-container class="layout-container">
      <el-aside width="200px" class="sidebar">
        <div class="logo">铁律 后台</div>
        <el-menu
          :default-active="activeMenu"
          class="el-menu-vertical-demo"
          router
        >
          <el-menu-item index="/admin/dashboard">
            <el-icon><Odometer /></el-icon>
            <span>管理后台</span>
          </el-menu-item>
          <el-menu-item index="/admin/users">
            <el-icon><User /></el-icon>
            <span>用户管理</span>
          </el-menu-item>
          <el-menu-item index="/admin/settings">
            <el-icon><Setting /></el-icon>
            <span>系统设置</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-container>
        <el-header class="header">
          <div class="header-content">
            <el-breadcrumb separator="/">
              <el-breadcrumb-item :to="{ path: '/admin/dashboard' }">首页</el-breadcrumb-item>
              <el-breadcrumb-item>{{ currentRouteName }}</el-breadcrumb-item>
            </el-breadcrumb>
            <div class="user-info">
              <el-button type="success" size="small" @click="goToFrontend" style="margin-right: 15px;">
                <el-icon><User /></el-icon>
                <span>返回前台</span>
              </el-button>
              <el-dropdown>
                <span class="el-dropdown-link">
                  管理员 <el-icon class="el-icon--right"><arrow-down /></el-icon>
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
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Odometer, User, Setting, ArrowDown } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const activeMenu = computed(() => route.path)
const currentRouteName = computed(() => route.meta.title || route.name)

const goToFrontend = () => {
  router.push('/dashboard')
}

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
