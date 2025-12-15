<template>
  <div class="admin-dashboard">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>总用户数</span>
            </div>
          </template>
          <div class="card-value">{{ stats.totalUsers }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>今日活跃</span>
            </div>
          </template>
          <div class="card-value">{{ stats.activeToday }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>本月新增训练</span>
            </div>
          </template>
          <div class="card-value">{{ stats.monthlyTrainings }}</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>系统状态</span>
            </div>
          </template>
          <div class="card-value status-ok">{{ stats.systemStatus }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="mt-20">
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>最新注册用户</span>
          </template>
          <el-table :data="recentUsers" style="width: 100%">
            <el-table-column prop="username" label="用户名" />
            <el-table-column prop="nickname" label="昵称" />
            <el-table-column prop="createdAt" label="注册日期" width="180">
              <template #default="scope">
                {{ scope.row.createdAt ? scope.row.createdAt.substring(0, 10) : 'N/A' }}
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
       <el-col :span="12">
        <el-card>
          <template #header>
            <span>系统公告</span>
          </template>
          <div v-for="item in 3" :key="item" class="text item">
            {{ '公告内容 ' + item }}
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const recentUsers = ref([])
const stats = ref({
  totalUsers: 0,
  activeToday: 0,
  monthlyTrainings: 0,
  systemStatus: '正常'
})

const fetchDashboardStats = async () => {
  try {
    const res = await axios.get('/api/admin/dashboard-stats')
    if (res.data.code === 200) {
      stats.value = res.data.data
    }
  } catch (err) {
    console.error('获取管理后台统计失败', err)
  }
}

const fetchRecentUsers = async () => {
  try {
    const res = await axios.get('/api/admin/recent-users', { params: { limit: 5 } })
    if (res.data.code === 200) {
      recentUsers.value = res.data.data
    }
  } catch (err) {
    console.error('获取最新用户失败', err)
  }
}

onMounted(() => {
  fetchDashboardStats()
  fetchRecentUsers()
})
</script>

<style scoped>
.mt-20 {
  margin-top: 20px;
}
.card-value {
  font-size: 24px;
  font-weight: bold;
  text-align: center;
}
.status-ok {
    color: #67C23A;
}
</style>
