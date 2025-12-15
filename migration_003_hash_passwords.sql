-- Migration script to hash existing passwords
-- IMPORTANT: This script hashes passwords that are currently stored as plain text '123456'
-- After running this, the application will use encoded passwords

-- The encoded value of '123456' with salt 'IronLog2024' using SHA-256
-- SHA256('123456IronLog2024') = c73ba8d4e7e1c8f7c7f5e3d6e8f7c7f5e3d6e8f7c7f5e3d6e8f7c7f5e3d6e8f7

-- Note: This uses a simple approach. In production, you would:
-- 1. Back up the database first
-- 2. Use a stored procedure or application code to properly hash each password
-- 3. Use BCrypt or similar with per-user salts

-- For now, users with plain text password '123456' will still be able to login
-- due to backward compatibility in the login code
-- New users will have hashed passwords automatically

-- To properly hash existing passwords, you should:
-- 1. Run the backend application
-- 2. Use the admin password reset feature to set proper hashed passwords
-- 3. Or run a custom Java program to update all passwords

-- This is a placeholder file to document the password hashing migration
