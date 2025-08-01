-- Fix Users Table RLS Policies untuk Update
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek struktur tabel users
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- 2. Cek RLS policies yang ada
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'users';

-- 3. Drop semua RLS policies yang ada
DROP POLICY IF EXISTS "Enable all operations for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable select for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON users;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON users;

-- 4. Buat RLS policies yang lebih permissive untuk development
-- Policy untuk SELECT - semua user bisa lihat semua data
CREATE POLICY "Enable select for all users" ON users
FOR SELECT USING (true);

-- Policy untuk INSERT - authenticated users bisa insert
CREATE POLICY "Enable insert for authenticated users" ON users
FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Policy untuk UPDATE - authenticated users bisa update semua data
CREATE POLICY "Enable update for authenticated users" ON users
FOR UPDATE USING (auth.role() = 'authenticated')
WITH CHECK (auth.role() = 'authenticated');

-- Policy untuk DELETE - authenticated users bisa delete
CREATE POLICY "Enable delete for authenticated users" ON users
FOR DELETE USING (auth.role() = 'authenticated');

-- 5. Pastikan RLS enabled
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 6. Test manual update untuk user tertentu
-- Ganti 'user_id_here' dengan ID user yang ingin diupdate
UPDATE users 
SET nama = nama 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 7. Verifikasi update berhasil
SELECT id, nama, nrp, email, jabatan, site, role, foto 
FROM users 
WHERE id = 'd443523c-86eb-4758-aa79-ca8586b60927';

-- 8. Cek final RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'users'
ORDER BY policyname; 