-- Test Site-Based Validation
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek data user dengan site yang sama
SELECT id, nama, user, jabatan, role, site 
FROM users 
WHERE site = 'BSIB' 
ORDER BY jabatan, nama;

-- 2. Cek fit_to_work_validations yang ada
SELECT id, user_nama, user_jabatan, user_site, status, created_at
FROM fit_to_work_validations 
ORDER BY created_at DESC 
LIMIT 10;

-- 3. Test function dengan site
SELECT * FROM get_reviewer_by_jabatan_and_site('Crew', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Leading Hand', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Asst. Penanggung Jawab Operasional', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Penanggung Jawab Operasional', 'BSIB');

-- 4. Cek validasi yang bisa diakses oleh Penanggung Jawab Operasional di BSIB
SELECT v.id, v.user_nama, v.user_jabatan, v.user_site, v.status, v.created_at
FROM fit_to_work_validations v
WHERE v.status = 'Pending Review'
  AND v.user_site = 'BSIB'
  AND v.user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service')
ORDER BY v.created_at DESC;

-- 5. Cek validasi yang bisa diakses oleh Leading Hand di BSIB
SELECT v.id, v.user_nama, v.user_jabatan, v.user_site, v.status, v.created_at
FROM fit_to_work_validations v
WHERE v.status = 'Pending Review'
  AND v.user_site = 'BSIB'
  AND v.user_jabatan IN ('Crew', 'Mekanik', 'Quality Controller')
ORDER BY v.created_at DESC; 