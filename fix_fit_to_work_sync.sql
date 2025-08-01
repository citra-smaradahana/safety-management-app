-- Fix Sinkronisasi Fit To Work dan Fit To Work Validations
-- Jalankan script ini di Supabase SQL Editor

-- 1. Drop trigger lama jika ada
DROP TRIGGER IF EXISTS trigger_create_fit_to_work_validation ON fit_to_work;

-- 2. Drop function lama jika ada
DROP FUNCTION IF EXISTS create_fit_to_work_validation();

-- 3. Buat function baru yang lebih robust
CREATE OR REPLACE FUNCTION create_fit_to_work_validation()
RETURNS TRIGGER AS $$
BEGIN
    -- Debug log
    RAISE NOTICE 'Trigger activated: status=%', NEW.status;
    
    -- Jika status berubah menjadi "Not Fit To Work", buat validasi
    IF NEW.status = 'Not Fit To Work' AND (OLD.status IS NULL OR OLD.status != 'Not Fit To Work') THEN
        RAISE NOTICE 'Creating validation for user: %', NEW.nama;
        
        -- Cek apakah validasi sudah ada untuk fit_to_work_id ini
        IF NOT EXISTS (
            SELECT 1 FROM fit_to_work_validations 
            WHERE fit_to_work_id = NEW.id
        ) THEN
            INSERT INTO fit_to_work_validations (
                fit_to_work_id,
                user_nrp,
                user_nama,
                user_jabatan,
                user_site,
                status
            ) VALUES (
                NEW.id,
                NEW.nrp,
                NEW.nama,
                NEW.jabatan,
                NEW.site,
                'Pending Review'
            );
            
            RAISE NOTICE 'Validation created successfully for fit_to_work_id: %', NEW.id;
        ELSE
            RAISE NOTICE 'Validation already exists for fit_to_work_id: %', NEW.id;
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 4. Buat trigger baru
CREATE TRIGGER trigger_create_fit_to_work_validation
    AFTER INSERT OR UPDATE ON fit_to_work
    FOR EACH ROW
    EXECUTE FUNCTION create_fit_to_work_validation();

-- 5. Function untuk update status fit_to_work berdasarkan validasi
CREATE OR REPLACE FUNCTION update_fit_to_work_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika validasi selesai (Completed), update status fit_to_work
    IF NEW.status = 'Completed' AND (OLD.status IS NULL OR OLD.status != 'Completed') THEN
        UPDATE fit_to_work 
        SET status = 'Validated'
        WHERE id = NEW.fit_to_work_id;
        
        RAISE NOTICE 'Updated fit_to_work status to Validated for id: %', NEW.fit_to_work_id;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 6. Trigger untuk update fit_to_work status
DROP TRIGGER IF EXISTS trigger_update_fit_to_work_status ON fit_to_work_validations;
CREATE TRIGGER trigger_update_fit_to_work_status
    AFTER UPDATE ON fit_to_work_validations
    FOR EACH ROW
    EXECUTE FUNCTION update_fit_to_work_status();

-- 7. Cek data yang sudah ada dan buat validasi jika belum ada
INSERT INTO fit_to_work_validations (
    fit_to_work_id,
    user_nrp,
    user_nama,
    user_jabatan,
    user_site,
    status
)
SELECT 
    ftw.id,
    ftw.nrp,
    ftw.nama,
    ftw.jabatan,
    ftw.site,
    'Pending Review'
FROM fit_to_work ftw
WHERE ftw.status = 'Not Fit To Work'
  AND NOT EXISTS (
      SELECT 1 FROM fit_to_work_validations ftwv 
      WHERE ftwv.fit_to_work_id = ftw.id
  );

-- 8. Cek hasil
SELECT 
    'fit_to_work' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN status = 'Not Fit To Work' THEN 1 END) as not_fit_to_work_count
FROM fit_to_work
UNION ALL
SELECT 
    'fit_to_work_validations' as table_name,
    COUNT(*) as total_records,
    COUNT(CASE WHEN status = 'Pending Review' THEN 1 END) as pending_review_count
FROM fit_to_work_validations;

-- 9. Cek sinkronisasi
SELECT 
    ftw.id as fit_to_work_id,
    ftw.nama,
    ftw.status as fit_to_work_status,
    ftwv.status as validation_status,
    CASE 
        WHEN ftwv.id IS NULL AND ftw.status = 'Not Fit To Work' THEN 'MISSING VALIDATION'
        WHEN ftwv.id IS NOT NULL AND ftw.status != 'Not Fit To Work' THEN 'EXTRA VALIDATION'
        ELSE 'SYNCED'
    END as sync_status
FROM fit_to_work ftw
LEFT JOIN fit_to_work_validations ftwv ON ftw.id = ftwv.fit_to_work_id
WHERE ftw.status = 'Not Fit To Work' OR ftwv.id IS NOT NULL
ORDER BY ftw.created_at DESC; 