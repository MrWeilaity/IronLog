<template>
  <div class="diet-record-container">
    <el-row :gutter="20">
       <el-col :span="16">
           <el-card>
               <template #header>
                   <div class="card-header">
                       <span>今日饮食</span>
                       <el-button type="primary" @click="openDialog">添加食物</el-button>
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

    <el-dialog v-model="dialogVisible" title="添加食物" width="50%">
        <el-form :model="form" label-width="100px">
            <el-form-item label="餐别">
                <el-select v-model="form.mealType">
                    <el-option label="早餐" value="早餐" />
                    <el-option label="午餐" value="午餐" />
                    <el-option label="晚餐" value="晚餐" />
                    <el-option label="加餐" value="加餐" />
                </el-select>
            </el-form-item>
            <el-form-item label="选择食物">
                <el-select 
                    v-model="form.selectedFood" 
                    filterable 
                    remote
                    reserve-keyword
                    placeholder="搜索食物"
                    :remote-method="searchFoods"
                    :loading="foodSearchLoading"
                    @change="onFoodSelected"
                    style="width: 100%"
                >
                    <el-option 
                        v-for="food in foodList" 
                        :key="food.id" 
                        :label="`${food.name} ${food.brand ? '(' + food.brand + ')' : ''}`" 
                        :value="food.id"
                    >
                        <span>{{ food.name }}</span>
                        <span style="float: right; color: #8492a6; font-size: 13px">
                            {{ food.calories }} kcal / {{ food.stdUnit }}{{ food.unitType }}
                        </span>
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="食用量">
                <el-input-number v-model="form.intakeAmount" :min="0" :step="0.1" />
                <span style="margin-left: 10px" v-if="selectedFoodInfo">{{ selectedFoodInfo.unitType }}</span>
            </el-form-item>
            <el-form-item label="热量" v-if="selectedFoodInfo">
                <span>{{ calculatedNutrition.calories }} kcal</span>
            </el-form-item>
            <el-form-item label="蛋白质" v-if="selectedFoodInfo">
                <span>{{ calculatedNutrition.protein }} g</span>
            </el-form-item>
            <el-form-item label="碳水" v-if="selectedFoodInfo">
                <span>{{ calculatedNutrition.carbs }} g</span>
            </el-form-item>
            <el-form-item label="脂肪" v-if="selectedFoodInfo">
                <span>{{ calculatedNutrition.fat }} g</span>
            </el-form-item>
        </el-form>
        <template #footer>
            <span class="dialog-footer">
                <el-button @click="dialogVisible = false">取消</el-button>
                <el-button type="primary" @click="addMeal" :disabled="!form.selectedFood">添加</el-button>
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
import { getCurrentUserId } from '../utils/auth'

const dialogVisible = ref(false)
const meals = ref([])
const userId = getCurrentUserId()
const foodList = ref([])
const foodSearchLoading = ref(false)
const selectedFoodInfo = ref(null)

const form = ref({
    mealType: '早餐',
    selectedFood: null,
    intakeAmount: 1
})

const totalCalories = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcCalories) || 0), 0))
const totalProtein = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcProtein) || 0), 0))
const totalCarbs = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcCarbs) || 0), 0))
const totalFat = computed(() => meals.value.reduce((sum, item) => sum + (parseFloat(item.calcFat) || 0), 0))

const fetchMeals = async () => {
    try {
        const res = await axios.get('/api/nutrition/diet-logs', {
            params: { userId, date: new Date().toISOString().split('T')[0] }
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

const calculatedNutrition = computed(() => {
    if (!selectedFoodInfo.value || !form.value.intakeAmount) {
        return { calories: 0, protein: 0, carbs: 0, fat: 0 }
    }
    const ratio = form.value.intakeAmount / selectedFoodInfo.value.stdUnit
    return {
        calories: (selectedFoodInfo.value.calories * ratio).toFixed(1),
        protein: (selectedFoodInfo.value.protein * ratio).toFixed(1),
        carbs: (selectedFoodInfo.value.carbohydrate * ratio).toFixed(1),
        fat: (selectedFoodInfo.value.fat * ratio).toFixed(1)
    }
})

const searchFoods = async (query) => {
    if (!query || query.trim() === '') {
        // Load initial foods
        try {
            foodSearchLoading.value = true
            const res = await axios.get('/api/nutrition/foods')
            if (res.data.code === 200) {
                foodList.value = res.data.data || []
            }
        } catch (err) {
            console.error('获取食物列表失败', err)
        } finally {
            foodSearchLoading.value = false
        }
        return
    }
    
    try {
        foodSearchLoading.value = true
        const res = await axios.get('/api/nutrition/foods', { params: { query } })
        if (res.data.code === 200) {
            foodList.value = res.data.data || []
        }
    } catch (err) {
        console.error('搜索食物失败', err)
    } finally {
        foodSearchLoading.value = false
    }
}

const onFoodSelected = async (foodId) => {
    if (!foodId) {
        selectedFoodInfo.value = null
        return
    }
    
    try {
        const res = await axios.get(`/api/nutrition/foods/${foodId}`)
        if (res.data.code === 200) {
            selectedFoodInfo.value = res.data.data
            // Set default intake amount to standard unit
            form.value.intakeAmount = res.data.data.stdUnit || 1
        }
    } catch (err) {
        console.error('获取食物详情失败', err)
        ElMessage.error('获取食物详情失败')
    }
}

const addMeal = async () => {
    if (!form.value.selectedFood) {
        ElMessage.warning('请选择食物')
        return
    }
    
    try {
        const nutrition = calculatedNutrition.value
        const res = await axios.post('/api/nutrition/diet-logs', {
            userId,
            foodId: form.value.selectedFood,
            logDate: new Date().toISOString().split('T')[0],
            mealType: getMealTypeValue(form.value.mealType),
            intakeAmount: form.value.intakeAmount,
            calcCalories: parseFloat(nutrition.calories),
            calcProtein: parseFloat(nutrition.protein),
            calcCarbs: parseFloat(nutrition.carbs),
            calcFat: parseFloat(nutrition.fat)
        })
        if (res.data.code === 200) {
            dialogVisible.value = false
            ElMessage.success('添加成功')
            fetchMeals()
            // Reset form
            form.value = {
                mealType: '早餐',
                selectedFood: null,
                intakeAmount: 1
            }
            selectedFoodInfo.value = null
        } else {
            ElMessage.error(res.data.msg || '添加失败')
        }
    } catch (err) {
        console.error('添加失败', err)
        ElMessage.error('添加失败')
    }
}

const openDialog = () => {
    dialogVisible.value = true
    // Load initial foods when dialog opens
    searchFoods('')
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
