-- Check Trigger Function untuk Fit To Work Validation
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek apakah trigger sudah ada
SELECT 
    trigger_name,
    event_manipulation,
    action_timing,
    action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'fit_to_work'
ORDER BY trigger_name;

-- 2. Cek apakah function create_fit_to_work_validation ada
SELECT 
    routine_name,
    routine_type,
    data_type
FROM information_schema.routines 
WHERE routine_name = 'create_fit_to_work_validation';

-- 3. Test trigger dengan insert manual (uncomment untuk test)
-- INSERT INTO fit_to_work (
--     id, nama, jabatan, site, status, tanggal, nrp, user, email, password, role
-- ) VALUES (
--     gen_random_uuid(), 'Test SHERQ', 'SHERQ Officer', 'BSIB', 'Not Fit To Work', 
--     CURRENT_DATE, '12345', 'testsherq', 'test@sherq.com', 'password', 'user'
-- );

-- 4. Cek apakah ada validasi yang dibuat otomatis
SELECT 
    v.id,
    v.fit_to_work_id,
    v.user_nama,
    v.user_jabatan,
    v.user_site,
    v.status,
    v.created_at,
    ftw.nama as fit_to_work_nama,
    ftw.jabatan as fit_to_work_jabatan,
    ftw.site as fit_to_work_site
FROM fit_to_work_validations v
LEFT JOIN fit_to_work ftw ON v.fit_to_work_id = ftw.id
WHERE v.user_jabatan = 'SHERQ Officer'
ORDER BY v.created_at DESC;

-- 5. Cek semua Fit To Work dengan status "Not Fit To Work" yang belum ada validasi
SELECT 
    ftw.id,
    ftw.nama,
    ftw.jabatan,
    ftw.site,
    ftw.status,
    ftw.tanggal,
    ftw.created_at,
    CASE 
        WHEN v.id IS NULL THEN 'MISSING VALIDATION'
        ELSE 'HAS VALIDATION'
    END as validation_status
FROM fit_to_work ftw
LEFT JOIN fit_to_work_validations v ON ftw.id = v.fit_to_work_id
WHERE ftw.status = 'Not Fit To Work'
ORDER BY ftw.created_at DESC;

-- 6. Recreate trigger jika perlu
-- DROP TRIGGER IF EXISTS trigger_create_fit_to_work_validation ON fit_to_work;
-- CREATE TRIGGER trigger_create_fit_to_work_validation
--     AFTER INSERT OR UPDATE ON fit_to_work
--     FOR EACH ROW
--     EXECUTE FUNCTION create_fit_to_work_validation();

-- 7. Manual insert validation untuk SHERQ Officer yang sudah ada (uncomment jika perlu)
-- INSERT INTO fit_to_work_validations (
--     fit_to_work_id, user_nrp, user_nama, user_jabatan, user_site, status
-- ) 
-- SELECT 
--     ftw.id,
--     ftw.nrp,
--     ftw.nama,
--     ftw.jabatan,
--     ftw.site,
--     'Pending Review'
-- FROM fit_to_work ftw
-- LEFT JOIN fit_to_work_validations v ON ftw.id = v.fit_to_work_id
-- WHERE ftw.status = 'Not Fit To Work'
--   AND ftw.jabatan = 'SHERQ Officer'
--   AND v.id IS NULL; 