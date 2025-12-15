<template>
  <div class="settings-container">
    <el-card>
        <template #header>
            <span>个人设置</span>
        </template>
        <el-form :model="form" label-width="100px" style="max-width: 500px">
            <el-form-item label="用户名">
                <el-input v-model="form.username" disabled />
            </el-form-item>
            <el-form-item label="昵称">
                <el-input v-model="form.nickname" />
            </el-form-item>
            <el-form-item label="性别">
                <el-radio-group v-model="form.gender">
                    <el-radio :label="1">男</el-radio>
                    <el-radio :label="2">女</el-radio>
                    <el-radio :label="0">保密</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="身高 (cm)">
                <el-input-number v-model="form.height" :min="0" :max="300" />
            </el-form-item>
             <el-form-item label="体重 (kg)">
                <el-input-number v-model="form.weight" :min="0" :max="300" />
            </el-form-item>
            <el-form-item label="生日">
                <el-date-picker v-model="form.birthday" type="date" placeholder="选择日期" />
            </el-form-item>
             <el-form-item label="个人简介">
                <el-input v-model="form.bio" type="textarea" />
            </el-form-item>
            <el-form-item>
                <el-button type="primary" @click="saveSettings">保存修改</el-button>
            </el-form-item>
        </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'
import { getCurrentUserId } from '../utils/auth'

const userId = getCurrentUserId()

const form = ref({
    username: '',
    nickname: '',
    gender: 1,
    height: 175,
    weight: 70,
    birthday: '',
    bio: ''
})

const fetchUserInfo = async () => {
    try {
        const res = await axios.get(`/api/users/${userId}`)
        if (res.data.code === 200 && res.data.data) {
            const user = res.data.data
            form.value = {
                username: user.username || '',
                nickname: user.nickname || '',
                gender: user.gender || 1,
                height: user.height || 175,
                weight: user.weight || 70,
                birthday: user.birthday || '',
                bio: user.bio || ''
            }
        }
    } catch (err) {
        console.error('获取用户信息失败', err)
    }
}

const saveSettings = async () => {
    try {
        const res = await axios.put(`/api/users/${userId}`, form.value)
        if (res.data.code === 200) {
            ElMessage.success('个人信息已更新')
        } else {
            ElMessage.error(res.data.msg || '更新失败')
        }
    } catch (err) {
        ElMessage.error('更新失败')
    }
}

onMounted(() => {
    fetchUserInfo()
})
</script>
