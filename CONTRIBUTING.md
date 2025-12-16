# 贡献指南 (Contributing Guide)

感谢您有兴趣为 IronLog 项目做出贡献！本文档将帮助您了解如何参与项目开发。

## 📋 目录

- [行为准则](#行为准则)
- [如何贡献](#如何贡献)
- [开发流程](#开发流程)
- [代码规范](#代码规范)
- [提交规范](#提交规范)
- [问题反馈](#问题反馈)

## 🤝 行为准则

我们致力于为所有参与者提供一个友好、安全和包容的环境。请遵守以下准则：

- 使用友好和包容的语言
- 尊重不同的观点和经验
- 优雅地接受建设性批评
- 关注对社区最有利的事情
- 对其他社区成员表示同情

## 💡 如何贡献

您可以通过以下方式为项目做出贡献：

### 1. 报告 Bug

如果您发现了 bug，请通过 [GitHub Issues](https://github.com/MrWeilaity/IronLog/issues) 提交：

- 使用清晰描述性的标题
- 详细描述复现步骤
- 提供期望的行为和实际行为
- 如有可能，附上截图或错误日志
- 说明您的环境（操作系统、浏览器版本等）

### 2. 提出功能建议

我们欢迎新功能建议：

- 清楚地描述建议的功能
- 解释为什么这个功能对项目有用
- 如有可能，提供功能的实现思路

### 3. 提交代码

#### 准备工作

1. Fork 项目到您的 GitHub 账号
2. 克隆您 Fork 的仓库到本地
3. 添加上游仓库作为远程仓库

```bash
git clone https://github.com/YOUR_USERNAME/IronLog.git
cd IronLog
git remote add upstream https://github.com/MrWeilaity/IronLog.git
```

#### 创建分支

```bash
# 确保主分支是最新的
git checkout main
git pull upstream main

# 创建新的功能分支
git checkout -b feature/your-feature-name
```

#### 提交更改

```bash
# 添加更改的文件
git add .

# 提交更改
git commit -m "feat: add awesome feature"

# 推送到您的 Fork
git push origin feature/your-feature-name
```

#### 创建 Pull Request

1. 访问您 Fork 的 GitHub 页面
2. 点击 "New Pull Request"
3. 选择您的功能分支
4. 填写 PR 描述（使用提供的模板）
5. 提交 PR 并等待审核

## 🔄 开发流程

### 本地开发环境设置

详见 [README.md](README.md) 中的快速开始部分。

### 开发步骤

1. **创建分支**: 从 `main` 分支创建新的功能分支
2. **编写代码**: 实现您的功能或修复
3. **编写测试**: 如果适用，添加或更新测试
4. **运行测试**: 确保所有测试通过
5. **提交代码**: 遵循提交规范提交代码
6. **创建 PR**: 提交 Pull Request

### 分支命名规范

- `feature/xxx`: 新功能
- `bugfix/xxx`: Bug 修复
- `hotfix/xxx`: 紧急修复
- `docs/xxx`: 文档更新
- `refactor/xxx`: 代码重构
- `test/xxx`: 测试相关

## 📝 代码规范

### 后端 (Java)

- 遵循 Java 命名规范
- 使用有意义的变量和方法名
- 添加必要的注释（特别是复杂逻辑）
- 类和方法保持单一职责
- 使用 Lombok 简化代码

**示例**：

```java
@Service
@RequiredArgsConstructor
public class UserService {
    
    private final UserRepository userRepository;
    
    /**
     * 根据用户ID查询用户信息
     * @param userId 用户ID
     * @return 用户信息
     */
    public Optional<SysUser> getUserById(Long userId) {
        return userRepository.findById(userId);
    }
}
```

### 前端 (Vue 3)

- 使用组合式 API (Composition API)
- 组件名使用 PascalCase
- 方法名使用 camelCase
- 使用 ESLint 保持代码风格一致
- 组件应该是可复用和模块化的

**示例**：

```vue
<script setup>
import { ref, onMounted } from 'vue'

const userList = ref([])

const fetchUsers = async () => {
  // 获取用户列表
}

onMounted(() => {
  fetchUsers()
})
</script>

<template>
  <div class="user-list">
    <!-- 用户列表 -->
  </div>
</template>

<style scoped>
.user-list {
  /* 样式 */
}
</style>
```

### 数据库

- 表名使用小写，多个单词用下划线分隔（如 `sys_user`）
- 字段名使用小写，多个单词用下划线分隔
- 为外键和常用查询字段添加索引
- 添加必要的注释说明

## ✉️ 提交规范

我们使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

### 提交消息格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type 类型

- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式调整（不影响代码逻辑）
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动
- `perf`: 性能优化

### 示例

```bash
# 添加新功能
git commit -m "feat(training): add exercise template feature"

# 修复 Bug
git commit -m "fix(nutrition): correct calorie calculation error"

# 更新文档
git commit -m "docs: update API documentation"

# 代码重构
git commit -m "refactor(user): simplify authentication logic"
```

## 🐛 问题反馈

### 报告 Bug

使用以下模板报告 Bug：

```markdown
**Bug 描述**
简洁清晰地描述 bug

**复现步骤**
1. 进入 '...'
2. 点击 '...'
3. 滚动到 '...'
4. 看到错误

**期望行为**
描述您期望发生什么

**实际行为**
描述实际发生了什么

**截图**
如有可能，添加截图帮助解释问题

**环境信息**
- 操作系统: [如 Windows 10]
- 浏览器: [如 Chrome 120]
- 版本: [如 1.0.0]

**附加信息**
添加任何其他相关信息
```

### 功能请求

使用以下模板提交功能请求：

```markdown
**功能描述**
清晰简洁地描述您想要的功能

**问题说明**
描述这个功能要解决的问题

**建议的解决方案**
描述您希望如何实现这个功能

**替代方案**
描述您考虑过的其他解决方案

**附加信息**
添加任何其他相关信息或截图
```

## ✅ Pull Request 检查清单

提交 PR 前，请确保：

- [ ] 代码已经过本地测试
- [ ] 遵循项目的代码规范
- [ ] 提交信息遵循提交规范
- [ ] 已更新相关文档
- [ ] 没有引入新的警告或错误
- [ ] 代码可以成功构建
- [ ] 所有测试通过
- [ ] 功能已在本地环境验证

## 🎯 优先级

我们优先处理以下类型的贡献：

1. **Critical Bugs**: 影响核心功能的严重 Bug
2. **Security Issues**: 安全相关问题
3. **Performance**: 性能优化
4. **User Experience**: 用户体验改进
5. **New Features**: 新功能（需要讨论后再实现）

## 📞 联系方式

如有任何问题，可以通过以下方式联系：

- GitHub Issues: https://github.com/MrWeilaity/IronLog/issues
- 项目维护者: MrWeilaity

## 🙏 感谢

感谢您抽出时间为 IronLog 做出贡献！您的每一个贡献都让这个项目变得更好。

---

**Happy Coding! 💪**
