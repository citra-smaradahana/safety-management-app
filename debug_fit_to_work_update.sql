-- Debug dan Fix Update Fit To Work Status
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek struktur tabel fit_to_work
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'fit_to_work' 
ORDER BY ordinal_position;

-- 2. Cek data Fit To Work yang terkait dengan validasi
SELECT 
    'Fit To Work Data' as info,
    ftw.id,
    ftw.nrp,
    ftw.nama,
    ftw.status,
    ftw.created_at
FROM fit_to_work ftw
INNER JOIN fit_to_work_validations ftwv ON ftw.id = ftwv.fit_to_work_id
WHERE ftwv.id = 2; -- ID validasi yang sedang diproses

-- 3. Cek apakah ada trigger atau constraint yang menghalangi update
SELECT 
    trigger_name,
    event_manipulation,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'fit_to_work';

-- 4. Test update manual untuk memastikan tidak ada constraint (tanpa updated_at)
UPDATE fit_to_work 
SET status = 'Fit To Work'
WHERE id = '74425fee-ce77-4030-ae9c-4d5e4f682426';

-- 5. Cek hasil update
SELECT 
    'After Update' as info,
    id,
    nrp,
    nama,
    status,
    created_at
FROM fit_to_work 
WHERE id = '74425fee-ce77-4030-ae9c-4d5e4f682426';

-- 6. Cek RLS (Row Level Security) policies
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