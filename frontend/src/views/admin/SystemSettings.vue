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
          <el-input v-model="settings.site_title" placeholder="请输入网站标题" />
        </el-form-item>
        <el-form-item label="开启注册">
          <el-switch v-model="settings.allow_registration" />
          <span class="form-help">关闭后，新用户将无法注册</span>
        </el-form-item>
        <el-form-item label="维护模式">
          <el-switch v-model="settings.maintenance_mode" />
          <span class="form-help">开启后，普通用户将无法访问系统</span>
        </el-form-item>
        <el-form-item label="维护提示信息" v-if="settings.maintenance_mode">
          <el-input v-model="settings.maintenance_message" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="saveSettings">保存设置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'

const settings = ref({
  site_title: '铁律 运动健康管理系统',
  allow_registration: true,
  maintenance_mode: false,
  maintenance_message: '系统正在维护中，请稍后再试'
})

const fetchSettings = async () => {
  try {
    const res = await axios.get('/api/system/settings')
    if (res.data.code === 200) {
      const data = res.data.data
      settings.value = {
        site_title: data.site_title || '铁律 运动健康管理系统',
        allow_registration: data.allow_registration === 'true',
        maintenance_mode: data.maintenance_mode === 'true',
        maintenance_message: data.maintenance_message || '系统正在维护中，请稍后再试'
      }
    }
  } catch (err) {
    console.error('获取系统设置失败', err)
  }
}

const saveSettings = async () => {
  try {
    const payload = {
      site_title: settings.value.site_title,
      allow_registration: settings.value.allow_registration ? 'true' : 'false',
      maintenance_mode: settings.value.maintenance_mode ? 'true' : 'false',
      maintenance_message: settings.value.maintenance_message
    }
    
    const res = await axios.post('/api/system/settings', payload)
    if (res.data.code === 200) {
      ElMessage.success('设置已保存')
      // Update document title if changed
      if (settings.value.site_title) {
        document.title = settings.value.site_title
      }
    } else {
      ElMessage.error(res.data.msg || '保存失败')
    }
  } catch (err) {
    ElMessage.error('保存失败')
    console.error('保存系统设置失败', err)
  }
}

onMounted(() => {
  fetchSettings()
})
</script>

<style scoped>
.form-help {
  margin-left: 10px;
  font-size: 12px;
  color: #999;
}
</style>
