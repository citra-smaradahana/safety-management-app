-- Fix Validasi Display untuk PJO
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek status validasi yang ada saat ini
SELECT 
    'Current Status Count' as info,
    status,
    COUNT(*) as count
FROM fit_to_work_validations
WHERE user_site = 'BSIB'
GROUP BY status
ORDER BY status;

-- 2. Update validasi yang sudah di-review PJO menjadi status "Closed"
UPDATE fit_to_work_validations 
SET status = 'Closed' 
WHERE status = 'Completed' 
  AND level1_reviewer_jabatan = 'Penanggung Jawab Operasional'
  AND level2_reviewer_nama IS NULL
  AND user_site = 'BSIB';

-- 3. Update validasi yang sudah di-review PJO menjadi status "Closed" (jika masih ada yang "Initial Review")
UPDATE fit_to_work_validations 
SET status = 'Closed' 
WHERE status = 'Initial Review' 
  AND level1_reviewer_jabatan = 'Penanggung Jawab Operasional'
  AND level2_reviewer_nama IS NULL
  AND user_site = 'BSIB';

-- 4. Cek hasil setelah update
SELECT 
    'After Update Status Count' as info,
    status,
    COUNT(*) as count
FROM fit_to_work_validations
WHERE user_site = 'BSIB'
GROUP BY status
ORDER BY status;

-- 5. Cek validasi yang seharusnya dilihat PJO (hanya Pending Review)
SELECT 
    'Validasi untuk PJO (Pending Review only)' as info,
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    created_at
FROM fit_to_work_validations
WHERE user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service')
  AND user_site = 'BSIB'
  AND status = 'Pending Review'
ORDER BY created_at DESC;

-- 6. Cek validasi yang tidak seharusnya dilihat PJO
SELECT 
    'Validasi yang TIDAK seharusnya dilihat PJO' as info,
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