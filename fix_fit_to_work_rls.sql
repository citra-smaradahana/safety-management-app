-- Fix RLS Policies untuk Fit To Work Update
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek RLS status pada tabel fit_to_work
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'fit_to_work';

-- 2. Cek existing policies
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
WHERE tablename = 'fit_to_work';

-- 3. Drop existing policies jika ada yang menghalangi update
DROP POLICY IF EXISTS "Enable update for authenticated users" ON fit_to_work;
DROP POLICY IF EXISTS "Enable update for validators" ON fit_to_work;

-- 4. Buat policy baru untuk update
CREATE POLICY "Enable update for validators" ON fit_to_work
FOR UPDATE USING (
    auth.role() = 'authenticated'
)
WITH CHECK (
    auth.role() = 'authenticated'
);

-- 5. Atau jika ingin lebih spesifik untuk validator
CREATE POLICY "Enable update for PJO and SHE" ON fit_to_work
FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM users 
        WHERE users.user = auth.email() 
        AND users.jabatan IN ('Penanggung Jawab Operasional', 'SHE')
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM users 
        WHERE users.user = auth.email() 
        AND users.jabatan IN ('Penanggung Jawab Operasional', 'SHE')
    )
);

-- 6. Test update dengan policy baru (tanpa updated_at)
UPDATE fit_to_work 
SET status = 'Fit To Work'
WHERE id = '74425fee-ce77-4030-ae9c-4d5e4f682426';

-- 7. Cek hasil
SELECT 
    'Test Update Result' as info,
    id,
    nrp,
    nama,
    status,
    created_at
FROM fit_to_work 
WHERE id = '74425fee-ce77-4030-ae9c-4d5e4f682426'; 