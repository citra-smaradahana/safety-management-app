-- Debug Database State
-- Jalankan script ini di Supabase SQL Editor untuk debugging

-- 1. Check if tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('take_5', 'fit_to_work', 'fit_to_work_validations', 'users');

-- 2. Check take_5 table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'take_5' 
ORDER BY ordinal_position;

-- 3. Check fit_to_work_validations table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'fit_to_work_validations' 
ORDER BY ordinal_position;

-- 4. Check sample data in take_5
SELECT id, nama, detail_lokasi, aman, status, created_at
FROM take_5 
ORDER BY created_at DESC 
LIMIT 5;

-- 5. Check sample data in fit_to_work_validations
SELECT id, user_nama, user_jabatan, user_site, status, 
       level1_reviewer_nama, level1_reviewer_jabatan,
       level2_reviewer_nama, level2_reviewer_jabatan
FROM fit_to_work_validations 
ORDER BY created_at DESC 
LIMIT 5;

-- 6. Check constraints on fit_to_work_validations
SELECT conname, contype, pg_get_constraintdef(oid) as definition
FROM pg_constraint 
WHERE conrelid = 'fit_to_work_validations'::regclass;

-- 7. Check if there are any validation errors
SELECT * FROM fit_to_work_validations 
WHERE status = 'Initial Review' 
AND level1_reviewer_nama IS NULL;

-- 8. Check if there are any validation errors
SELECT * FROM fit_to_work_validations 
WHERE status = 'Completed' 
AND level2_reviewer_nama IS NULL; 