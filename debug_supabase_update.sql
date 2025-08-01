-- Debug Supabase Update Issues
-- Run this in Supabase SQL Editor

-- 1. Check current user permissions
SELECT 
  current_user,
  current_setting('role'),
  current_setting('request.jwt.claims');

-- 2. Check if user exists and can be updated
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7';

-- 3. Check current RLS policies
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'users';

-- 4. Test update directly (run as superuser)
UPDATE users 
SET jabatan = 'DIRECT SQL TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *;

-- 5. Check if update worked
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7';

-- 6. Disable RLS temporarily for testing
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 7. Test update without RLS
UPDATE users 
SET jabatan = 'NO RLS TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *;

-- 8. Re-enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 9. Create simple UPDATE policy
DROP POLICY IF EXISTS "Users can update their own data" ON users;
DROP POLICY IF EXISTS "Admins can update any user" ON users;

CREATE POLICY "Simple update policy" ON users
FOR UPDATE USING (true)
WITH CHECK (true);

-- 10. Test update with new policy
UPDATE users 
SET jabatan = 'NEW POLICY TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *; 