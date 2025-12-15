<template>
  <el-calendar v-model="value">
    <template #date-cell="{ data }">
      <div class="calendar-cell">
        <div class="date-number">{{ data.day.split('-').slice(1).join('-') }}</div>
        <div class="status-marker" v-if="getStatus(data.day)">
          <el-icon v-if="getStatus(data.day) === 'completed'" color="green"><Check /></el-icon>
          <el-icon v-if="getStatus(data.day) === 'missed'" color="red"><Close /></el-icon>
          <span :class="getStatus(data.day)">{{ getStatusText(data.day) }}</span>
        </div>
      </div>
    </template>
  </el-calendar>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { Check, Close } from '@element-plus/icons-vue'
import axios from 'axios'
import { getCurrentUserId } from '../utils/auth'

const value = ref(new Date())
const trainingData = ref({})
const userId = getCurrentUserId()

const fetchCalendarData = async () => {
  try {
    const yearMonth = value.value.getFullYear() + '-' + String(value.value.getMonth() + 1).padStart(2, '0')
    const res = await axios.get(`/api/calendar/heatmap/${userId}`, {
      params: { yearMonth }
    })
    if (res.data.code === 200 && res.data.data.heatmap) {
      const newData = {}
      res.data.data.heatmap.forEach(day => {
        newData[day.date] = day.status
      })
      trainingData.value = newData
    }
  } catch (err) {
    console.error('获取日历数据失败', err)
  }
}

const getStatus = (date) => {
  return trainingData.value[date]
}

const getStatusText = (date) => {
  const status = getStatus(date)
  if (status === 'completed') return '已完成'
  if (status === 'missed') return '缺勤'
  return ''
}

// Watch for month/year changes
watch(value, () => {
  fetchCalendarData()
})

onMounted(() => {
  fetchCalendarData()
})
</script>

<style scoped>
.calendar-cell {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.date-number {
  font-weight: bold;
}

.status-marker {
  display: flex;
  align-items: center;
  font-size: 12px;
}

.completed {
  color: green;
  margin-left: 4px;
}

.missed {
  color: red;
  margin-left: 4px;
}
</style>
