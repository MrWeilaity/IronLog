<template>
  <div class="stats-container">
    <el-row :gutter="20">
        <el-col :span="12">
            <el-card>
                <template #header>
                    <span>体重变化趋势</span>
                </template>
                <div class="chart-placeholder">
                    <!-- Placeholder for ECharts -->
                    ECharts 体重折线图
                </div>
            </el-card>
        </el-col>
        <el-col :span="12">
            <el-card>
                <template #header>
                    <span>运动类型分布</span>
                </template>
                <div class="chart-placeholder">
                    <!-- Placeholder for ECharts -->
                    ECharts 饼图
                </div>
            </el-card>
        </el-col>
    </el-row>

    <el-card class="mt-20">
        <template #header>
            <span>社区排行榜</span>
        </template>
        <el-table :data="ranking" style="width: 100%">
            <el-table-column type="index" label="排名" width="80" />
            <el-table-column prop="username" label="用户" />
            <el-table-column prop="score" label="活跃分数" />
            <el-table-column prop="badges" label="获得徽章数" />
        </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const ranking = ref([
    { username: 'FitnessKing', score: 12500, badges: 15 },
    { username: 'Runner001', score: 11200, badges: 12 },
    { username: 'YogaMaster', score: 9800, badges: 10 },
    { username: 'IronMan', score: 8500, badges: 8 },
    { username: 'Newbie', score: 500, badges: 1 }
])
</script>

<style scoped>
.mt-20 {
    margin-top: 20px;
}
.chart-placeholder {
    height: 300px;
    background-color: #f5f7fa;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #909399;
}
</style>
