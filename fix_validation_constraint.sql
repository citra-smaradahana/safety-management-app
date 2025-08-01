-- Fix Fit To Work Validation Constraint
-- Jalankan script ini di Supabase SQL Editor

-- 1. Drop constraint lama jika ada
ALTER TABLE fit_to_work_validations 
DROP CONSTRAINT IF EXISTS valid_status_flow;

-- 2. Buat constraint baru yang lebih fleksibel
ALTER TABLE fit_to_work_validations 
ADD CONSTRAINT valid_status_flow CHECK (
    (status = 'Pending Review' AND level1_reviewer_nama IS NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'Initial Review' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'SHE Validation' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'Completed' AND level1_reviewer_nama IS NOT NULL AND (
        (user_jabatan = 'Penanggung Jawab Operasional' AND level2_reviewer_nama IS NULL) OR
        (user_jabatan != 'Penanggung Jawab Operasional' AND level2_reviewer_nama IS NOT NULL)
    ))
);

-- 3. Cek struktur tabel
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'fit_to_work_validations'
ORDER BY ordinal_position;

-- 4. Cek data yang ada
SELECT 
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    created_at
FROM fit_to_work_validations
ORDER BY created_at DESC
LIMIT 10;

-- 5. Test insert untuk memastikan constraint berfungsi
-- (Uncomment baris di bawah untuk test, hapus setelah test selesai)
/*
INSERT INTO fit_to_work_validations (
    fit_to_work_id,
    user_nrp,
    user_nama,
    user_jabatan,
    user_site,
    status
) VALUES (
    '00000000-0000-0000-0000-000000000001'::UUID,
    'TEST001',
    'Test User',
    'Crew',
    'BSIB',
    'Pending Review'
);
*/ 