<template>
  <div class="not-found">
    <h1>404</h1>
    <p>页面未找到</p>
    <el-button type="primary" @click="$router.push('/')">返回首页</el-button>
  </div>
</template>

<style scoped>
.not-found {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
}
h1 {
    font-size: 72px;
    margin-bottom: 20px;
    color: #409EFF;
}
p {
    font-size: 24px;
    margin-bottom: 30px;
    color: #606266;
}
</style>
