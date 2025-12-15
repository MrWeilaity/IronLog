-- Users
-- Clear existing data (optional, but good for idempotency if running manually, though data.sql usually runs on clean DB in some modes)
-- DELETE FROM water_log;
-- DELETE FROM diet_log;
-- DELETE FROM train_record;
-- DELETE FROM train_plan;
-- DELETE FROM user_badge;
-- DELETE FROM sys_badge;
-- DELETE FROM food_nutrition;
-- DELETE FROM base_action;
-- DELETE FROM sys_user;

-- Reset IDs (MySQL specific)
-- ALTER TABLE sys_user AUTO_INCREMENT = 1;

-- 1. Users (password: 123456)
INSERT INTO sys_user (id, username, password, nickname, gender, height, weight, birthday, role, status, created_at, updated_at) VALUES
(1, 'admin', 'admin123', 'Iron Admin', 1, 180.0, 80.0, '1990-01-01', 'ADMIN', 1, NOW(), NOW()),
(2, 'user1', '123456', 'Alice Fit', 2, 165.0, 55.0, '1995-05-15', 'USER', 1, NOW(), NOW()),
(3, 'user2', '123456', 'Bob Builder', 1, 175.0, 85.0, '1988-11-20', 'USER', 1, NOW(), NOW()),
(4, 'user3', '123456', 'Charlie Runner', 1, 178.0, 70.0, '1992-03-10', 'USER', 1, NOW(), NOW()),
(5, 'user4', '123456', 'Diana Yoga', 2, 170.0, 60.0, '1998-07-25', 'USER', 1, NOW(), NOW());

