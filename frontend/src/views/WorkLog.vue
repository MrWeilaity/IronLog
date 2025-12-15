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
        <el-table-column prop="date" label="日期" width="180" />
        <el-table-column prop="duration" label="时长 (分钟)" width="120" />
        <el-table-column prop="type" label="类型" width="150" />
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
import { ref } from 'vue'
import { ElMessage } from 'element-plus'

const dialogVisible = ref(false)
const trainings = ref([
    { date: '2023-10-27', duration: 45, type: '跑步', notes: '感觉不错' },
    { date: '2023-10-25', duration: 60, type: '举重', notes: '背部训练' }
])

const form = ref({
    date: new Date().toISOString().split('T')[0],
    duration: 30,
    type: '跑步',
    notes: ''
})

const submitTraining = () => {
    trainings.value.unshift({ ...form.value })
    dialogVisible.value = false
    ElMessage.success('训练记录已添加')
    // Reset form
    form.value = {
        date: new Date().toISOString().split('T')[0],
        duration: 30,
        type: '跑步',
        notes: ''
    }
}

const deleteTraining = (index) => {
    trainings.value.splice(index, 1)
    ElMessage.success('记录已删除')
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
