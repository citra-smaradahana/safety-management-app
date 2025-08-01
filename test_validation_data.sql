-- Test Script untuk Insert Sample Data
-- Jalankan script ini setelah fit_to_work_validations.sql berhasil

-- 1. Insert sample Fit To Work data (jika belum ada)
INSERT INTO fit_to_work (
    id,
    nama,
    nrp,
    jabatan,
    site,
    tanggal,
    q1,
    q2,
    q3,
    q4,
    total_jam_tidur,
    kualitas_tidur,
    waktu_tidur,
    status,
    catatan
) VALUES (
    gen_random_uuid(),
    'John Doe',
    '12345',
    'Crew',
    'Site A',
    CURRENT_DATE,
    'Ya',
    'Tidak',
    'Ya',
    'Tidak',
    6,
    'Kurang Baik',
    '23:00',
    'Not Fit To Work',
    'Merasa lelah dan kurang konsentrasi'
) ON CONFLICT DO NOTHING;

-- 2. Insert sample validation data
-- Note: fit_to_work_id akan otomatis terisi oleh trigger
-- Tapi kita bisa insert manual untuk testing

-- Ambil ID dari Fit To Work yang baru dibuat
WITH ftw_id AS (
    SELECT id FROM fit_to_work 
    WHERE nama = 'John Doe' AND nrp = '12345' 
    ORDER BY created_at DESC 
    LIMIT 1
)
INSERT INTO fit_to_work_validations (
    fit_to_work_id,
    user_nrp,
    user_nama,
    user_jabatan,
    user_site,
    status
) 
SELECT 
    id,
    '12345',
    'John Doe',
    'Crew',
    'Site A',
    'Pending Review'
FROM ftw_id
ON CONFLICT DO NOTHING;

-- 3. Insert sample data untuk SHE (jika ada user SHE)
INSERT INTO fit_to_work_validations (
    fit_to_work_id,
    user_nrp,
    user_nama,
    user_jabatan,
    user_site,
    status,
    level1_reviewer_nama,
    level1_reviewer_jabatan,
    level1_tindakan_leading_hand,
    level1_reviewed_at
) 
SELECT 
    id,
    '12345',
    'John Doe',
    'Crew',
    'Site A',
    'Initial Review',
    'Leading Hand Test',
    'Leading Hand',
    'Memberikan istirahat dan monitoring kondisi',
    NOW()
FROM fit_to_work 
WHERE nama = 'John Doe' AND nrp = '12345'
ORDER BY created_at DESC 
LIMIT 1
ON CONFLICT DO NOTHING; 