-- 2. Base Actions (Exercises)
-- Chest
INSERT INTO base_action (name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
('Barbell Bench Press', 'Bench Press', 'Chest', 'Barbell', 2, '/images/actions/bench_press.gif', 'Lie on a flat bench and press the weight up.', 0),
('Push Up', 'Pushup', 'Chest', 'Bodyweight', 1, '/images/actions/push_up.gif', 'Standard push up.', 0),
('Dumbbell Fly', 'Chest Fly', 'Chest', 'Dumbbell', 2, '/images/actions/dumbbell_fly.gif', 'Open arms wide.', 0);

-- Back
INSERT INTO base_action (name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
('Deadlift', 'Deadlift', 'Back', 'Barbell', 3, '/images/actions/deadlift.gif', 'Lift weight from ground.', 0),
('Pull Up', 'Pullup', 'Back', 'Bodyweight', 2, '/images/actions/pull_up.gif', 'Pull body up to bar.', 0),
('Lat Pulldown', 'Pulldown', 'Back', 'Cable', 1, '/images/actions/lat_pulldown.gif', 'Pull bar down to chest.', 0);

-- Legs
INSERT INTO base_action (name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
('Barbell Squat', 'Squat', 'Legs', 'Barbell', 3, '/images/actions/squat.gif', 'Squat down with weight.', 0),
('Leg Press', 'Leg Press', 'Legs', 'Machine', 1, '/images/actions/leg_press.gif', 'Push weight with legs.', 0),
('Lunge', 'Walking Lunge', 'Legs', 'Dumbbell', 2, '/images/actions/lunge.gif', 'Step forward and drop hips.', 0);

-- Shoulders
INSERT INTO base_action (name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
('Overhead Press', 'OHP', 'Shoulders', 'Barbell', 2, '/images/actions/overhead_press.gif', 'Press weight over head.', 0),
('Lateral Raise', 'Side Raise', 'Shoulders', 'Dumbbell', 1, '/images/actions/lateral_raise.gif', 'Raise arms to sides.', 0);

-- Arms
INSERT INTO base_action (name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
('Barbell Curl', 'Bicep Curl', 'Biceps', 'Barbell', 1, '/images/actions/curl.svg', 'Curl bar up.', 0),
('Tricep Extension', 'Skullcrusher', 'Triceps', 'Barbell', 2, '/images/actions/tricep_ext.gif', 'Extend arms lying down.', 0);

-- Cardio
INSERT INTO base_action (name, alias, target_muscle, equipment, difficulty, gif_url, description, is_deleted) VALUES
('Running', 'Jogging', 'Cardio', 'None', 1, '/images/actions/run.gif', 'Run at a steady pace.', 0),
('Cycling', 'Biking', 'Cardio', 'Bicycle', 1, '/images/actions/cycle.gif', 'Ride a bike.', 0);


-- 3. Food Nutrition
INSERT INTO food_nutrition (name, brand, std_unit, unit_type, calories, protein, fat, carbohydrate, sodium, is_public, created_by) VALUES
('Chicken Breast', 'Generic', 100, 'g', 165.0, 31.0, 3.6, 0.0, 74.0, 1, 1),
('White Rice', 'Generic', 100, 'g', 130.0, 2.7, 0.3, 28.0, 1.0, 1, 1),
('Egg', 'Generic', 1, 'large', 70.0, 6.0, 5.0, 0.6, 70.0, 1, 1),
('Banana', 'Generic', 1, 'medium', 105.0, 1.3, 0.4, 27.0, 1.0, 1, 1),
('Oatmeal', 'Quaker', 100, 'g', 389.0, 16.9, 6.9, 66.3, 2.0, 1, 1),
('Whey Protein', 'Optimum Nutrition', 1, 'scoop', 120.0, 24.0, 1.0, 3.0, 130.0, 1, 1),
('Almonds', 'Blue Diamond', 28, 'g', 164.0, 6.0, 14.0, 6.0, 0.0, 1, 1),
('Salmon', 'Generic', 100, 'g', 208.0, 20.0, 13.0, 0.0, 59.0, 1, 1),
('Broccoli', 'Generic', 100, 'g', 34.0, 2.8, 0.4, 7.0, 33.0, 1, 1),
('Greek Yogurt', 'Chobani', 150, 'g', 80.0, 15.0, 0.0, 6.0, 60.0, 1, 1);


-- 4. Train Plan (JSON for Weekly Schedule)
INSERT INTO train_plan (user_id, plan_name, goal, weekly_schedule, is_current, created_at) VALUES
(1, 'PPL Split', 1, '{"Monday": ["Chest", "Triceps"], "Tuesday": ["Back", "Biceps"], "Wednesday": ["Legs", "Shoulders"], "Thursday": ["Rest"], "Friday": ["Upper Body"], "Saturday": ["Lower Body"], "Sunday": ["Rest"]}', 1, NOW());


-- 5. Training History (Last 7 Days for Admin)
-- Day 1: Push
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 60.0, 12, 7, NULL, 'Warmup', NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 2, 80.0, 8, 8, NULL, 'Working set', NOW()),
(1, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 3, 80.0, 8, 9, NULL, 'Hard', NOW()),
(1, 4, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 1, 40.0, 10, 8, NULL, 'OHP', NOW()),
(1, 4, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 2, 40.0, 10, 8, NULL, NULL, NOW());

-- Day 2: Pull
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 100.0, 5, 8, NULL, 'Heavy DL', NOW()),
(1, 4, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 2, 120.0, 3, 9, NULL, NULL, NOW()),
(1, 5, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1, 0.0, 10, 8, NULL, 'Bodyweight', NOW());

-- Day 3: Legs
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 7, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1, 100.0, 5, 8, NULL, 'Squat', NOW()),
(1, 7, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 2, 100.0, 5, 8, NULL, NULL, NOW());

-- Day 4: Rest (No records)

-- Day 5: Upper
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, 85.0, 5, 9, NULL, 'Bench PR attempt', NOW());

-- Day 6: Lower
INSERT INTO train_record (user_id, action_id, record_date, set_no, weight, reps, rpe, superset_id, note, created_at) VALUES
(1, 7, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, 110.0, 3, 9, NULL, 'Squat Heavy', NOW());


-- 6. Diet Log (Last 7 Days for Admin)
-- Just some random entries
INSERT INTO diet_log (user_id, food_id, log_date, meal_type, intake_amount, calc_calories, calc_protein, calc_fat, calc_carbs, created_at) VALUES
(1, 3, DATE_SUB(CURDATE(), INTERVAL 0 DAY), 1, 2.0, 140.0, 12.0, 10.0, 1.2, NOW()), -- 2 Eggs breakfast
(1, 5, DATE_SUB(CURDATE(), INTERVAL 0 DAY), 1, 1.0, 389.0, 16.9, 6.9, 66.3, NOW()), -- Oatmeal
(1, 1, DATE_SUB(CURDATE(), INTERVAL 0 DAY), 2, 2.0, 330.0, 62.0, 7.2, 0.0, NOW()), -- 200g Chicken Lunch
(1, 2, DATE_SUB(CURDATE(), INTERVAL 0 DAY), 2, 2.0, 260.0, 5.4, 0.6, 56.0, NOW()); -- 200g Rice

INSERT INTO diet_log (user_id, food_id, log_date, meal_type, intake_amount, calc_calories, calc_protein, calc_fat, calc_carbs, created_at) VALUES
(1, 6, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 4, 1.0, 120.0, 24.0, 1.0, 3.0, NOW()), -- Protein Shake
(1, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 3, 2.0, 330.0, 62.0, 7.2, 0.0, NOW()); -- Chicken Dinner


-- 7. Water Log (Last 7 Days)
INSERT INTO water_log (user_id, log_date, amount_ml, created_at) VALUES
(1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 2500, NOW()),
(1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 3000, NOW()),
(1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 1500, NOW()),
(1, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 2000, NOW()),
(1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 2800, NOW()),
(1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 3200, NOW()),
(1, CURDATE(), 1000, NOW());
