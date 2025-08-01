-- Fix Users Table RLS Policies - Correct Approach
-- Run this in Supabase SQL Editor

-- 1. First, let's see what we're working with
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

-- 2. Drop all existing policies to start clean
DROP POLICY IF EXISTS "Users can view their own data" ON users;
DROP POLICY IF EXISTS "Users can update their own data" ON users;
DROP POLICY IF EXISTS "Admins can view all users" ON users;
DROP POLICY IF EXISTS "Admins can update any user" ON users;
DROP POLICY IF EXISTS "Simple update policy" ON users;
DROP POLICY IF EXISTS "Enable read access for all users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON users;
DROP POLICY IF EXISTS "Enable update for users based on email" ON users;
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON users;

-- 3. Check current user and role
SELECT 
  current_user,
  current_setting('role'),
  current_setting('request.jwt.claims');

-- 4. Create proper RLS policies for users table

-- Policy 1: SELECT - Allow authenticated users to read all users
CREATE POLICY "Allow authenticated users to read all users" ON users
FOR SELECT USING (auth.role() = 'authenticated');

-- Policy 2: INSERT - Allow authenticated users to insert new users
CREATE POLICY "Allow authenticated users to insert users" ON users
FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Policy 3: UPDATE - Allow authenticated users to update any user
CREATE POLICY "Allow authenticated users to update users" ON users
FOR UPDATE USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Policy 4: DELETE - Allow authenticated users to delete any user
CREATE POLICY "Allow authenticated users to delete users" ON users
FOR DELETE USING (auth.role() = 'authenticated');

-- 5. Verify policies were created
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

-- 6. Test the policies by checking current user data
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7';

-- 7. Test update with new policies
UPDATE users 
SET jabatan = 'RLS FIXED TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *;

-- 8. Verify the update worked
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7';

-- 9. If still not working, try with service role (temporary)
-- Note: This is for testing only, remove in production
-- UPDATE users 
-- SET jabatan = 'SERVICE ROLE TEST ' || now()::text
-- WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
-- RETURNING *; 