-- Debug dan perbaiki masalah update user
-- Periksa data user Eko Adiwibowo yang sedang diupdate
SELECT 
    id,
    nama,
    nrp,
    email,
    jabatan,
    site,
    role,
    foto,
    created_at,
    updated_at
FROM users 
WHERE email = 'eko.adiwibowo@mnkbme.com';

-- Periksa apakah ada constraint atau trigger yang menghalangi update
SELECT 
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'users';

-- Periksa trigger yang ada
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'users';

-- Test update manual untuk user Eko Adiwibowo
-- Ganti ID dengan ID yang benar dari query pertama
UPDATE users 
SET 
    jabatan = 'SHERQ Supervisor',
    site = 'Balikpapan',
    updated_at = NOW()
WHERE email = 'eko.adiwibowo@mnkbme.com'
RETURNING *;

-- Periksa RLS policy yang mungkin menghalangi update
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

-- Hapus dan buat ulang policy yang lebih permisif untuk development
DROP POLICY IF EXISTS "Enable read access for all users" ON users;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON users;
DROP POLICY IF EXISTS "Enable update for users based on email" ON users;
DROP POLICY IF EXISTS "Enable delete for users based on email" ON users;

-- Buat policy yang lebih permisif
CREATE POLICY "Enable all operations for authenticated users" ON users
    FOR ALL USING (auth.role() = 'authenticated');

-- Atau jika ingin lebih spesifik, buat policy terpisah
CREATE POLICY "Enable read access for all users" ON users
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users" ON users
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users" ON users
    FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for authenticated users" ON users
    FOR DELETE USING (auth.role() = 'authenticated');

-- Pastikan RLS enabled
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Test apakah user bisa melakukan update
-- Jalankan sebagai user yang sedang login
UPDATE users 
SET 
    jabatan = 'SHERQ Supervisor',
    site = 'Balikpapan',
    updated_at = NOW()
WHERE email = 'eko.adiwibowo@mnkbme.com'
RETURNING *;

-- Periksa hasil update
SELECT 
    id,
    nama,
    nrp,
    email,
    jabatan,
    site,
    role,
    updated_at
FROM users 
WHERE email = 'eko.adiwibowo@mnkbme.com'; 