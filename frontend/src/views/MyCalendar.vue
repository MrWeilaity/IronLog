<template>
  <div class="calendar-container">
    <el-card>
        <template #header>
            <div class="card-header">
                <span>我的日历</span>
            </div>
        </template>
        <Calendar />
        <div class="calendar-legend">
            <div class="legend-item">
                <span class="dot completed"></span> 完成训练
            </div>
            <div class="legend-item">
                <span class="dot missed"></span> 未完成
            </div>
        </div>
    </el-card>
  </div>
</template>

<script setup>
import Calendar from '../components/Calendar.vue'
</script>

<style scoped>
.calendar-legend {
    margin-top: 20px;
    display: flex;
    gap: 20px;
}
.legend-item {
    display: flex;
    align-items: center;
    font-size: 14px;
}
.dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    margin-right: 8px;
}
.completed {
    background-color: #67C23A;
}
.missed {
    background-color: #F56C6C;
}
</style>
