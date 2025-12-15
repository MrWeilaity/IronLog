<template>
  <div class="stats-container">
    <el-row :gutter="20">
        <el-col :span="12">
            <el-card>
                <template #header>
                    <span>体重变化趋势</span>
                </template>
                <div id="weightChart" style="height: 300px;"></div>
            </el-card>
        </el-col>
        <el-col :span="12">
            <el-card>
                <template #header>
                    <span>运动类型分布</span>
                </template>
                <div id="exerciseChart" style="height: 300px;"></div>
            </el-card>
        </el-col>
    </el-row>

    <el-card class="mt-20">
        <template #header>
            <div class="card-header">
                <span>社区排行榜</span>
                <el-radio-group v-model="leaderboardType" @change="fetchLeaderboard">
                    <el-radio-button label="volume">力量榜</el-radio-button>
                    <el-radio-button label="streak">毅力榜</el-radio-button>
                </el-radio-group>
            </div>
        </template>
        <el-table :data="ranking" style="width: 100%">
            <el-table-column prop="rank" label="排名" width="80">
                <template #default="scope">
                    <el-tag v-if="scope.row.rank === 1" type="warning" effect="dark">🥇</el-tag>
                    <el-tag v-else-if="scope.row.rank === 2" type="info" effect="dark">🥈</el-tag>
                    <el-tag v-else-if="scope.row.rank === 3" type="success" effect="dark">🥉</el-tag>
                    <span v-else>{{ scope.row.rank }}</span>
                </template>
            </el-table-column>
            <el-table-column prop="nickname" label="用户" />
            <el-table-column prop="score" label="分数" width="150">
                <template #default="scope">
                    {{ formatScore(scope.row.score) }} {{ scope.row.unit }}
                </template>
            </el-table-column>
        </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import * as echarts from 'echarts'
import { getCurrentUserId } from '../utils/auth'

const userId = getCurrentUserId()
const ranking = ref([])
const leaderboardType = ref('volume')
let weightChart = null
let exerciseChart = null

const formatScore = (score) => {
    if (typeof score === 'number') {
        return score.toFixed(0)
    }
    return score
}

const fetchLeaderboard = async () => {
    try {
        const res = await axios.get('/api/stats/leaderboard', {
            params: { type: leaderboardType.value, limit: 10 }
        })
        if (res.data.code === 200) {
            ranking.value = res.data.data
        }
    } catch (err) {
        console.error('获取排行榜失败', err)
    }
}

const fetchWeightTrend = async () => {
    try {
        const res = await axios.get(`/api/stats/weight-trend/${userId}`)
        if (res.data.code === 200 && res.data.data.length > 0) {
            renderWeightChart(res.data.data)
        }
    } catch (err) {
        console.error('获取体重趋势失败', err)
    }
}

const fetchExerciseDistribution = async () => {
    try {
        const res = await axios.get(`/api/stats/exercise-distribution/${userId}`)
        if (res.data.code === 200 && res.data.data.length > 0) {
            renderExerciseChart(res.data.data)
        }
    } catch (err) {
        console.error('获取运动分布失败', err)
    }
}

const renderWeightChart = (data) => {
    const chartDom = document.getElementById('weightChart')
    if (!chartDom) return
    
    if (weightChart) {
        weightChart.dispose()
    }
    
    weightChart = echarts.init(chartDom)
    
    const dates = data.map(d => d.date ? d.date.substring(5) : '')
    const weights = data.map(d => d.weight || 0)
    
    const option = {
        tooltip: {
            trigger: 'axis'
        },
        xAxis: {
            type: 'category',
            data: dates
        },
        yAxis: {
            type: 'value',
            name: '体重 (kg)'
        },
        series: [{
            data: weights,
            type: 'line',
            smooth: true,
            itemStyle: {
                color: '#409EFF'
            },
            areaStyle: {
                color: 'rgba(64, 158, 255, 0.2)'
            }
        }]
    }
    
    weightChart.setOption(option)
}

const renderExerciseChart = (data) => {
    const chartDom = document.getElementById('exerciseChart')
    if (!chartDom) return
    
    if (exerciseChart) {
        exerciseChart.dispose()
    }
    
    exerciseChart = echarts.init(chartDom)
    
    const option = {
        tooltip: {
            trigger: 'item'
        },
        series: [{
            type: 'pie',
            radius: '70%',
            data: data,
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }]
    }
    
    exerciseChart.setOption(option)
}

onMounted(() => {
    fetchLeaderboard()
    fetchWeightTrend()
    fetchExerciseDistribution()
})
</script>

<style scoped>
.mt-20 {
    margin-top: 20px;
}
.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}
</style>
