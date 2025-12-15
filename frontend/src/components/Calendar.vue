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
import { ref } from 'vue'
import { Check, Close } from '@element-plus/icons-vue'

const value = ref(new Date())

// 模拟数据：日期 -> 状态
const trainingData = {
  '2023-10-25': 'completed',
  '2023-10-26': 'missed',
  '2023-10-27': 'completed'
}

const getStatus = (date) => {
  // date string format usually: YYYY-MM-DD
  // data.day from el-calendar is YYYY-MM-DD
  return trainingData[date]
}

const getStatusText = (date) => {
  const status = getStatus(date)
  if (status === 'completed') return '已完成'
  if (status === 'missed') return '缺勤'
  return ''
}
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
