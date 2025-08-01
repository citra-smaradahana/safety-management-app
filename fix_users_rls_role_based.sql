-- Fix Users Table RLS Policies - Role-Based Approach
-- Run this in Supabase SQL Editor

-- 1. Check current policies
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

-- 2. Drop all existing policies
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

-- 3. Create role-based RLS policies

-- Policy 1: SELECT - Allow users to read all users (for user management)
CREATE POLICY "users_select_all" ON users
FOR SELECT USING (
  auth.role() = 'authenticated' AND 
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = auth.uid() 
    AND users.role IN ('admin', 'evaluator')
  )
);

-- Policy 2: INSERT - Allow admins to insert users
CREATE POLICY "users_insert_admin" ON users
FOR INSERT WITH CHECK (
  auth.role() = 'authenticated' AND 
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = auth.uid() 
    AND users.role = 'admin'
  )
);

-- Policy 3: UPDATE - Allow admins to update any user
CREATE POLICY "users_update_admin" ON users
FOR UPDATE USING (
  auth.role() = 'authenticated' AND 
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = auth.uid() 
    AND users.role = 'admin'
  )
)
WITH CHECK (
  auth.role() = 'authenticated' AND 
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = auth.uid() 
    AND users.role = 'admin'
  )
);

-- Policy 4: DELETE - Allow admins to delete users
CREATE POLICY "users_delete_admin" ON users
FOR DELETE USING (
  auth.role() = 'authenticated' AND 
  EXISTS (
    SELECT 1 FROM users 
    WHERE users.id = auth.uid() 
    AND users.role = 'admin'
  )
);

-- 4. Alternative: Simple policies for testing (less secure but easier to debug)
-- Uncomment these if role-based policies don't work

/*
-- Simple SELECT policy
CREATE POLICY "users_select_simple" ON users
FOR SELECT USING (auth.role() = 'authenticated');

-- Simple INSERT policy  
CREATE POLICY "users_insert_simple" ON users
FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Simple UPDATE policy
CREATE POLICY "users_update_simple" ON users
FOR UPDATE USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Simple DELETE policy
CREATE POLICY "users_delete_simple" ON users
FOR DELETE USING (auth.role() = 'authenticated');
*/

-- 5. Verify policies
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

-- 6. Test current user
SELECT 
  current_user,
  current_setting('role'),
  current_setting('request.jwt.claims');

-- 7. Test update
UPDATE users 
SET jabatan = 'ROLE BASED TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *;

-- 8. Verify update
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  role,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'; 