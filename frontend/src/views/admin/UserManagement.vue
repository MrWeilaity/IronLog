<template>
  <div class="user-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户列表</span>
          <el-button type="primary" @click="dialogVisible = true">添加用户</el-button>
        </div>
      </template>
      <el-table :data="users" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="role" label="角色" />
        <el-table-column label="操作" width="240">
          <template #default="scope">
            <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button size="small" type="warning" @click="handleResetPasswordDialog(scope.row)">重置密码</el-button>
            <el-button size="small" type="danger" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑用户' : '添加用户'">
      <el-form :model="form" label-width="80px">
        <el-form-item label="用户名">
          <el-input v-model="form.username" />
        </el-form-item>
        <el-form-item label="昵称">
          <el-input v-model="form.nickname" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" />
        </el-form-item>
        <el-form-item label="密码" v-if="!form.id">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" />
        </el-form-item>
         <el-form-item label="角色">
           <el-select v-model="form.role">
             <el-option label="用户" value="USER" />
             <el-option label="管理员" value="ADMIN" />
           </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSave">保存</el-button>
        </span>
      </template>
    </el-dialog>

    <el-dialog v-model="passwordDialogVisible" title="重置密码">
      <el-form :model="passwordForm" label-width="80px">
        <el-form-item label="新密码">
          <el-input v-model="passwordForm.password" type="password" placeholder="请输入新密码" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="passwordDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleResetPassword">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

const users = ref([])

const dialogVisible = ref(false)
const passwordDialogVisible = ref(false)
const form = ref({
  id: null,
  username: '',
  nickname: '',
  email: '',
  password: '',
  role: 'USER'
})

const passwordForm = ref({
  userId: null,
  password: ''
})

const fetchUsers = async () => {
  try {
    const res = await axios.get('/api/users')
    if (res.data.code === 200) {
      users.value = res.data.data || []
    }
  } catch (err) {
    console.error('获取用户列表失败', err)
  }
}

const handleEdit = (row) => {
  form.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = (row) => {
  ElMessageBox.confirm('确认删除该用户吗?', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      try {
        const res = await axios.delete(`/api/users/${row.id}`)
        if (res.data.code === 200) {
          ElMessage({
            type: 'success',
            message: '删除成功',
          })
          fetchUsers()
        } else {
          ElMessage.error(res.data.msg || '删除失败')
        }
      } catch (err) {
        ElMessage.error('删除失败')
      }
    })
    .catch(() => {})
}

const handleSave = async () => {
  try {
    if (!form.value.id && !form.value.password) {
      ElMessage.error('请输入密码')
      return
    }
    
    let res
    if (form.value.id) {
      res = await axios.put(`/api/users/${form.value.id}`, form.value)
    } else {
      res = await axios.post('/api/users/register', form.value)
    }
    if (res.data.code === 200) {
      dialogVisible.value = false
      ElMessage.success('保存成功')
      fetchUsers()
      // Reset form
      form.value = {
        id: null,
        username: '',
        nickname: '',
        email: '',
        password: '',
        role: 'USER'
      }
    } else {
      ElMessage.error(res.data.msg || '保存失败')
    }
  } catch (err) {
    ElMessage.error('保存失败')
  }
}

const handleResetPasswordDialog = (row) => {
  passwordForm.value = {
    userId: row.id,
    password: ''
  }
  passwordDialogVisible.value = true
}

const handleResetPassword = async () => {
  try {
    if (!passwordForm.value.password) {
      ElMessage.error('请输入新密码')
      return
    }
    
    const res = await axios.put(`/api/admin/users/${passwordForm.value.userId}/reset-password`, {
      password: passwordForm.value.password
    })
    
    if (res.data.code === 200) {
      passwordDialogVisible.value = false
      ElMessage.success('密码重置成功')
      passwordForm.value = { userId: null, password: '' }
    } else {
      ElMessage.error(res.data.msg || '重置失败')
    }
  } catch (err) {
    ElMessage.error('重置失败')
  }
}

onMounted(() => {
  fetchUsers()
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
