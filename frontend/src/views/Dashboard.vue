<template>
  <div class="dashboard-container">
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

const userId = getCurrentUserId()
const waterIntake = ref(0)
const waterGoal = 2500
const dialogVisible = ref(false)
const waterForm = ref({ amount: 250 })
const activities = ref([])

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

// Mock activities for now, or fetch from backend if available
const fetchActivities = () => {
    activities.value = [
        { time: '2023-10-27 10:00', title: '训练完成', content: '晨跑 - 5公里' },
        { time: '2023-10-26 18:30', title: '饮食记录', content: '晚餐: 鸡胸肉 & 米饭' },
        { time: '2023-10-26 09:15', title: '获得徽章', content: '坚持7天！' }
    ]
}

onMounted(() => {
    fetchWater()
    fetchActivities()
})
</script>

<style scoped>
.dashboard-container {
    padding: 20px;
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
</style>
