<template>
  <div class="work-log-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>训练日志</span>
          <el-button type="primary" @click="dialogVisible = true">记录训练</el-button>
        </div>
      </template>

      <el-table :data="trainings" style="width: 100%" empty-text="暂无训练记录">
        <el-table-column prop="recordDate" label="日期" width="180" />
        <el-table-column prop="duration" label="时长 (分钟)" width="120" />
        <el-table-column prop="exerciseType" label="类型" width="150" />
        <el-table-column prop="notes" label="备注" />
        <el-table-column label="操作" width="150">
           <template #default="scope">
              <el-button size="small" type="danger" @click="deleteTraining(scope.$index)">删除</el-button>
           </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" title="添加训练记录">
      <el-form :model="form" label-width="80px">
        <el-form-item label="日期">
            <el-date-picker v-model="form.date" type="date" placeholder="选择日期" value-format="YYYY-MM-DD" />
        </el-form-item>
        <el-form-item label="类型">
            <el-select v-model="form.type" placeholder="选择运动类型">
                <el-option label="跑步" value="跑步" />
                <el-option label="举重" value="举重" />
                <el-option label="游泳" value="游泳" />
                <el-option label="瑜伽" value="瑜伽" />
                <el-option label="HIIT" value="HIIT" />
            </el-select>
        </el-form-item>
        <el-form-item label="时长(分)">
            <el-input-number v-model="form.duration" :min="1" />
        </el-form-item>
        <el-form-item label="备注">
            <el-input v-model="form.notes" type="textarea" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitTraining">保存</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'
import { getCurrentUserId } from '../utils/auth'

const dialogVisible = ref(false)
const trainings = ref([])
const userId = getCurrentUserId()

const form = ref({
    date: new Date().toISOString().split('T')[0],
    duration: 30,
    type: '跑步',
    notes: ''
})

const fetchTrainings = async () => {
    try {
        const res = await axios.get('/api/training/records', {
            params: { userId, date: new Date().toISOString().split('T')[0] }
        })
        if (res.data.code === 200) {
            trainings.value = res.data.data || []
        }
    } catch (err) {
        console.error('获取训练记录失败', err)
    }
}

const submitTraining = async () => {
    try {
        const res = await axios.post('/api/training/records', {
            userId,
            recordDate: form.value.date,
            duration: form.value.duration,
            exerciseType: form.value.type,
            notes: form.value.notes
        })
        if (res.data.code === 200) {
            dialogVisible.value = false
            ElMessage.success('训练记录已添加')
            fetchTrainings()
            // Reset form
            form.value = {
                date: new Date().toISOString().split('T')[0],
                duration: 30,
                type: '跑步',
                notes: ''
            }
        } else {
            ElMessage.error(res.data.msg || '添加失败')
        }
    } catch (err) {
        ElMessage.error('添加失败')
    }
}

const deleteTraining = async (index) => {
    const training = trainings.value[index]
    try {
        const res = await axios.delete(`/api/training/records/${training.id}`)
        if (res.data.code === 200) {
            trainings.value.splice(index, 1)
            ElMessage.success('记录已删除')
        } else {
            ElMessage.error(res.data.msg || '删除失败')
        }
    } catch (err) {
        ElMessage.error('删除失败')
    }
}

onMounted(() => {
    fetchTrainings()
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
