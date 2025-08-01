-- Update Logika Validasi Fit To Work
-- Jalankan script ini di Supabase SQL Editor

-- 1. Drop constraint lama
ALTER TABLE fit_to_work_validations 
DROP CONSTRAINT IF EXISTS valid_status_flow;

-- 2. Tambah constraint baru yang mengakomodasi PJO langsung selesai
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

-- 3. Update data yang sudah ada jika diperlukan
-- Jika ada validasi dengan status 'Initial Review' yang belum di-review SHE, ubah ke 'SHE Validation'
UPDATE fit_to_work_validations 
SET status = 'SHE Validation' 
WHERE status = 'Initial Review' 
  AND user_jabatan != 'Penanggung Jawab Operasional'
  AND level2_reviewer_nama IS NULL;

-- 4. Jika ada validasi yang sudah di-review PJO tapi status masih 'Initial Review', ubah ke 'Completed'
UPDATE fit_to_work_validations 
SET status = 'Completed' 
WHERE status = 'Initial Review' 
  AND level1_reviewer_jabatan = 'Penanggung Jawab Operasional'
  AND user_jabatan = 'Penanggung Jawab Operasional';

-- 5. Cek hasil update
SELECT 
    id,
    user_jabatan,
    status,
    level1_reviewer_jabatan,
    level2_reviewer_jabatan,
    created_at
FROM fit_to_work_validations 
ORDER BY created_at DESC; 