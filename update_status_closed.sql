-- Update Status Closed untuk PJO Validation
-- Jalankan script ini di Supabase SQL Editor

-- 1. Drop constraint lama
ALTER TABLE fit_to_work_validations 
DROP CONSTRAINT IF EXISTS valid_status_flow;

-- 2. Update status check constraint untuk menambahkan "Closed"
ALTER TABLE fit_to_work_validations 
ALTER COLUMN status TYPE VARCHAR(50);

-- 3. Buat constraint baru yang mengakomodasi status "Closed"
ALTER TABLE fit_to_work_validations 
ADD CONSTRAINT valid_status_flow CHECK (
    (status = 'Pending Review' AND level1_reviewer_nama IS NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'Initial Review' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'SHE Validation' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'Completed' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NOT NULL) OR
    (status = 'Closed' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL AND user_jabatan = 'Penanggung Jawab Operasional')
);

-- 4. Update data yang sudah ada jika diperlukan
-- Jika ada validasi dengan status "Completed" yang di-review PJO, ubah ke "Closed"
UPDATE fit_to_work_validations 
SET status = 'Closed' 
WHERE status = 'Completed' 
  AND level1_reviewer_jabatan = 'Penanggung Jawab Operasional'
  AND level2_reviewer_nama IS NULL;

-- 5. Cek hasil update
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

-- 6. Cek jumlah validasi per status
SELECT 
    status,
    COUNT(*) as count
FROM fit_to_work_validations
GROUP BY status
ORDER BY status; 