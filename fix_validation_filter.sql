-- Fix Validasi Filter untuk PJO
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek semua validasi yang ada di BSIB
SELECT 
    'All Validations in BSIB' as info,
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    created_at
FROM fit_to_work_validations
WHERE user_site = 'BSIB'
ORDER BY created_at DESC;

-- 2. Cek validasi yang seharusnya dilihat PJO (Asst. PJO, SHERQ Officer, Technical Service)
SELECT 
    'Validasi untuk PJO (semua status)' as info,
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    created_at
FROM fit_to_work_validations
WHERE user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service')
  AND user_site = 'BSIB'
ORDER BY created_at DESC;

-- 3. Cek validasi yang seharusnya dilihat PJO (hanya Pending Review)
SELECT 
    'Validasi untuk PJO (Pending Review only)' as info,
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    created_at
FROM fit_to_work_validations
WHERE user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service')
  AND user_site = 'BSIB'
  AND status = 'Pending Review'
ORDER BY created_at DESC;

-- 4. Update semua validasi yang sudah di-review menjadi status yang benar
UPDATE fit_to_work_validations 
SET status = 'Closed' 
WHERE status IN ('Completed', 'Initial Review')
  AND level1_reviewer_jabatan = 'Penanggung Jawab Operasional'
  AND level2_reviewer_nama IS NULL
  AND user_site = 'BSIB';

-- 5. Cek hasil setelah update
SELECT 
    'After Update - Validasi untuk PJO (Pending Review only)' as info,
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    created_at
FROM fit_to_work_validations
WHERE user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service')
  AND user_site = 'BSIB'
  AND status = 'Pending Review'
ORDER BY created_at DESC;

-- 6. Cek semua status yang ada setelah update
SELECT 
    'Final Status Count' as info,
    status,
    COUNT(*) as count
FROM fit_to_work_validations
WHERE user_site = 'BSIB'
GROUP BY status
ORDER BY status; 