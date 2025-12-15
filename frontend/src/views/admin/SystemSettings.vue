<template>
  <div class="system-settings">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>系统设置</span>
        </div>
      </template>
      <el-form :model="settings" label-width="120px">
        <el-form-item label="网站标题">
          <el-input v-model="settings.title" />
        </el-form-item>
        <el-form-item label="开启注册">
          <el-switch v-model="settings.allowRegistration" />
        </el-form-item>
        <el-form-item label="维护模式">
          <el-switch v-model="settings.maintenanceMode" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="saveSettings">保存设置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const settings = ref({
  title: 'IronLog 运动健康管理系统',
  allowRegistration: true,
  maintenanceMode: false
})

const saveSettings = () => {
  ElMessage.success('设置已保存')
}
</script>
