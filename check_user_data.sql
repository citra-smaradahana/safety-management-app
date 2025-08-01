-- Check User Data untuk Armando Yosephin
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek struktur tabel users
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'users' 
ORDER BY ordinal_position;

-- 2. Cek data user Armando Yosephin
SELECT * FROM users WHERE nama LIKE '%Armando%' OR nama LIKE '%Yosephin%';

-- 3. Cek semua user dengan jabatan Penanggung Jawab Operasional
SELECT id, nama, user, jabatan, role, site FROM users 
WHERE jabatan = 'Penanggung Jawab Operasional';

-- 4. Cek semua jabatan yang ada
SELECT DISTINCT jabatan FROM users ORDER BY jabatan;

-- 5. Cek semua role yang ada
SELECT DISTINCT role FROM users ORDER BY role;

-- 6. Update user Armando Yosephin jika perlu (uncomment jika perlu update)
-- UPDATE users 
-- SET role = 'evaluator', jabatan = 'Penanggung Jawab Operasional'
-- WHERE nama LIKE '%Armando%' OR nama LIKE '%Yosephin%'; 