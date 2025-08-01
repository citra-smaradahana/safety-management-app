-- Check User Role untuk Penanggung Jawab Operasional
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek semua user dengan jabatan Penanggung Jawab Operasional
SELECT id, nama, user, jabatan, role, site
FROM users 
WHERE jabatan = 'Penanggung Jawab Operasional'
ORDER BY nama;

-- 2. Update role menjadi evaluator jika belum
UPDATE users 
SET role = 'evaluator'
WHERE jabatan = 'Penanggung Jawab Operasional' 
  AND (role IS NULL OR role != 'evaluator');

-- 3. Cek semua user dengan role evaluator
SELECT id, nama, user, jabatan, role, site
FROM users 
WHERE role = 'evaluator'
ORDER BY jabatan, nama;

-- 4. Cek semua jabatan yang bisa akses validasi
SELECT DISTINCT jabatan, role, COUNT(*) as user_count
FROM users 
WHERE jabatan IN (
  'Leading Hand',
  'Asst. Penanggung Jawab Operasional', 
  'Penanggung Jawab Operasional',
  'SHE',
  'SHERQ Officer'
)
GROUP BY jabatan, role
ORDER BY jabatan; 