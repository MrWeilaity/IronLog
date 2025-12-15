-- Migration to add simple workout logging fields to train_record table
-- This adds support for duration, exercise_type, and notes columns

-- Add new columns to train_record table
-- action_id is made nullable to support simple workout logging where users
-- log general exercises (like "running" or "swimming") without selecting a specific action from the exercise library
ALTER TABLE train_record
    MODIFY COLUMN action_id BIGINT NULL COMMENT 'Made nullable to support simple workout logging',
    MODIFY COLUMN set_no INT NULL,
    MODIFY COLUMN weight DECIMAL(10, 2) NULL,
    MODIFY COLUMN reps INT NULL,
    ADD COLUMN IF NOT EXISTS duration INT COMMENT 'Duration in minutes for simple workout logging',
    ADD COLUMN IF NOT EXISTS exercise_type VARCHAR(100) COMMENT 'Type of exercise for simple workout logging',
    ADD COLUMN IF NOT EXISTS notes TEXT COMMENT 'Additional notes for simple workout logging';

-- Add index for better query performance
CREATE INDEX IF NOT EXISTS idx_train_record_date ON train_record(record_date);
CREATE INDEX IF NOT EXISTS idx_train_record_user_date ON train_record(user_id, record_date);
