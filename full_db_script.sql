-- 1. Dropping existing tables (Reverse order of dependencies)
DROP TABLE IF EXISTS water_log;
DROP TABLE IF EXISTS diet_log;
DROP TABLE IF EXISTS train_record;
DROP TABLE IF EXISTS train_plan;
DROP TABLE IF EXISTS food_nutrition;
DROP TABLE IF EXISTS base_action;
DROP TABLE IF EXISTS sys_user;

-- 2. Creating Tables

-- Table: sys_user
CREATE TABLE sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(255),
    email VARCHAR(255),
    gender INT, -- 0: 保密, 1: 男, 2: 女
    height DECIMAL(10, 2),
    weight DECIMAL(10, 2),
    birthday DATE,
    bio TEXT,
    target_metabolism INT,
    role VARCHAR(255),
    status INT,
    created_at DATETIME,
    updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: base_action
CREATE TABLE base_action (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    alias VARCHAR(255),
    target_muscle VARCHAR(255) NOT NULL,
    equipment VARCHAR(255),
    difficulty INT, -- 1: 初级, 2: 中级, 3: 高级
    gif_url VARCHAR(255),
    description VARCHAR(255),
    is_deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: food_nutrition
CREATE TABLE food_nutrition (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(255),
    std_unit INT,
    unit_type VARCHAR(255),
    calories DECIMAL(10, 2) NOT NULL,
    protein DECIMAL(10, 2) NOT NULL,
    fat DECIMAL(10, 2) NOT NULL,
    carbohydrate DECIMAL(10, 2) NOT NULL,
    sodium DECIMAL(10, 2),
    is_public INT DEFAULT 1,
    created_by BIGINT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: train_plan
CREATE TABLE train_plan (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    plan_name VARCHAR(255) NOT NULL,
    goal INT, -- 1: 增肌, 2: 减脂, 3: 力量
    weekly_schedule JSON,
    is_current INT DEFAULT 0,
    created_at DATETIME,
    CONSTRAINT fk_plan_user FOREIGN KEY (user_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: train_record
CREATE TABLE train_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    action_id BIGINT,  -- Made nullable to support simple workout logging
    record_date DATE NOT NULL,
    set_no INT,  -- Made nullable to support simple workout logging
    weight DECIMAL(10, 2),  -- Made nullable to support simple workout logging
    reps INT,  -- Made nullable to support simple workout logging
    rpe INT,
    superset_id BIGINT,
    note VARCHAR(255),
    duration INT,  -- Duration in minutes for simple workout logging
    exercise_type VARCHAR(100),  -- Type of exercise for simple workout logging
    notes TEXT,  -- Additional notes for simple workout logging
    created_at DATETIME,
    CONSTRAINT fk_record_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
    CONSTRAINT fk_record_action FOREIGN KEY (action_id) REFERENCES base_action(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: diet_log
CREATE TABLE diet_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    food_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    meal_type INT NOT NULL, -- 1: 早餐, 2: 午餐, 3: 晚餐, 4: 加餐
    intake_amount DECIMAL(10, 2) NOT NULL,
    calc_calories DECIMAL(10, 2) NOT NULL,
    calc_protein DECIMAL(10, 2) NOT NULL,
    calc_fat DECIMAL(10, 2) NOT NULL,
    calc_carbs DECIMAL(10, 2) NOT NULL,
    created_at DATETIME,
    CONSTRAINT fk_diet_user FOREIGN KEY (user_id) REFERENCES sys_user(id),
    CONSTRAINT fk_diet_food FOREIGN KEY (food_id) REFERENCES food_nutrition(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: water_log
CREATE TABLE water_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    amount_ml INT NOT NULL,
    created_at DATETIME,
    CONSTRAINT fk_water_user FOREIGN KEY (user_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: system_settings
CREATE TABLE system_settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(255) NOT NULL UNIQUE,
    setting_value TEXT,
    description VARCHAR(500),
    updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: system_announcement
CREATE TABLE system_announcement (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    priority INT DEFAULT 0, -- 0: 正常, 1: 重要, 2: 紧急
    status INT DEFAULT 1, -- 0: 禁用, 1: 启用
    created_at DATETIME,
    updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 3. Inserting Data (Using Chinese names)

-- Users (密码均为 123456)
INSERT INTO sys_user (id, username, password, nickname, email, gender, height, weight, birthday, bio, target_metabolism, role, status, created_at, updated_at) VALUES
(1, 'admin', '123456', '管理员', 'admin@ironlog.com', 1, 180.00, 80.00, '1990-01-01', '系统管理员，负责平台日常管理和维护工作。', 2500, 'ADMIN', 1, DATE_SUB(NOW(), INTERVAL 90 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'zhangsan', '123456', '张三', 'zhangsan@example.com', 1, 175.00, 70.00, '1995-05-20', '健身爱好者，目标是练出完美身材。', 2200, 'USER', 1, DATE_SUB(NOW(), INTERVAL 60 DAY), DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 'lisi', '123456', '李四', 'lisi@example.com', 1, 178.00, 75.00, '1992-08-15', '力量训练爱好者，专注于提高最大力量。', 2300, 'USER', 1, DATE_SUB(NOW(), INTERVAL 45 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
(4, 'wangwu', '123456', '王五', 'wangwu@example.com', 2, 165.00, 55.00, '1998-03-10', '瑜伽和有氧运动爱好者，追求健康生活方式。', 1800, 'USER', 1, DATE_SUB(NOW(), INTERVAL 30 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY));

-- Base Actions (动作库)
-- 胸部
INSERT INTO base_action (id, name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
(1, '杠铃卧推', '平板卧推', '胸部', '杠铃', 2, '/images/actions/bench_press.gif', '平躺在卧推凳上，双手握杠，推起重量。', 0),
(2, '俯卧撑', '标准俯卧撑', '胸部', '自重', 1, '/images/actions/push_up.gif', '双手撑地，身体呈一条直线，屈肘下降。', 0),
(3, '哑铃飞鸟', '平板飞鸟', '胸部', '哑铃', 2, '/images/actions/dumbbell_fly.gif', '仰卧，双手持哑铃向两侧展开，感受胸部拉伸。', 0);

-- 背部
INSERT INTO base_action (id, name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
(4, '硬拉', '传统硬拉', '背部', '杠铃', 3, '/images/actions/deadlift.gif', '保持背部挺直，将杠铃从地面拉起。', 0),
(5, '引体向上', '正手引体', '背部', '自重', 2, '/images/actions/pull_up.gif', '双手正握横杆，将身体拉至下巴过杆。', 0),
(6, '高位下拉', '器械下拉', '背部', '绳索', 1, '/images/actions/lat_pulldown.gif', '坐姿，双手宽握下拉横杆至上胸。', 0);

-- 腿部
INSERT INTO base_action (id, name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
(7, '杠铃深蹲', '颈后深蹲', '腿部', '杠铃', 3, '/images/actions/squat.gif', '将杠铃扛在斜方肌上，屈髋屈膝下蹲。', 0),
(8, '腿举', '倒蹬机', '腿部', '器械', 1, '/images/actions/leg_press.gif', '坐在腿举机上，双脚用力蹬起踏板。', 0),
(9, '哑铃箭步蹲', '行走箭步蹲', '腿部', '哑铃', 2, '/images/actions/lunge.gif', '双手持哑铃，向前迈出一步下蹲。', 0);

-- 肩部
INSERT INTO base_action (id, name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
(10, '站姿推举', '杠铃推举', '肩部', '杠铃', 2, '/images/actions/overhead_press.gif', '站立，将杠铃从锁骨处推至头顶。', 0),
(11, '哑铃侧平举', '侧平举', '肩部', '哑铃', 1, '/images/actions/lateral_raise.gif', '双手持哑铃向身体两侧举起。', 0);

-- 手臂
INSERT INTO base_action (id, name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
(12, '杠铃弯举', '二头弯举', '二头肌', '杠铃', 1, '/images/actions/curl.svg', '站立，反握杠铃，屈肘弯举。', 0),
(13, '仰卧臂屈伸', '碎颅者', '三头肌', '杠铃', 2, '/images/actions/tricep_ext.gif', '仰卧，屈肘将杠铃放至额头上方，然后伸直手臂。', 0);

-- 有氧
INSERT INTO base_action (id, name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
(14, '跑步', '慢跑', '有氧', '无', 1, '/images/actions/run.gif', '保持均匀呼吸和步伐。', 0),
(15, '骑行', '动感单车', '有氧', '单车', 1, '/images/actions/cycle.gif', '调节阻力，保持踏频。', 0);

-- Food Nutrition (食物库)
INSERT INTO food_nutrition (id, name, brand, std_unit, unit_type, calories, protein, fat, carbohydrate, sodium, is_public, created_by) VALUES
(1, '鸡胸肉', '通用', 100, '克', 165.00, 31.00, 3.60, 0.00, 74.00, 1, 1),
(2, '白米饭', '通用', 100, '克', 130.00, 2.70, 0.30, 28.00, 1.00, 1, 1),
(3, '鸡蛋', '通用', 1, '个', 70.00, 6.00, 5.00, 0.60, 70.00, 1, 1),
(4, '香蕉', '通用', 1, '根', 105.00, 1.30, 0.40, 27.00, 1.00, 1, 1),
(5, '燕麦片', '桂格', 100, '克', 389.00, 16.90, 6.90, 66.30, 2.00, 1, 1),
(6, '乳清蛋白粉', '欧普特蒙', 1, '勺', 120.00, 24.00, 1.00, 3.00, 130.00, 1, 1),
(7, '杏仁', '柯克兰', 28, '克', 164.00, 6.00, 14.00, 6.00, 0.00, 1, 1),
(8, '三文鱼', '通用', 100, '克', 208.00, 20.00, 13.00, 0.00, 59.00, 1, 1),
(9, '西兰花', '通用', 100, '克', 34.00, 2.80, 0.40, 7.00, 33.00, 1, 1),
(10, '希腊酸奶', 'Chobani', 150, '克', 80.00, 15.00, 0.00, 6.00, 60.00, 1, 1);

-- Train Plan (训练计划)
-- 管理员的 "推拉腿" 计划
INSERT INTO train_plan (user_id, plan_name, goal, weekly_schedule, is_current, created_at) VALUES
(1, '推拉腿分化', 1, '{"Monday": ["胸部", "三头肌"], "Tuesday": ["背部", "二头肌"], "Wednesday": ["腿部", "肩部"], "Thursday": ["休息"], "Friday": ["上肢综合"], "Saturday": ["下肢综合"], "Sunday": ["休息"]}', 1, NOW());

-- Train Record (训练记录)
-- Day 1: 推 (6天前)
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 60.00, 12, 7, NULL, '热身组', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 2, 80.00, 8, 8, NULL, '正式组', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 3, 80.00, 8, 9, NULL, '有点累', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, 10, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 40.00, 10, 8, NULL, '站姿推举', DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, 10, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 2, 40.00, 10, 8, NULL, NULL, DATE_SUB(NOW(), INTERVAL 6 DAY));

-- Day 2: 拉 (5天前)
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 100.00, 5, 8, NULL, '大重量硬拉', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 2, 120.00, 3, 9, NULL, NULL, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 5, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0.00, 10, 8, NULL, '自重引体', DATE_SUB(NOW(), INTERVAL 5 DAY));

-- Day 3: 腿 (4天前)
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 7, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 100.00, 5, 8, NULL, '深蹲', DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 7, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 2, 100.00, 5, 8, NULL, NULL, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, 2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0.00, 15, 7, NULL, '俯卧撑', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 2, 0.00, 12, 8, NULL, NULL, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 14, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, 0.00, 30, 6, NULL, '跑步30分钟', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(3, 7, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 120.00, 5, 9, NULL, '深蹲', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 7, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 2, 120.00, 5, 9, NULL, NULL, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, 4, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 140.00, 5, 9, NULL, '硬拉', DATE_SUB(NOW(), INTERVAL 2 DAY));

-- Diet Log (饮食记录)
INSERT INTO diet_log (user_id, food_id, log_date, meal_type, intake_amount, calc_calories, calc_protein, calc_fat, calc_carbs, created_at) VALUES
(1, 3, CURDATE(), 1, 2.00, 140.00, 12.00, 10.00, 1.20, DATE_ADD(CURDATE(), INTERVAL 8 HOUR)), -- 2个鸡蛋 早餐
(1, 5, CURDATE(), 1, 1.00, 389.00, 16.90, 6.90, 66.30, DATE_ADD(CURDATE(), INTERVAL 8 HOUR)), -- 100g 燕麦
(1, 1, CURDATE(), 2, 2.00, 330.00, 62.00, 7.20, 0.00, DATE_ADD(CURDATE(), INTERVAL 12 HOUR)), -- 200g 鸡胸肉 午餐
(1, 2, CURDATE(), 2, 2.00, 260.00, 5.40, 0.60, 56.00, DATE_ADD(CURDATE(), INTERVAL 12 HOUR)), -- 200g 米饭
(1, 6, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 4, 1.00, 120.00, 24.00, 1.00, 3.00, DATE_SUB(NOW(), INTERVAL 1 DAY)), -- 蛋白粉 加餐
(1, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 3, 2.00, 330.00, 62.00, 7.20, 0.00, DATE_SUB(NOW(), INTERVAL 1 DAY)), -- 鸡胸肉 晚餐
(2, 3, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 2.00, 140.00, 12.00, 10.00, 1.20, DATE_SUB(NOW(), INTERVAL 2 DAY)), -- 鸡蛋
(2, 2, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 2, 2.00, 260.00, 5.40, 0.60, 56.00, DATE_SUB(NOW(), INTERVAL 2 DAY)), -- 米饭
(3, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 2, 2.50, 412.50, 77.50, 9.00, 0.00, DATE_SUB(NOW(), INTERVAL 1 DAY)); -- 鸡胸肉

-- Water Log (饮水记录)
INSERT INTO water_log (user_id, log_date, amount_ml, created_at) VALUES
(1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 2500, DATE_SUB(NOW(), INTERVAL 6 DAY)),
(1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 3000, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1500, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 2000, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 2800, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 3200, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(1, CURDATE(), 1000, NOW()),
(2, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 2000, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 2500, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 2200, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 2800, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(3, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 3000, DATE_SUB(NOW(), INTERVAL 1 DAY));

-- System Settings (系统设置)
INSERT INTO system_settings (setting_key, setting_value, description, updated_at) VALUES
('site_title', 'IronLog 运动健康管理系统', '网站标题', NOW()),
('allow_registration', 'true', '是否允许用户注册', NOW()),
('maintenance_mode', 'false', '维护模式', NOW()),
('maintenance_message', '系统正在维护中，请稍后再试', '维护模式提示信息', NOW());

-- System Announcements (系统公告)
INSERT INTO system_announcement (title, content, priority, status, created_at, updated_at) VALUES
('欢迎使用IronLog健身管理系统', '欢迎使用IronLog！这是一个全方位的运动健康管理平台，帮助您记录训练、管理饮食、追踪进度。让我们一起开始健康生活吧！', 1, 1, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_SUB(NOW(), INTERVAL 7 DAY)),
('新功能上线：训练计划功能', '我们很高兴地宣布，训练计划功能已经上线！您现在可以创建个性化的训练计划，并按照计划进行系统的训练。', 0, 1, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_SUB(NOW(), INTERVAL 3 DAY)),
('系统维护通知', '系统将在本周日凌晨2:00-4:00进行例行维护，期间可能无法访问。请提前做好安排，给您带来不便敬请谅解。', 2, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY));
