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
            <span>用户增长趋势（最近7天）</span>
          </template>
          <div id="userGrowthChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>训练活动趋势（最近7天）</span>
          </template>
          <div id="activityChart" style="height: 300px;"></div>
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
          <el-empty v-if="announcements.length === 0" description="暂无公告" />
          <div v-else>
            <div v-for="announcement in announcements" :key="announcement.id" class="announcement-item">
              <div class="announcement-title">
                <el-tag v-if="announcement.priority === 2" type="danger" size="small">紧急</el-tag>
                <el-tag v-else-if="announcement.priority === 1" type="warning" size="small">重要</el-tag>
                <span>{{ announcement.title }}</span>
              </div>
              <div class="announcement-content">{{ announcement.content }}</div>
              <div class="announcement-date">{{ formatDate(announcement.createdAt) }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import * as echarts from 'echarts'

const recentUsers = ref([])
const announcements = ref([])
const stats = ref({
  totalUsers: 0,
  activeToday: 0,
  monthlyTrainings: 0,
  systemStatus: '正常',
  userGrowthChart: [],
  activityChart: []
})

const fetchDashboardStats = async () => {
  try {
    const res = await axios.get('/api/admin/dashboard-stats')
    if (res.data.code === 200) {
      stats.value = res.data.data
      renderCharts()
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

const fetchAnnouncements = async () => {
  try {
    const res = await axios.get('/api/system/announcements')
    if (res.data.code === 200) {
      announcements.value = res.data.data || []
    }
  } catch (err) {
    console.error('获取公告失败', err)
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  return dateStr.substring(0, 10)
}

const renderCharts = () => {
  // Render user growth chart
  const userGrowthEl = document.getElementById('userGrowthChart')
  if (userGrowthEl && stats.value.userGrowthChart) {
    const userGrowthChart = echarts.init(userGrowthEl)
    const dates = stats.value.userGrowthChart.map(d => d.date.substring(5))
    const counts = stats.value.userGrowthChart.map(d => d.count)
    
    userGrowthChart.setOption({
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: dates
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: counts,
        type: 'line',
        smooth: true,
        itemStyle: { color: '#409EFF' }
      }]
    })
  }

  // Render activity chart
  const activityEl = document.getElementById('activityChart')
  if (activityEl && stats.value.activityChart) {
    const activityChart = echarts.init(activityEl)
    const dates = stats.value.activityChart.map(d => d.date.substring(5))
    const counts = stats.value.activityChart.map(d => d.count)
    
    activityChart.setOption({
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: dates
      },
      yAxis: {
        type: 'value'
      },
      series: [{
        data: counts,
        type: 'bar',
        itemStyle: { color: '#67C23A' }
      }]
    })
  }
}

onMounted(() => {
  fetchDashboardStats()
  fetchRecentUsers()
  fetchAnnouncements()
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
.announcement-item {
  margin-bottom: 15px;
  padding-bottom: 15px;
  border-bottom: 1px solid #eee;
}
.announcement-item:last-child {
  border-bottom: none;
}
.announcement-title {
  font-weight: bold;
  margin-bottom: 5px;
}
.announcement-title .el-tag {
  margin-right: 8px;
}
.announcement-content {
  color: #666;
  margin-bottom: 5px;
}
.announcement-date {
  font-size: 12px;
  color: #999;
}
</style>
