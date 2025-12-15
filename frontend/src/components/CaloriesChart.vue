<template>
  <div ref="chartRef" class="chart-container"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import * as echarts from 'echarts'

const chartRef = ref(null)
let chartInstance = null

onMounted(() => {
  if (chartRef.value) {
    chartInstance = echarts.init(chartRef.value)
    initChart()
    window.addEventListener('resize', resizeChart)
  }
})

onUnmounted(() => {
  if (chartInstance) {
    chartInstance.dispose()
  }
  window.removeEventListener('resize', resizeChart)
})

const resizeChart = () => {
  chartInstance && chartInstance.resize()
}

const initChart = () => {
  const option = {
    title: {
      text: '热量平衡分析',
      left: 'center'
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'cross',
        crossStyle: {
          color: '#999'
        }
      }
    },
    toolbox: {
      feature: {
        dataView: { show: true, readOnly: false },
        magicType: { show: true, type: ['line', 'bar'] },
        restore: { show: true },
        saveAsImage: { show: true }
      }
    },
    legend: {
      data: ['摄入热量', '消耗热量'],
      bottom: 0
    },
    xAxis: [
      {
        type: 'category',
        data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        axisPointer: {
          type: 'shadow'
        }
      }
    ],
    yAxis: [
      {
        type: 'value',
        name: '摄入 (Kcal)',
        min: 0,
        max: 4000,
        interval: 500,
        axisLabel: {
          formatter: '{value} kcal'
        }
      },
      {
        type: 'value',
        name: '消耗 (Kcal)',
        min: 0,
        max: 4000,
        interval: 500,
        axisLabel: {
          formatter: '{value} kcal'
        }
      }
    ],
    series: [
      {
        name: '摄入热量',
        type: 'bar',
        tooltip: {
          valueFormatter: function (value) {
            return value + ' kcal';
          }
        },
        itemStyle: {
            color: '#F2D4A8' // 燕麦色/浅橙色
        },
        data: [2200, 2400, 2100, 2500, 2300, 2800, 2600]
      },
      {
        name: '消耗热量',
        type: 'line',
        yAxisIndex: 1,
        tooltip: {
          valueFormatter: function (value) {
            return value + ' kcal';
          }
        },
        itemStyle: {
            color: '#0000FF' // 深蓝色/荧光蓝 (Adjusted for visibility)
        },
        lineStyle: {
            color: '#1E90FF',
            width: 3
        },
        data: [2500, 2600, 2400, 2800, 2500, 3000, 2200]
      }
    ]
  };

  chartInstance.setOption(option)
}
</script>

<style scoped>
.chart-container {
  width: 100%;
  height: 400px;
}
</style>
