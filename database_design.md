# IronLog Database Design Specification

**Role**: Senior Database Engineer
**Project**: IronLog (铁律)
**Database**: MySQL 8.0+
**Date**: 2023-10-27

---

## 1. ER Diagram Description (Relationship Analysis)

The system relies on 7 core tables (plus one helper table for badges) to manage users, training, nutrition, and social achievements. The relationships are defined as follows:

1.  **`sys_user` (User Base Table)**: The central entity.
    *   **1:N** with `train_plan`: A user can create multiple training plans.
    *   **1:N** with `train_record`: A user generates multiple training logs.
    *   **1:N** with `diet_log`: A user logs multiple diet entries.
    *   **1:N** with `user_badge`: A user can earn multiple badges.

2.  **`base_action` (Action Library)**: Stores standardized exercise definitions.
    *   **1:N** with `train_record`: Each training record refers to one specific action.

3.  **`train_record` (Training Record)**: The intersection of Users and Actions.
    *   Links `sys_user.id` and `base_action.id`.
    *   Records dynamic data like weight, reps, and RPE.

4.  **`train_plan` (Training Plan)**:
    *   Belongs to a `sys_user`.
    *   Stores the complex weekly schedule structure as a **JSON** document to allow flexibility without over-normalizing the schema for schedule variations.

5.  **`food_nutrition` (Food Library)**: Static database of food items.
    *   **1:N** with `diet_log`: A specific food item can be logged many times by many users.

6.  **`diet_log` (Diet Record)**: The intersection of Users and Foods.
    *   Links `sys_user.id` and `food_nutrition.id`.
    *   Calculates actual intake based on the `amount` logged vs. the base unit in `food_nutrition`.

7.  **`user_badge` (Badge Association)**: Implements the **Many-to-Many** relationship between Users and Badges.
    *   Links `sys_user.id` to `sys_badge.id` (Added `sys_badge` to complete the schema).
    *   Tracks *when* a user earned a specific badge.

---

## 2. SQL DDL Statements

### 2.1 System User & Auth
```sql
CREATE TABLE `sys_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Login username',
  `password` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'BCrypt encrypted password',
  `nickname` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Display name',
  `gender` tinyint unsigned DEFAULT '0' COMMENT '0: Secret, 1: Male, 2: Female',
  `height` decimal(5,2) DEFAULT NULL COMMENT 'Height in cm',
  `weight` decimal(5,2) DEFAULT NULL COMMENT 'Current weight in kg',
  `birthday` date DEFAULT NULL COMMENT 'Date of birth',
  `target_metabolism` int unsigned DEFAULT '2000' COMMENT 'Daily calorie target (Kcal)',
  `role` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'USER' COMMENT 'Role: USER, ADMIN, EDITOR',
  `status` tinyint unsigned DEFAULT '1' COMMENT '1: Active, 0: Banned',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='User Base Table';
```

### 2.2 Training Module

```sql
CREATE TABLE `base_action` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Action Name (e.g., Bench Press)',
  `alias` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Common aliases',
  `target_muscle` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Main muscle group (Chest, Back, etc.)',
  `equipment` varchar(50) COLLATE utf8mb4_general_ci DEFAULT 'None' COMMENT 'Required equipment (Barbell, Dumbbell)',
  `difficulty` tinyint unsigned DEFAULT '1' COMMENT '1: Beginner, 2: Intermediate, 3: Advanced',
  `gif_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'URL to demonstration GIF',
  `description` text COLLATE utf8mb4_general_ci COMMENT 'Detailed text instructions',
  `is_deleted` tinyint unsigned DEFAULT '0' COMMENT 'Logical delete flag',
  PRIMARY KEY (`id`),
  KEY `idx_muscle` (`target_muscle`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Action Library';
```

```sql
CREATE TABLE `train_plan` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `user_id` bigint unsigned NOT NULL COMMENT 'Owner User ID',
  `plan_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Name of the plan',
  `goal` tinyint unsigned DEFAULT '1' COMMENT '1: Muscle, 2: Fat Loss, 3: Strength',
  `weekly_schedule` json NOT NULL COMMENT 'JSON structure defining the weekly routine',
  `is_current` tinyint unsigned DEFAULT '0' COMMENT '1: Currently active plan',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_plan_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Training Plans (JSON)';
