<template>
  <div class="diet-record-container">
    <el-row :gutter="20">
       <el-col :span="16">
           <el-card>
               <template #header>
                   <div class="card-header">
                       <span>今日饮食</span>
                       <el-button type="primary" @click="dialogVisible = true">添加食物</el-button>
                   </div>
               </template>
               <el-table :data="meals" style="width: 100%" empty-text="今日暂无饮食记录">
                   <el-table-column label="餐别" width="100">
                       <template #default="scope">
                           {{ getMealTypeName(scope.row.mealType) }}
                       </template>
                   </el-table-column>
                   <el-table-column prop="foodId" label="食物ID" width="100" />
                   <el-table-column prop="calcCalories" label="卡路里" width="100" />
                   <el-table-column prop="calcProtein" label="蛋白质(g)" width="100" />
                   <el-table-column prop="calcCarbs" label="碳水(g)" width="100" />
                   <el-table-column prop="calcFat" label="脂肪(g)" width="100" />
               </el-table>
           </el-card>
       </el-col>
       <el-col :span="8">
           <el-card>
               <template #header>
                   <span>营养摄入分析</span>
               </template>
               <CaloriesChart />
               <div class="nutrition-summary">
                   <p>总热量: {{ totalCalories }} kcal</p>
                   <p>蛋白质: {{ totalProtein }} g</p>
                   <p>碳水: {{ totalCarbs }} g</p>
                   <p>脂肪: {{ totalFat }} g</p>
               </div>
           </el-card>
       </el-col>
    </el-row>

    <el-dialog v-model="dialogVisible" title="添加食物">
        <el-form :model="form" label-width="80px">
            <el-form-item label="餐别">
                <el-select v-model="form.mealType">
                    <el-option label="早餐" value="早餐" />
                    <el-option label="午餐" value="午餐" />
                    <el-option label="晚餐" value="晚餐" />
                    <el-option label="加餐" value="加餐" />
                </el-select>
            </el-form-item>
            <el-form-item label="食物名称">
                <el-input v-model="form.foodName" />
            </el-form-item>
            <el-form-item label="热量">
                <el-input-number v-model="form.calories" :min="0" />
            </el-form-item>
             <el-form-item label="蛋白质">
                <el-input-number v-model="form.protein" :min="0" />
            </el-form-item>
             <el-form-item label="碳水">
                <el-input-number v-model="form.carbs" :min="0" />
            </el-form-item>
             <el-form-item label="脂肪">
                <el-input-number v-model="form.fat" :min="0" />
            </el-form-item>
        </el-form>
        <template #footer>
            <span class="dialog-footer">
                <el-button @click="dialogVisible = false">取消</el-button>
                <el-button type="primary" @click="addMeal">添加</el-button>
            </span>
        </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import CaloriesChart from '../components/CaloriesChart.vue'
import axios from 'axios'

const dialogVisible = ref(false)
const meals = ref([])

const form = ref({
    mealType: '早餐',
    foodName: '',
    calories: 0,
    protein: 0,
    carbs: 0,
    fat: 0
})

const totalCalories = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcCalories) || 0), 0))
const totalProtein = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcProtein) || 0), 0))
const totalCarbs = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcCarbs) || 0), 0))
const totalFat = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcFat) || 0), 0))

const fetchMeals = async () => {
    try {
        const res = await axios.get('/api/nutrition/diet-logs', {
            params: { userId: 1, date: new Date().toISOString().split('T')[0] }
        })
        if (res.data.code === 200) {
            meals.value = res.data.data || []
        }
    } catch (err) {
        console.error('获取饮食记录失败', err)
    }
}

const getMealTypeValue = (mealType) => {
    const mapping = { '早餐': 1, '午餐': 2, '晚餐': 3, '加餐': 4 }
    return mapping[mealType] || 1
}

const getMealTypeName = (mealType) => {
    const mapping = { 1: '早餐', 2: '午餐', 3: '晚餐', 4: '加餐' }
    return mapping[mealType] || '早餐'
}

const addMeal = async () => {
    try {
        const res = await axios.post('/api/nutrition/diet-logs', {
            userId: 1,
            foodId: 1, // 默认食物ID，实际应该从食物列表选择
            logDate: new Date().toISOString().split('T')[0],
            mealType: getMealTypeValue(form.value.mealType),
            intakeAmount: 100,
            calcCalories: form.value.calories,
            calcProtein: form.value.protein,
            calcCarbs: form.value.carbs,
            calcFat: form.value.fat
        })
        if (res.data.code === 200) {
            dialogVisible.value = false
            ElMessage.success('添加成功')
            fetchMeals()
            form.value = {
                mealType: '早餐',
                foodName: '',
                calories: 0,
                protein: 0,
                carbs: 0,
                fat: 0
            }
        } else {
            ElMessage.error(res.data.msg || '添加失败')
        }
    } catch (err) {
        ElMessage.error('添加失败')
    }
}

onMounted(() => {
    fetchMeals()
})
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.nutrition-summary {
    margin-top: 20px;
}
.nutrition-summary p {
    margin: 5px 0;
    font-size: 14px;
}
</style>
