-- Create New Users Policies
-- Run this AFTER running drop_all_users_policies.sql

-- 1. Create simple, working policies
-- Policy 1: SELECT - Allow authenticated users to read all users
CREATE POLICY "users_select_all" ON users
FOR SELECT USING (auth.role() = 'authenticated');

-- Policy 2: INSERT - Allow authenticated users to insert users
CREATE POLICY "users_insert_all" ON users
FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Policy 3: UPDATE - Allow authenticated users to update users
CREATE POLICY "users_update_all" ON users
FOR UPDATE USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Policy 4: DELETE - Allow authenticated users to delete users
CREATE POLICY "users_delete_all" ON users
FOR DELETE USING (auth.role() = 'authenticated');

-- 2. Verify new policies are created
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

-- 3. Test current user permissions
SELECT 
  current_user,
  current_setting('role'),
  current_setting('request.jwt.claims');

-- 4. Test update
UPDATE users 
SET jabatan = 'NEW POLICIES TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *;

-- 5. Verify update worked
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'; 