```

```sql
CREATE TABLE `train_record` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `user_id` bigint unsigned NOT NULL COMMENT 'User ID',
  `action_id` bigint unsigned NOT NULL COMMENT 'Action ID',
  `record_date` date NOT NULL COMMENT 'Date of the workout',
  `set_no` int unsigned NOT NULL COMMENT 'Set number (1, 2, 3...)',
  `weight` decimal(6,2) NOT NULL COMMENT 'Weight used (kg)',
  `reps` int unsigned NOT NULL COMMENT 'Repetitions performed',
  `rpe` tinyint unsigned DEFAULT NULL COMMENT 'Rate of Perceived Exertion (1-10)',
  `superset_id` bigint unsigned DEFAULT NULL COMMENT 'ID to group actions done in a superset',
  `note` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'User notes',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_date` (`user_id`, `record_date`),
  KEY `idx_action` (`action_id`),
  CONSTRAINT `fk_record_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_record_action` FOREIGN KEY (`action_id`) REFERENCES `base_action` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Training Logs';
```

### 2.3 Nutrition Module (Detailed per Request)

```sql
CREATE TABLE `food_nutrition` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Food Name',
  `brand` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Brand Name (optional)',
  `std_unit` int unsigned DEFAULT '100' COMMENT 'Standard measurement unit amount (usually 100)',
  `unit_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'g' COMMENT 'Unit type: g, ml, serving',
  `calories` decimal(6,2) NOT NULL COMMENT 'Energy per std_unit (Kcal)',
  `protein` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT 'Protein per std_unit (g)',
  `fat` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT 'Fat per std_unit (g)',
  `carbohydrate` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT 'Carbs per std_unit (g)',
  `sodium` decimal(6,2) DEFAULT '0.00' COMMENT 'Sodium (mg) - Optional extended data',
  `is_public` tinyint unsigned DEFAULT '1' COMMENT '1: System verified, 0: User custom',
  `created_by` bigint unsigned DEFAULT '0' COMMENT '0 for System, else User ID',
  PRIMARY KEY (`id`),
  KEY `idx_food_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Food & Nutrition Database';
```

```sql
CREATE TABLE `diet_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `user_id` bigint unsigned NOT NULL COMMENT 'Foreign Key: User',
  `food_id` bigint unsigned NOT NULL COMMENT 'Foreign Key: Food',
  `log_date` date NOT NULL COMMENT 'Date of consumption',
  `meal_type` tinyint unsigned NOT NULL COMMENT '1: Breakfast, 2: Lunch, 3: Dinner, 4: Snack',
  `intake_amount` decimal(6,2) NOT NULL COMMENT 'Actual amount consumed (g/ml)',
  /*
     We store calculated values to persist historical accuracy even if the base food data changes later.
     This is a common design pattern for auditability in logging systems.
  */
  `calc_calories` decimal(8,2) NOT NULL COMMENT 'Calculated Calories for this entry',
  `calc_protein` decimal(8,2) NOT NULL COMMENT 'Calculated Protein',
  `calc_fat` decimal(8,2) NOT NULL COMMENT 'Calculated Fat',
  `calc_carbs` decimal(8,2) NOT NULL COMMENT 'Calculated Carbs',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_log_date` (`user_id`, `log_date`),
  CONSTRAINT `fk_diet_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_diet_food` FOREIGN KEY (`food_id`) REFERENCES `food_nutrition` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Daily Diet Consumption Log';
```

### 2.4 Social & Badge Module

```sql
CREATE TABLE `sys_badge` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Badge Name',
  `icon_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Badge Icon',
  `condition_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Condition: STREAK, VOLUME, etc.',
  `threshold` int unsigned NOT NULL COMMENT 'Value to trigger (e.g., 30 days)',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='System Badge Definitions';
```

```sql
CREATE TABLE `user_badge` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary Key',
  `user_id` bigint unsigned NOT NULL COMMENT 'User ID',
  `badge_id` bigint unsigned NOT NULL COMMENT 'Badge ID',
  `obtained_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Date obtained',
  `is_displayed` tinyint unsigned DEFAULT '0' COMMENT '1: Shown on profile wall',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_badge` (`user_id`, `badge_id`),
  CONSTRAINT `fk_ub_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ub_badge` FOREIGN KEY (`badge_id`) REFERENCES `sys_badge` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='User Badge Association (Many-to-Many)';
```
