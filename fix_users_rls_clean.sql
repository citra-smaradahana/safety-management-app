-- Fix Users Table RLS Policies - Clean Approach
-- Run this in Supabase SQL Editor

-- 1. First, let's see what policies exist
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

-- 2. Drop ALL existing policies for users table
-- This will remove any conflicting policies
DROP POLICY IF EXISTS "Users can view their own data" ON users;
DROP POLICY IF EXISTS "Users can update their own data" ON users;
DROP POLICY IF EXISTS "Admins can view all users" ON users;
DROP POLICY IF EXISTS "Admins can update any user" ON users;
DROP POLICY IF EXISTS "Simple update policy" ON users;
DROP POLICY IF EXISTS "Enable read access for all users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON users;
DROP POLICY IF EXISTS "Enable update for users based on email" ON users;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON users;
DROP POLICY IF EXISTS "Allow authenticated users to read all users" ON users;
DROP POLICY IF EXISTS "Allow authenticated users to insert users" ON users;
DROP POLICY IF EXISTS "Allow authenticated users to update users" ON users;
DROP POLICY IF EXISTS "Allow authenticated users to delete users" ON users;
DROP POLICY IF EXISTS "users_select_policy" ON users;
DROP POLICY IF EXISTS "users_insert_policy" ON users;
DROP POLICY IF EXISTS "users_update_policy" ON users;
DROP POLICY IF EXISTS "users_delete_policy" ON users;
DROP POLICY IF EXISTS "users_select_all" ON users;
DROP POLICY IF EXISTS "users_insert_admin" ON users;
DROP POLICY IF EXISTS "users_update_admin" ON users;
DROP POLICY IF EXISTS "users_delete_admin" ON users;
DROP POLICY IF EXISTS "users_select_simple" ON users;
DROP POLICY IF EXISTS "users_insert_simple" ON users;
DROP POLICY IF EXISTS "users_update_simple" ON users;
DROP POLICY IF EXISTS "users_delete_simple" ON users;

-- 3. Verify all policies are dropped
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

-- 4. Create simple, working policies
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

-- 5. Verify new policies are created
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

-- 6. Test current user permissions
SELECT 
  current_user,
  current_setting('role'),
  current_setting('request.jwt.claims');

-- 7. Test update
UPDATE users 
SET jabatan = 'CLEAN RLS TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *;

-- 8. Verify update worked
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'; 