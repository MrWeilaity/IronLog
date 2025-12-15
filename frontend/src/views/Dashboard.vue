<template>
  <div class="dashboard-container">
    <!-- Stats Overview -->
    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-value">{{ dashboardStats.todayTrainingCount || 0 }}</div>
            <div class="stat-label">今日训练</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-value">{{ dashboardStats.weeklyTrainingDays || 0 }}</div>
            <div class="stat-label">本周训练天数</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-value">{{ bodyMetrics.bmi || 'N/A' }}</div>
            <div class="stat-label">BMI指数</div>
            <div class="stat-tag" v-if="bodyMetrics.bmiCategory">{{ bodyMetrics.bmiCategory }}</div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-value">{{ dashboardStats.monthlyTrainingDays || 0 }}</div>
            <div class="stat-label">本月训练天数</div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="8">
        <el-card class="box-card">
          <template #header>
            <div class="card-header">
              <span>今日饮水量</span>
              <el-button class="button" text @click="addWater">添加</el-button>
            </div>
          </template>
          <div class="text item">
            <el-progress type="dashboard" :percentage="waterPercentage" :color="colors">
              <template #default="{ percentage }">
                <span class="percentage-value">{{ waterIntake }} ml</span>
                <span class="percentage-label">目标: {{ waterGoal }}ml</span>
              </template>
            </el-progress>
          </div>
        </el-card>
      </el-col>

      <el-col :span="16">
        <el-card class="box-card">
          <template #header>
            <div class="card-header">
              <span>本周运动统计</span>
            </div>
          </template>
          <div id="weeklyChart" style="height: 300px;"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="mt-20">
      <el-col :span="24">
        <el-card class="box-card">
          <template #header>
            <div class="card-header">
              <span>近期活动</span>
            </div>
          </template>
          <div v-if="activities.length === 0">暂无近期活动</div>
          <el-timeline v-else>
            <el-timeline-item
              v-for="(activity, index) in activities"
              :key="index"
              :timestamp="activity.time"
              placement="top"
            >
              <el-card>
                <h4>{{ activity.title }}</h4>
                <p>{{ activity.content }}</p>
              </el-card>
            </el-timeline-item>
          </el-timeline>
        </el-card>
      </el-col>
    </el-row>

    <!-- Add Water Dialog -->
    <el-dialog v-model="dialogVisible" title="记录饮水量" width="30%">
      <el-form>
        <el-form-item label="数量 (ml)">
           <el-input-number v-model="waterForm.amount" :step="100" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitWater">确认</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { getCurrentUserId } from '../utils/auth'
import * as echarts from 'echarts'

const userId = getCurrentUserId()
const waterIntake = ref(0)
const waterGoal = 2500
const dialogVisible = ref(false)
const waterForm = ref({ amount: 250 })
const activities = ref([])
const dashboardStats = ref({})
const bodyMetrics = ref({})
const weeklyActivity = ref({})
let weeklyChart = null

const waterPercentage = computed(() => {
  return Math.min((waterIntake.value / waterGoal) * 100, 100)
})

const colors = [
  { color: '#f56c6c', percentage: 20 },
  { color: '#e6a23c', percentage: 40 },
  { color: '#5cb87a', percentage: 60 },
  { color: '#1989fa', percentage: 80 },
  { color: '#6f7ad3', percentage: 100 },
]

const fetchWater = async () => {
  try {
    const res = await axios.get(`/api/water/today?userId=${userId}`)
    if (res.data.code === 200) {
        waterIntake.value = res.data.data
    }
  } catch (err) {
    console.error(err)
  }
}

const addWater = () => {
    dialogVisible.value = true
}

const submitWater = async () => {
    try {
        const res = await axios.post('/api/water/add', {
            userId,
            amount: waterForm.value.amount
        })
        if (res.data.code === 200) {
            ElMessage.success('记录成功')
            dialogVisible.value = false
            fetchWater()
        } else {
            ElMessage.error(res.data.msg || '记录失败')
        }
    } catch (err) {
        ElMessage.error('记录失败')
    }
}

const fetchDashboardStats = async () => {
    try {
        const res = await axios.get(`/api/dashboard/stats/${userId}`)
        if (res.data.code === 200) {
            dashboardStats.value = res.data.data
        }
    } catch (err) {
        console.error('获取仪表盘统计失败', err)
    }
}

const fetchBodyMetrics = async () => {
    try {
        const res = await axios.get(`/api/dashboard/body-metrics/${userId}`)
        if (res.data.code === 200) {
            bodyMetrics.value = res.data.data
        }
    } catch (err) {
        console.error('获取身体指标失败', err)
    }
}

const fetchWeeklyActivity = async () => {
    try {
        const res = await axios.get(`/api/dashboard/weekly-activity/${userId}`)
        if (res.data.code === 200) {
            weeklyActivity.value = res.data.data
            renderWeeklyChart()
        }
    } catch (err) {
        console.error('获取周活动统计失败', err)
    }
}

const fetchActivities = async () => {
    try {
        const res = await axios.get(`/api/dashboard/recent-activities/${userId}`)
        if (res.data.code === 200) {
            activities.value = res.data.data
        }
    } catch (err) {
        console.error('获取近期活动失败', err)
        // Fallback to mock data
        activities.value = []
    }
}

const renderWeeklyChart = () => {
    const chartDom = document.getElementById('weeklyChart')
    if (!chartDom) return
    
    if (weeklyChart) {
        weeklyChart.dispose()
    }
    
    weeklyChart = echarts.init(chartDom)
    
    const daily = weeklyActivity.value.daily || []
    const dates = daily.map(d => {
        const date = new Date(d.date)
        return `${date.getMonth() + 1}/${date.getDate()}`
    })
    const minutes = daily.map(d => d.minutes)
    
    const option = {
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        xAxis: {
            type: 'category',
            data: dates
        },
        yAxis: {
            type: 'value',
            name: '分钟'
        },
        series: [{
            data: minutes,
            type: 'bar',
            itemStyle: {
                color: '#409EFF'
            }
        }]
    }
    
    weeklyChart.setOption(option)
}

onMounted(() => {
    fetchWater()
    fetchDashboardStats()
    fetchBodyMetrics()
    fetchWeeklyActivity()
    fetchActivities()
})
</script>

<style scoped>
.dashboard-container {
    padding: 20px;
}

.stats-row {
    margin-bottom: 20px;
}

.stat-card {
    text-align: center;
    padding: 20px 0;
}

.stat-value {
    font-size: 32px;
    font-weight: bold;
    color: #409EFF;
    margin-bottom: 10px;
}

.stat-label {
    font-size: 14px;
    color: #909399;
}

.stat-tag {
    margin-top: 8px;
    display: inline-block;
    padding: 2px 10px;
    background-color: #f0f9ff;
    color: #409EFF;
    border-radius: 12px;
    font-size: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.text {
  font-size: 14px;
}

.item {
  margin-bottom: 18px;
  text-align: center;
}

.box-card {
  width: 100%;
}

.percentage-value {
  display: block;
  margin-top: 10px;
  font-size: 28px;
}

.percentage-label {
  display: block;
  margin-top: 10px;
  font-size: 12px;
}

.mt-20 {
    margin-top: 20px;
}
</style>
