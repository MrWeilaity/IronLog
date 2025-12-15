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
          <div class="card-value">1,234</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>今日活跃</span>
            </div>
          </template>
          <div class="card-value">56</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>本月新增训练</span>
            </div>
          </template>
          <div class="card-value">890</div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span>系统状态</span>
            </div>
          </template>
          <div class="card-value status-ok">正常</div>
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
            <el-table-column prop="date" label="注册日期" />
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
import { ref } from 'vue'

const recentUsers = ref([
  { username: 'User1', date: '2023-10-26' },
  { username: 'User2', date: '2023-10-25' },
  { username: 'User3', date: '2023-10-25' },
])
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
