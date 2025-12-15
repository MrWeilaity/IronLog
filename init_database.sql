/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44)
 Source Host           : localhost:3306
 Source Schema         : ironlog

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44)
 File Encoding         : 65001

 Date: 16/12/2025 01:16:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for base_action
-- ----------------------------
DROP TABLE IF EXISTS `base_action`;
CREATE TABLE `base_action`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '动作名称',
  `alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '别名',
  `target_muscle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目标肌群',
  `equipment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '所需器械',
  `difficulty` int(11) NULL DEFAULT 1 COMMENT '难度: 1-初级, 2-中级, 3-高级',
  `gif_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '动作示意图URL',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '动作描述',
  `is_deleted` int(11) NULL DEFAULT 0 COMMENT '是否删除: 0-否, 1-是',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_target_muscle`(`target_muscle`) USING BTREE,
  INDEX `idx_difficulty`(`difficulty`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '基础动作库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of base_action
-- ----------------------------
INSERT INTO `base_action` VALUES (1, '杠铃卧推', '平板卧推', '胸部', '杠铃', 2, '/images/actions/bench_press.gif', '平躺在卧推凳上，双手握杠，推起重量。', 0);
INSERT INTO `base_action` VALUES (2, '俯卧撑', '标准俯卧撑', '胸部', '自重', 1, '/images/actions/push_up.gif', '双手撑地，身体呈一条直线，屈肘下降。', 0);
INSERT INTO `base_action` VALUES (3, '哑铃飞鸟', '平板飞鸟', '胸部', '哑铃', 2, '/images/actions/dumbbell_fly.gif', '仰卧，双手持哑铃向两侧展开，感受胸部拉伸。', 0);
INSERT INTO `base_action` VALUES (4, '硬拉', '传统硬拉', '背部', '杠铃', 3, '/images/actions/deadlift.gif', '保持背部挺直，将杠铃从地面拉起。', 0);
INSERT INTO `base_action` VALUES (5, '引体向上', '正手引体', '背部', '自重', 2, '/images/actions/pull_up.gif', '双手正握横杆，将身体拉至下巴过杆。', 0);
INSERT INTO `base_action` VALUES (6, '高位下拉', '器械下拉', '背部', '绳索', 1, '/images/actions/lat_pulldown.gif', '坐姿，双手宽握下拉横杆至上胸。', 0);
INSERT INTO `base_action` VALUES (7, '杠铃深蹲', '颈后深蹲', '腿部', '杠铃', 3, '/images/actions/squat.gif', '将杠铃扛在斜方肌上，屈髋屈膝下蹲。', 0);
INSERT INTO `base_action` VALUES (8, '腿举', '倒蹬机', '腿部', '器械', 1, '/images/actions/leg_press.gif', '坐在腿举机上，双脚用力蹬起踏板。', 0);
INSERT INTO `base_action` VALUES (9, '哑铃箭步蹲', '行走箭步蹲', '腿部', '哑铃', 2, '/images/actions/lunge.gif', '双手持哑铃，向前迈出一步下蹲。', 0);
INSERT INTO `base_action` VALUES (10, '站姿推举', '杠铃推举', '肩部', '杠铃', 2, '/images/actions/overhead_press.gif', '站立，将杠铃从锁骨处推至头顶。', 0);
INSERT INTO `base_action` VALUES (11, '哑铃侧平举', '侧平举', '肩部', '哑铃', 1, '/images/actions/lateral_raise.gif', '双手持哑铃向身体两侧举起。', 0);
INSERT INTO `base_action` VALUES (12, '杠铃弯举', '二头弯举', '二头肌', '杠铃', 1, '/images/actions/curl.svg', '站立，反握杠铃，屈肘弯举。', 0);
INSERT INTO `base_action` VALUES (13, '仰卧臂屈伸', '碎颅者', '三头肌', '杠铃', 2, '/images/actions/tricep_ext.gif', '仰卧，屈肘将杠铃放至额头上方，然后伸直手臂。', 0);
INSERT INTO `base_action` VALUES (14, '跑步', '慢跑', '有氧', '无', 1, '/images/actions/run.gif', '保持均匀呼吸和步伐。', 0);
INSERT INTO `base_action` VALUES (15, '骑行', '动感单车', '有氧', '单车', 1, '/images/actions/cycle.gif', '调节阻力，保持踏频。', 0);

-- ----------------------------
-- Table structure for diet_log
-- ----------------------------
DROP TABLE IF EXISTS `diet_log`;
CREATE TABLE `diet_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `food_id` bigint(20) NOT NULL COMMENT '食物ID',
  `log_date` date NOT NULL COMMENT '记录日期',
  `meal_type` int(11) NOT NULL COMMENT '餐次: 1-早餐, 2-午餐, 3-晚餐, 4-加餐',
  `intake_amount` decimal(38, 2) NOT NULL,
  `calc_calories` decimal(38, 2) NOT NULL,
  `calc_protein` decimal(38, 2) NOT NULL,
  `calc_fat` decimal(38, 2) NOT NULL,
  `calc_carbs` decimal(38, 2) NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_date`(`user_id`, `log_date`) USING BTREE,
  INDEX `idx_food_id`(`food_id`) USING BTREE,
  CONSTRAINT `fk_diet_food` FOREIGN KEY (`food_id`) REFERENCES `food_nutrition` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_diet_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '饮食记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of diet_log
-- ----------------------------
INSERT INTO `diet_log` VALUES (1, 1, 3, '2025-12-16', 1, 2.00, 140.00, 12.00, 10.00, 1.20, '2025-12-16 08:00:00');
INSERT INTO `diet_log` VALUES (2, 1, 5, '2025-12-16', 1, 1.00, 389.00, 16.90, 6.90, 66.30, '2025-12-16 08:00:00');
INSERT INTO `diet_log` VALUES (3, 1, 1, '2025-12-16', 2, 2.00, 330.00, 62.00, 7.20, 0.00, '2025-12-16 12:00:00');
INSERT INTO `diet_log` VALUES (4, 1, 2, '2025-12-16', 2, 2.00, 260.00, 5.40, 0.60, 56.00, '2025-12-16 12:00:00');
INSERT INTO `diet_log` VALUES (5, 1, 6, '2025-12-15', 4, 1.00, 120.00, 24.00, 1.00, 3.00, '2025-12-15 00:35:52');
INSERT INTO `diet_log` VALUES (6, 1, 1, '2025-12-15', 3, 2.00, 330.00, 62.00, 7.20, 0.00, '2025-12-15 00:35:52');
INSERT INTO `diet_log` VALUES (7, 2, 3, '2025-12-14', 1, 2.00, 140.00, 12.00, 10.00, 1.20, '2025-12-14 00:35:52');
INSERT INTO `diet_log` VALUES (8, 2, 2, '2025-12-14', 2, 2.00, 260.00, 5.40, 0.60, 56.00, '2025-12-14 00:35:52');
INSERT INTO `diet_log` VALUES (10, 1, 5, '2025-12-15', 2, 100.00, 389.00, 16.90, 6.90, 66.30, NULL);
INSERT INTO `diet_log` VALUES (11, 1, 4, '2025-12-15', 1, 1.00, 105.00, 1.30, 0.40, 27.00, NULL);
INSERT INTO `diet_log` VALUES (12, 1, 10, '2025-12-15', 1, 150.00, 80.00, 15.00, 0.00, 6.00, NULL);

-- ----------------------------
-- Table structure for food_nutrition
-- ----------------------------
DROP TABLE IF EXISTS `food_nutrition`;
CREATE TABLE `food_nutrition`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '食物名称',
  `brand` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '品牌',
  `std_unit` int(11) NULL DEFAULT NULL COMMENT '标准单位数量',
  `unit_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位类型',
  `calories` decimal(38, 2) NOT NULL,
  `protein` decimal(38, 2) NOT NULL,
  `fat` decimal(38, 2) NOT NULL,
  `carbohydrate` decimal(38, 2) NOT NULL,
  `sodium` decimal(38, 2) NULL DEFAULT NULL,
  `is_public` int(11) NULL DEFAULT 1 COMMENT '是否公开: 0-私有, 1-公开',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建者ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE,
  INDEX `idx_is_public`(`is_public`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食物营养库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food_nutrition
-- ----------------------------
INSERT INTO `food_nutrition` VALUES (1, '鸡胸肉', '通用', 100, '克', 165.00, 31.00, 3.60, 0.00, 74.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (2, '白米饭', '通用', 100, '克', 130.00, 2.70, 0.30, 28.00, 1.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (3, '鸡蛋', '通用', 1, '个', 70.00, 6.00, 5.00, 0.60, 70.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (4, '香蕉', '通用', 1, '根', 105.00, 1.30, 0.40, 27.00, 1.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (5, '燕麦片', '桂格', 100, '克', 389.00, 16.90, 6.90, 66.30, 2.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (6, '乳清蛋白粉', '欧普特蒙', 1, '勺', 120.00, 24.00, 1.00, 3.00, 130.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (7, '杏仁', '柯克兰', 28, '克', 164.00, 6.00, 14.00, 6.00, 0.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (8, '三文鱼', '通用', 100, '克', 208.00, 20.00, 13.00, 0.00, 59.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (9, '西兰花', '通用', 100, '克', 34.00, 2.80, 0.40, 7.00, 33.00, 1, 1);
INSERT INTO `food_nutrition` VALUES (10, '希腊酸奶', 'Chobani', 150, '克', 80.00, 15.00, 0.00, 6.00, 60.00, 1, 1);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `gender` int(11) NULL DEFAULT 0 COMMENT '性别: 0-保密, 1-男, 2-女',
  `height` decimal(38, 2) NULL DEFAULT NULL,
  `weight` decimal(38, 2) NULL DEFAULT NULL,
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '个人简介',
  `target_metabolism` int(11) NULL DEFAULT NULL COMMENT '目标代谢(kcal)',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'USER' COMMENT '角色: USER, ADMIN',
  `status` int(11) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_email`(`email`) USING BTREE,
  INDEX `idx_role`(`role`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '9d708eaec62a10270dc24e92352b5df479a37b31f6715480eaf784257ba2bf82', '管理员', NULL, 1, 180.00, 80.00, '1990-01-01', '系统管理员，负责平台日常管理和维护工作。', NULL, 'ADMIN', NULL, NULL, '2025-12-15 16:58:52');
INSERT INTO `sys_user` VALUES (2, 'zhangsan', 'e02d3b8543d033591d9e32ac3b6c2f860063d749a7cd6faf9202eae9caec35b8', '张三', 'zhangsan@example.com', 1, 175.00, 70.00, '1995-05-20', '健身爱好者，目标是练出完美身材。', 2200, 'USER', 1, '2025-10-17 00:35:52', '2025-12-15 17:02:23');

-- ----------------------------
-- Table structure for system_announcement
-- ----------------------------
DROP TABLE IF EXISTS `system_announcement`;
CREATE TABLE `system_announcement`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告内容',
  `priority` int(11) NULL DEFAULT 0 COMMENT '优先级: 0-普通, 1-重要, 2-紧急',
  `status` int(11) NULL DEFAULT 1 COMMENT '状态: 0-禁用, 1-启用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_priority`(`priority`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统公告' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_announcement
-- ----------------------------
INSERT INTO `system_announcement` VALUES (1, '欢迎使用IronLog健身管理系统', '欢迎使用IronLog！这是一个全方位的运动健康管理平台，帮助您记录训练、管理饮食、追踪进度。让我们一起开始健康生活吧！', 1, 1, '2025-12-09 00:35:52', '2025-12-09 00:35:52');
INSERT INTO `system_announcement` VALUES (2, '新功能上线：训练计划功能', '我们很高兴地宣布，训练计划功能已经上线！您现在可以创建个性化的训练计划，并按照计划进行系统的训练。', 0, 1, '2025-12-13 00:35:52', '2025-12-13 00:35:52');
INSERT INTO `system_announcement` VALUES (3, '系统维护通知', '系统将在本周日凌晨2:00-4:00进行例行维护，期间可能无法访问。请提前做好安排，给您带来不便敬请谅解。', 2, 1, '2025-12-15 00:35:52', '2025-12-15 00:35:52');

-- ----------------------------
-- Table structure for system_settings
-- ----------------------------
DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '设置键',
  `setting_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '设置值',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `setting_key`(`setting_key`) USING BTREE,
  INDEX `idx_setting_key`(`setting_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统设置' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_settings
-- ----------------------------
INSERT INTO `system_settings` VALUES (1, 'site_title', 'IronLog 运动健康管理系统', '网站标题', '2025-12-15 17:01:47');
INSERT INTO `system_settings` VALUES (2, 'allow_registration', 'false', '是否允许用户注册', '2025-12-15 17:01:47');
INSERT INTO `system_settings` VALUES (3, 'maintenance_mode', 'true', '维护模式', '2025-12-15 17:01:47');
INSERT INTO `system_settings` VALUES (4, 'maintenance_message', '系统正在维护中，请稍后再试', '维护模式提示信息', '2025-12-15 17:01:47');

-- ----------------------------
-- Table structure for train_plan
-- ----------------------------
DROP TABLE IF EXISTS `train_plan`;
CREATE TABLE `train_plan`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `plan_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '计划名称',
  `goal` int(11) NULL DEFAULT NULL COMMENT '目标: 1-增肌, 2-减脂, 3-力量',
  `weekly_schedule` json NULL COMMENT '周计划安排',
  `is_current` int(11) NULL DEFAULT 0 COMMENT '是否当前计划: 0-否, 1-是',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `fk_plan_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '训练计划' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of train_plan
-- ----------------------------
INSERT INTO `train_plan` VALUES (1, 1, '推拉腿分化', 1, '{\"Friday\": [\"上肢综合\"], \"Monday\": [\"胸部\", \"三头肌\"], \"Sunday\": [\"休息\"], \"Tuesday\": [\"背部\", \"二头肌\"], \"Saturday\": [\"下肢综合\"], \"Thursday\": [\"休息\"], \"Wednesday\": [\"腿部\", \"肩部\"]}', 1, '2025-11-16 00:35:52');
INSERT INTO `train_plan` VALUES (2, 2, '全身训练计划', 2, '{\"Friday\": [\"全身\"], \"Monday\": [\"全身\"], \"Sunday\": [\"休息\"], \"Tuesday\": [\"休息\"], \"Saturday\": [\"有氧\"], \"Thursday\": [\"休息\"], \"Wednesday\": [\"全身\"]}', 1, '2025-11-26 00:35:52');

-- ----------------------------
-- Table structure for train_record
-- ----------------------------
DROP TABLE IF EXISTS `train_record`;
CREATE TABLE `train_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `action_id` bigint(20) NULL DEFAULT NULL COMMENT '动作ID',
  `record_date` date NOT NULL COMMENT '训练日期',
  `set_no` int(11) NULL DEFAULT NULL COMMENT '组数',
  `weight` decimal(38, 2) NULL DEFAULT NULL,
  `reps` int(11) NULL DEFAULT NULL COMMENT '次数',
  `rpe` int(11) NULL DEFAULT NULL COMMENT 'RPE自觉强度',
  `superset_id` bigint(20) NULL DEFAULT NULL COMMENT '超级组ID',
  `note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `duration` int(11) NULL DEFAULT NULL COMMENT '时长(分钟)',
  `exercise_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '运动类型',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '详细笔记',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_date`(`user_id`, `record_date`) USING BTREE,
  INDEX `idx_action_id`(`action_id`) USING BTREE,
  CONSTRAINT `fk_record_action` FOREIGN KEY (`action_id`) REFERENCES `base_action` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_record_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '训练记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of train_record
-- ----------------------------
INSERT INTO `train_record` VALUES (1, 1, 1, '2025-12-10', 1, 60.00, 12, 7, NULL, '热身组', NULL, NULL, NULL, '2025-12-10 00:35:52');
INSERT INTO `train_record` VALUES (2, 1, 1, '2025-12-10', 2, 80.00, 8, 8, NULL, '正式组', NULL, NULL, NULL, '2025-12-10 00:35:52');
INSERT INTO `train_record` VALUES (3, 1, 1, '2025-12-10', 3, 80.00, 8, 9, NULL, '有点累', NULL, NULL, NULL, '2025-12-10 00:35:52');
INSERT INTO `train_record` VALUES (4, 1, 10, '2025-12-10', 1, 40.00, 10, 8, NULL, '站姿推举', NULL, NULL, NULL, '2025-12-10 00:35:52');
INSERT INTO `train_record` VALUES (5, 1, 10, '2025-12-10', 2, 40.00, 10, 8, NULL, NULL, NULL, NULL, NULL, '2025-12-10 00:35:52');
INSERT INTO `train_record` VALUES (6, 1, 4, '2025-12-11', 1, 100.00, 5, 8, NULL, '大重量硬拉', NULL, NULL, NULL, '2025-12-11 00:35:52');
INSERT INTO `train_record` VALUES (7, 1, 4, '2025-12-11', 2, 120.00, 3, 9, NULL, NULL, NULL, NULL, NULL, '2025-12-11 00:35:52');
INSERT INTO `train_record` VALUES (8, 1, 5, '2025-12-11', 1, 0.00, 10, 8, NULL, '自重引体', NULL, NULL, NULL, '2025-12-11 00:35:52');
INSERT INTO `train_record` VALUES (9, 1, 7, '2025-12-12', 1, 100.00, 5, 8, NULL, '深蹲', NULL, NULL, NULL, '2025-12-12 00:35:52');
INSERT INTO `train_record` VALUES (10, 1, 7, '2025-12-12', 2, 100.00, 5, 8, NULL, NULL, NULL, NULL, NULL, '2025-12-12 00:35:52');
INSERT INTO `train_record` VALUES (11, 2, 2, '2025-12-13', 1, 0.00, 15, 7, NULL, '俯卧撑', NULL, NULL, NULL, '2025-12-13 00:35:52');
INSERT INTO `train_record` VALUES (12, 2, 2, '2025-12-13', 2, 0.00, 12, 8, NULL, NULL, NULL, NULL, NULL, '2025-12-13 00:35:52');
INSERT INTO `train_record` VALUES (13, 2, 14, '2025-12-13', 1, 0.00, 30, 6, NULL, '跑步30分钟', NULL, NULL, NULL, '2025-12-13 00:35:52');
INSERT INTO `train_record` VALUES (17, 1, NULL, '2025-12-15', NULL, NULL, NULL, NULL, NULL, NULL, 30, '跑步', '', NULL);
INSERT INTO `train_record` VALUES (18, 1, NULL, '2025-12-15', NULL, NULL, NULL, NULL, NULL, NULL, 30, '游泳', '', NULL);
INSERT INTO `train_record` VALUES (19, 1, NULL, '2025-12-16', NULL, NULL, NULL, NULL, NULL, NULL, 30, '跑步', '', NULL);

-- ----------------------------
-- Table structure for water_log
-- ----------------------------
DROP TABLE IF EXISTS `water_log`;
CREATE TABLE `water_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `log_date` date NOT NULL COMMENT '记录日期',
  `amount_ml` int(11) NOT NULL COMMENT '饮水量(ml)',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_date`(`user_id`, `log_date`) USING BTREE,
  CONSTRAINT `fk_water_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '饮水记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of water_log
-- ----------------------------
INSERT INTO `water_log` VALUES (1, 1, '2025-12-10', 2500, '2025-12-10 00:35:52');
INSERT INTO `water_log` VALUES (2, 1, '2025-12-11', 3000, '2025-12-11 00:35:52');
INSERT INTO `water_log` VALUES (3, 1, '2025-12-12', 1500, '2025-12-12 00:35:52');
INSERT INTO `water_log` VALUES (4, 1, '2025-12-13', 2000, '2025-12-13 00:35:52');
INSERT INTO `water_log` VALUES (5, 1, '2025-12-14', 2800, '2025-12-14 00:35:52');
INSERT INTO `water_log` VALUES (6, 1, '2025-12-15', 3200, '2025-12-15 00:35:52');
INSERT INTO `water_log` VALUES (7, 1, '2025-12-16', 1000, '2025-12-16 00:35:52');
INSERT INTO `water_log` VALUES (8, 2, '2025-12-13', 2000, '2025-12-13 00:35:52');
INSERT INTO `water_log` VALUES (9, 2, '2025-12-14', 2500, '2025-12-14 00:35:52');
INSERT INTO `water_log` VALUES (10, 2, '2025-12-15', 2200, '2025-12-15 00:35:52');
INSERT INTO `water_log` VALUES (13, 1, '2025-12-16', 250, '2025-12-15 16:48:48');

SET FOREIGN_KEY_CHECKS = 1;
