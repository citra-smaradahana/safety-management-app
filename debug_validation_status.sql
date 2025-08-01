-- Debug Status Validasi Fit To Work
-- Jalankan script ini di Supabase SQL Editor untuk melihat status saat ini

-- 1. Cek semua validasi untuk user SHERQ Officer di site BSIB
SELECT 
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    level1_reviewed_at,
    level2_reviewed_at,
    created_at
FROM fit_to_work_validations
WHERE user_jabatan = 'SHERQ Officer'
  AND user_site = 'BSIB'
ORDER BY created_at DESC;

-- 2. Cek semua validasi yang bisa dilihat PJO (Asst. PJO, SHERQ Officer, Technical Service)
SELECT 
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

-- 3. Cek jumlah validasi per status untuk site BSIB
SELECT 
    status,
    COUNT(*) as count
FROM fit_to_work_validations
WHERE user_site = 'BSIB'
GROUP BY status
ORDER BY status;

-- 4. Cek validasi yang seharusnya tidak muncul untuk PJO (status bukan Pending Review)
SELECT 
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    created_at
FROM fit_to_work_validations
WHERE user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service')
  AND user_site = 'BSIB'
  AND status != 'Pending Review'
ORDER BY created_at DESC; 