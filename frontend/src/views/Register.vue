<template>
  <div class="register-wrapper">
    <div class="register-box">
      <h2>铁律 注册</h2>
      <el-form :model="registerForm" :rules="rules" ref="registerFormRef" label-width="0px">
        <el-form-item prop="username">
          <el-input v-model="registerForm.username" placeholder="用户名" prefix-icon="User" />
        </el-form-item>
        <el-form-item prop="nickname">
          <el-input v-model="registerForm.nickname" placeholder="昵称" prefix-icon="Avatar" />
        </el-form-item>
        <el-form-item prop="email">
          <el-input v-model="registerForm.email" placeholder="邮箱" prefix-icon="Message" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="registerForm.password" type="password" placeholder="密码" prefix-icon="Lock" show-password />
        </el-form-item>
        <el-form-item prop="confirmPassword">
          <el-input v-model="registerForm.confirmPassword" type="password" placeholder="确认密码" prefix-icon="Lock" show-password />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" class="register-btn" @click="handleRegister">注册</el-button>
        </el-form-item>
        <el-form-item>
          <el-link type="primary" @click="goToLogin">已有账号？去登录</el-link>
        </el-form-item>
      </el-form>
      <div v-if="errorMessage" class="error-msg">{{ errorMessage }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { User, Lock, Avatar, Message } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'

const router = useRouter()
const registerFormRef = ref(null)
const loading = ref(false)
const errorMessage = ref('')
const registrationEnabled = ref(true)

const registerForm = reactive({
  username: '',
  nickname: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const validatePassword = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请输入密码'))
  } else if (value.length < 6) {
    callback(new Error('密码长度不能少于6位'))
  } else {
    callback()
  }
}

const validateConfirmPassword = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入密码'))
  } else if (value !== registerForm.password) {
    callback(new Error('两次输入密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  nickname: [
    { required: true, message: '请输入昵称', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  password: [
    { required: true, validator: validatePassword, trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const checkRegistrationStatus = async () => {
  try {
    const res = await axios.get('/api/system/settings/allow_registration')
    if (res.data.code === 200) {
      registrationEnabled.value = res.data.data === 'true'
      if (!registrationEnabled.value) {
        ElMessage.warning('系统暂时关闭注册功能')
        router.push('/login')
      }
    }
  } catch (err) {
    console.error('检查注册状态失败', err)
  }
}

const handleRegister = async () => {
  if (!registerFormRef.value) return

  await registerFormRef.value.validate(async (valid) => {
    if (valid) {
      if (!registrationEnabled.value) {
        ElMessage.error('系统暂时关闭注册功能')
        return
      }

      loading.value = true
      errorMessage.value = ''

      try {
        const response = await axios.post('/api/users/register', {
          username: registerForm.username,
          nickname: registerForm.nickname,
          email: registerForm.email,
          password: registerForm.password,
          role: 'USER',
          status: 1
        })

        if (response.data.code === 200) {
          ElMessage.success('注册成功，请登录')
          router.push('/login')
        } else {
          errorMessage.value = response.data.msg || '注册失败'
        }
      } catch (error) {
        errorMessage.value = '网络错误: ' + error.message
      } finally {
        loading.value = false
      }
    }
  })
}

const goToLogin = () => {
  router.push('/login')
}

onMounted(() => {
  checkRegistrationStatus()
})
</script>

<style scoped>
.register-wrapper {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #2d3a4b;
}

.register-box {
  width: 400px;
  padding: 30px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  text-align: center;
}

h2 {
  margin-bottom: 20px;
  color: #333;
}

.register-btn {
  width: 100%;
}

.error-msg {
  color: red;
  margin-top: 10px;
  font-size: 14px;
}
</style>
