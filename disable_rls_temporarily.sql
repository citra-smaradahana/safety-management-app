-- Temporarily Disable RLS for Testing
-- This will allow all operations without any restrictions

-- 1. Disable RLS on users table
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 2. Verify RLS is disabled
SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE tablename = 'users';

-- 3. Test update without RLS
UPDATE users 
SET jabatan = 'RLS DISABLED TEST ' || now()::text
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7'
RETURNING *;

-- 4. Verify update worked
SELECT 
  id, 
  nama, 
  jabatan, 
  site,
  created_at
FROM users 
WHERE id = '771bac71-49df-41e8-8956-9e0a29f393c7';

-- 5. Re-enable RLS (uncomment when ready)
-- ALTER TABLE users ENABLE ROW LEVEL SECURITY; 