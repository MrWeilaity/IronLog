# IronLog 数据库初始化指南

## 📋 概述

本文档说明如何使用 `init_database.sql` 文件初始化 IronLog 数据库。

## 🚀 快速开始

### 方法一：使用 MySQL 命令行

```bash
# 1. 登录 MySQL
mysql -u root -p

# 2. 创建数据库（如果还没有创建）
CREATE DATABASE ironlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 3. 退出 MySQL
exit

# 4. 执行初始化脚本
mysql -u root -p ironlog < init_database.sql
```

### 方法二：使用 MySQL Workbench

1. 打开 MySQL Workbench
2. 连接到你的 MySQL 服务器
3. 创建新数据库（如果需要）：
   ```sql
   CREATE DATABASE ironlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
4. 选择 `ironlog` 数据库
5. 点击 File → Open SQL Script
6. 选择 `init_database.sql` 文件
7. 点击执行按钮（闪电图标）

### 方法三：使用 phpMyAdmin

1. 登录 phpMyAdmin
2. 创建新数据库 `ironlog`，选择字符集为 `utf8mb4_unicode_ci`
3. 选择该数据库
4. 点击 "SQL" 标签
5. 点击 "选择文件" 按钮
6. 选择 `init_database.sql` 文件
7. 点击 "执行" 按钮

### 方法四：使用 Docker Compose（推荐）

```bash
# 1. 启动数据库容器
docker-compose up -d db

# 2. 等待数据库启动（约10秒）
sleep 10

# 3. 执行初始化脚本
docker exec -i ironlog-db mysql -uroot -proot ironlog < init_database.sql

# 4. 验证数据
docker exec -it ironlog-db mysql -uroot -proot ironlog -e "SELECT COUNT(*) FROM sys_user;"
```

## 📊 数据库结构

初始化脚本会创建以下表：

| 表名 | 说明 | 记录数 |
|------|------|--------|
| sys_user | 用户表 | 4 |
| base_action | 基础动作库 | 15 |
| food_nutrition | 食物营养库 | 10 |
| train_plan | 训练计划 | 2 |
| train_record | 训练记录 | 16 |
| diet_log | 饮食记录 | 9 |
| water_log | 饮水记录 | 13 |
| system_settings | 系统设置 | 4 |
| system_announcement | 系统公告 | 3 |

## 👤 默认用户账号

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | 123456 | ADMIN | 系统管理员 |
| zhangsan | 123456 | USER | 普通用户 |
| lisi | 123456 | USER | 普通用户 |
| wangwu | 123456 | USER | 普通用户 |

⚠️ **安全提示**：首次登录后，请立即修改默认密码！

## 🔄 更新现有数据库

如果你已经有一个旧版本的数据库，使用以下迁移脚本：

```bash
# 添加新字段（bio, email）和新表
mysql -u root -p ironlog < migration_002_add_bio_and_system_tables.sql

# 注意：migration_003_hash_passwords.sql 仅作为文档，实际密码加密由应用程序处理
```

## ✅ 验证安装

执行以下命令验证数据库是否正确初始化：

```sql
-- 检查所有表
SHOW TABLES;

-- 检查用户数据
SELECT id, username, nickname, role FROM sys_user;

-- 检查动作库
SELECT COUNT(*) as action_count FROM base_action;

-- 检查训练记录
SELECT COUNT(*) as training_count FROM train_record;
```

预期输出：
- 应该有 9 个表
- 应该有 4 个用户
- 应该有 15 个动作
- 应该有训练记录

## 🔐 密码加密说明

### 新用户注册
- 新注册的用户密码会自动使用 SHA-256 加密
- 加密过程在后端 `PasswordEncoder` 类中完成

### 现有用户登录
- 系统同时支持明文密码和加密密码登录（向后兼容）
- 首次登录后，建议使用管理后台的"重置密码"功能重新设置密码
- 重置后的密码会自动加密

### 密码加密迁移步骤

1. **初次安装**（推荐）：
   ```bash
   # 直接使用 init_database.sql，系统会自动处理
   mysql -u root -p ironlog < init_database.sql
   ```

2. **管理员操作**：
   - 登录管理后台
   - 进入"用户管理"
   - 为每个用户执行"重置密码"操作
   - 新密码会自动加密存储

## 🛠️ 故障排除

### 问题：字符编码错误

**解决方案**：
```bash
# 确保数据库使用 UTF-8 编码
ALTER DATABASE ironlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 问题：外键约束错误

**解决方案**：
```sql
-- 临时禁用外键检查
SET FOREIGN_KEY_CHECKS = 0;
-- 执行初始化脚本
SOURCE init_database.sql;
-- 重新启用外键检查
SET FOREIGN_KEY_CHECKS = 1;
```

### 问题：表已存在

**解决方案**：
脚本会自动删除旧表。如果需要保留数据，请先备份：

```bash
# 备份现有数据库
mysqldump -u root -p ironlog > backup_$(date +%Y%m%d).sql

# 然后执行初始化
mysql -u root -p ironlog < init_database.sql
```

## 📝 自定义配置

### 修改默认密码

编辑 `init_database.sql` 文件，找到用户插入语句，修改密码字段：

```sql
INSERT INTO sys_user (..., password, ...) VALUES
(..., '你的新密码', ...);
```

### 添加更多测试数据

在文件末尾的相应部分添加你的数据：

```sql
-- 添加更多用户
INSERT INTO sys_user (username, password, nickname, ...) VALUES
('newuser', '123456', '新用户', ...);

-- 添加更多动作
INSERT INTO base_action (name, target_muscle, ...) VALUES
('新动作', '目标肌群', ...);
```

## 🔗 相关文件

- `full_db_script.sql` - 完整的数据库脚本（包含所有更新）
- `migration_002_add_bio_and_system_tables.sql` - 迁移脚本：添加新字段和新表
- `migration_003_hash_passwords.sql` - 密码加密迁移说明文档

## 📞 技术支持

如遇问题，请查看：
1. 项目 README.md
2. GitHub Issues
3. 数据库日志文件

## 🔄 下一步

完成数据库初始化后：

1. **启动后端服务**：
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. **启动前端服务**：
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

3. **访问应用**：
   - 前端：http://localhost:5173
   - 后端API：http://localhost:8080
   - 管理后台：http://localhost:5173/admin/dashboard

4. **登录测试**：
   - 使用 admin / 123456 登录
   - 测试各项功能
   - 修改默认密码

祝使用愉快！💪
