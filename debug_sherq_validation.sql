-- Debug SHERQ Officer Validation Issue
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek data Fit To Work yang dibuat oleh SHERQ Officer dengan status "Not Fit To Work"
SELECT id, nama, jabatan, site, status, tanggal, created_at
FROM fit_to_work 
WHERE jabatan = 'SHERQ Officer' 
  AND status = 'Not Fit To Work'
ORDER BY created_at DESC;

-- 2. Cek data validasi yang seharusnya dibuat otomatis
SELECT id, fit_to_work_id, user_nama, user_jabatan, user_site, status, created_at
FROM fit_to_work_validations 
WHERE user_jabatan = 'SHERQ Officer'
ORDER BY created_at DESC;

-- 3. Cek apakah ada validasi untuk SHERQ Officer dengan status Pending Review
SELECT v.id, v.user_nama, v.user_jabatan, v.user_site, v.status, v.created_at,
       ftw.nama as fit_to_work_nama, ftw.site as fit_to_work_site
FROM fit_to_work_validations v
LEFT JOIN fit_to_work ftw ON v.fit_to_work_id = ftw.id
WHERE v.user_jabatan = 'SHERQ Officer'
  AND v.status = 'Pending Review'
ORDER BY v.created_at DESC;

-- 4. Cek semua validasi dengan status Pending Review
SELECT v.id, v.user_nama, v.user_jabatan, v.user_site, v.status, v.created_at,
       ftw.nama as fit_to_work_nama, ftw.site as fit_to_work_site
FROM fit_to_work_validations v
LEFT JOIN fit_to_work ftw ON v.fit_to_work_id = ftw.id
WHERE v.status = 'Pending Review'
ORDER BY v.created_at DESC;

-- 5. Test function untuk SHERQ Officer
SELECT * FROM get_reviewer_by_jabatan('SHERQ Officer');
SELECT * FROM get_reviewer_by_jabatan_and_site('SHERQ Officer', 'BSIB');

-- 6. Cek apakah trigger berfungsi dengan baik
-- Coba insert manual untuk test
-- INSERT INTO fit_to_work_validations (
--     fit_to_work_id, user_nrp, user_nama, user_jabatan, user_site, status
-- ) VALUES (
--     'ID_FIT_TO_WORK_SHERQ', 'NRP_SHERQ', 'Nama SHERQ', 'SHERQ Officer', 'BSIB', 'Pending Review'
-- );

-- 7. Cek struktur tabel fit_to_work_validations
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'fit_to_work_validations' 
ORDER BY ordinal_position; 