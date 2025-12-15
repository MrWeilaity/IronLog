-- Migration script to add bio field, email field, and system tables
-- Run this if upgrading from an older version

-- Add email and bio columns to sys_user table if they don't exist
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS email VARCHAR(255) UNIQUE;
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS bio TEXT;

-- Create system_settings table if it doesn't exist
CREATE TABLE IF NOT EXISTS system_settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(255) NOT NULL UNIQUE,
    setting_value TEXT,
    description VARCHAR(500),
    updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create system_announcement table if it doesn't exist
CREATE TABLE IF NOT EXISTS system_announcement (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    priority INT DEFAULT 0,
    status INT DEFAULT 1,
    created_at DATETIME,
    updated_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default system settings if they don't exist
INSERT IGNORE INTO system_settings (setting_key, setting_value, description, updated_at) VALUES
('site_title', 'IronLog 运动健康管理系统', '网站标题', NOW()),
('allow_registration', 'true', '是否允许用户注册', NOW()),
('maintenance_mode', 'false', '维护模式', NOW()),
('maintenance_message', '系统正在维护中，请稍后再试', '维护模式提示信息', NOW());

-- Insert sample announcements if the table is empty
INSERT INTO system_announcement (title, content, priority, status, created_at, updated_at)
SELECT * FROM (SELECT 
    '欢迎使用IronLog健身管理系统' as title,
    '欢迎使用IronLog！这是一个全方位的运动健康管理平台，帮助您记录训练、管理饮食、追踪进度。让我们一起开始健康生活吧！' as content,
    1 as priority,
    1 as status,
    DATE_SUB(NOW(), INTERVAL 7 DAY) as created_at,
    DATE_SUB(NOW(), INTERVAL 7 DAY) as updated_at
) AS tmp
WHERE NOT EXISTS (
    SELECT 1 FROM system_announcement LIMIT 1
);
