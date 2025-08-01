-- Clean Fix untuk Users RLS Policies
-- Jalankan di Supabase SQL Editor secara berurutan

-- 1. Drop semua policies yang ada (bersihkan semua)
DROP POLICY IF EXISTS "Allow anon insert users" ON users;
DROP POLICY IF EXISTS "Allow anon select users" ON users;
DROP POLICY IF EXISTS "Enable read access for all users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON users;
DROP POLICY IF EXISTS "Enable update for users based on email" ON users;
DROP POLICY IF EXISTS "Enable delete for users based on email" ON users;
DROP POLICY IF EXISTS "super_permissive_policy" ON users;
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable select for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable select for all users" ON users;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON users;

-- 2. Disable RLS sementara untuk testing
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 3. Test update tanpa RLS
UPDATE users 
SET nama = 'Test Update Clean ' || now()::text
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 4. Verifikasi update berhasil
SELECT id, nama, nrp, email, jabatan, site, role 
FROM users 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 5. Enable RLS kembali
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 6. Buat policy yang sederhana dan jelas
-- Policy untuk SELECT - semua user bisa lihat semua data
CREATE POLICY "users_select_policy" ON users
FOR SELECT USING (true);

-- Policy untuk INSERT - authenticated users bisa insert
CREATE POLICY "users_insert_policy" ON users
FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Policy untuk UPDATE - authenticated users bisa update semua data
CREATE POLICY "users_update_policy" ON users
FOR UPDATE USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Policy untuk DELETE - authenticated users bisa delete
CREATE POLICY "users_delete_policy" ON users
FOR DELETE USING (auth.role() = 'authenticated');

-- 7. Test update dengan RLS enabled
UPDATE users 
SET nama = 'Test Update with Clean RLS ' || now()::text
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 8. Final verification
SELECT id, nama, nrp, email, jabatan, site, role 
FROM users 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 9. Cek policies yang aktif (seharusnya hanya 4 policies)
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'users'
ORDER BY policyname; 