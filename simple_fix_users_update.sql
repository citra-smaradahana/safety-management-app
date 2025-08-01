-- Simple Fix untuk Update Users
-- Jalankan di Supabase SQL Editor

-- 1. Disable RLS sementara untuk testing
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 2. Test update manual
UPDATE users 
SET nama = nama 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 3. Verifikasi update berhasil
SELECT id, nama, nrp, email, jabatan, site, role 
FROM users 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 4. Jika berhasil, buat RLS policy yang sederhana
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 5. Buat policy yang sangat permissive untuk development
CREATE POLICY "Allow all operations for authenticated users" ON users
FOR ALL USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- 6. Test lagi setelah RLS enabled
UPDATE users 
SET nama = nama 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 7. Final verification
SELECT id, nama, nrp, email, jabatan, site, role 
FROM users 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927'; 