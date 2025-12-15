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
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const form = ref({
    username: 'user123',
    nickname: 'IronFan',
    gender: 1,
    height: 175,
    weight: 70,
    birthday: '1995-01-01',
    bio: '热爱运动，坚持打卡！'
})

const saveSettings = () => {
    ElMessage.success('个人信息已更新')
}
</script>
