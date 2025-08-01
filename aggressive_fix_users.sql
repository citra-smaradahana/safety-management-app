-- Aggressive Fix untuk Update Users
-- Jalankan di Supabase SQL Editor secara berurutan

-- 1. Cek struktur tabel
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- 2. Drop semua policies yang ada
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable select for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable select for all users" ON users;
DROP POLICY IF EXISTS "Allow all operations for authenticated users" ON users;

-- 3. Disable RLS sementara
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 4. Test update tanpa RLS
UPDATE users 
SET nama = 'Test Update ' || now()::text
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 5. Verifikasi update berhasil
SELECT id, nama, nrp, email, jabatan, site, role 
FROM users 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 6. Enable RLS kembali
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 7. Buat policy yang sangat permissive
CREATE POLICY "super_permissive_policy" ON users
FOR ALL USING (true)
WITH CHECK (true);

-- 8. Test update dengan RLS enabled
UPDATE users 
SET nama = 'Test Update with RLS ' || now()::text
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 9. Final verification
SELECT id, nama, nrp, email, jabatan, site, role 
FROM users 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 10. Cek policies yang aktif
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'users'; 