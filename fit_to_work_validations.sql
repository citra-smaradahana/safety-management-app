-- Database Schema untuk Fit To Work Validations
-- Jalankan script ini di Supabase SQL Editor

-- 1. Tabel untuk menyimpan validasi Fit To Work
CREATE TABLE fit_to_work_validations (
    id SERIAL PRIMARY KEY,
    fit_to_work_id UUID REFERENCES fit_to_work(id) ON DELETE CASCADE,
    user_nrp VARCHAR(50) NOT NULL,
    user_nama VARCHAR(255) NOT NULL,
    user_jabatan VARCHAR(100) NOT NULL,
    user_site VARCHAR(100),
    
    -- Status validasi
    status VARCHAR(50) DEFAULT 'Pending Review' CHECK (status IN ('Pending Review', 'Initial Review', 'SHE Validation', 'Completed')),
    
    -- Level 1: Initial Review (Leading Hand/Ast. PJO/PJO)
    level1_reviewer_nama VARCHAR(255),
    level1_reviewer_jabatan VARCHAR(100),
    level1_tindakan_leading_hand TEXT,
    level1_tindakan_she TEXT,
    level1_tindakan_ast_pjo TEXT,
    level1_tindakan_pjo TEXT,
    level1_reviewed_at TIMESTAMP WITH TIME ZONE,
    
    -- Level 2: SHE Validation (hanya untuk jabatan non-PJO)
    level2_reviewer_nama VARCHAR(255),
    level2_reviewer_jabatan VARCHAR(100),
    level2_catatan_keluhan_utama TEXT,
    level2_catatan_gejala TEXT,
    level2_durasi_keluhan VARCHAR(50),
    level2_level_fatigue VARCHAR(20) CHECK (level2_level_fatigue IN ('Ringan', 'Moderat', 'Berat')),
    level2_faktor_penyebab TEXT[], -- Array untuk multiple checkboxes
    level2_hasil_pengecekan TEXT,
    level2_status_rekomendasi VARCHAR(20) CHECK (level2_status_rekomendasi IN ('Fit To Work', 'Not Fit To Work')),
    level2_alasan_rekomendasi TEXT,
    level2_kondisi_kembali_bekerja TEXT,
    level2_tindakan_lanjutan TEXT,
    level2_reviewed_at TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints - PJO bisa langsung selesai, jabatan lain perlu SHE validation
    CONSTRAINT valid_status_flow CHECK (
        (status = 'Pending Review' AND level1_reviewer_nama IS NULL AND level2_reviewer_nama IS NULL) OR
        (status = 'Initial Review' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL) OR
        (status = 'SHE Validation' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NOT NULL) OR
        (status = 'Completed' AND level1_reviewer_nama IS NOT NULL AND (
            (user_jabatan = 'Penanggung Jawab Operasional' AND level2_reviewer_nama IS NULL) OR
            (user_jabatan != 'Penanggung Jawab Operasional' AND level2_reviewer_nama IS NOT NULL)
        ))
    )
);

-- 2. Index untuk performa query
CREATE INDEX idx_fit_to_work_validations_user_nrp ON fit_to_work_validations(user_nrp);
CREATE INDEX idx_fit_to_work_validations_status ON fit_to_work_validations(status);
CREATE INDEX idx_fit_to_work_validations_level1_reviewer ON fit_to_work_validations(level1_reviewer_nama);
CREATE INDEX idx_fit_to_work_validations_level2_reviewer ON fit_to_work_validations(level2_reviewer_nama);
CREATE INDEX idx_fit_to_work_validations_created_at ON fit_to_work_validations(created_at);

-- 3. Function untuk auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 4. Trigger untuk auto-update updated_at
CREATE TRIGGER update_fit_to_work_validations_updated_at 
    BEFORE UPDATE ON fit_to_work_validations 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 5. Function untuk membuat validasi otomatis saat Fit To Work = "Not Fit To Work"
CREATE OR REPLACE FUNCTION create_fit_to_work_validation()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika status berubah menjadi "Not Fit To Work", buat validasi
    IF NEW.status = 'Not Fit To Work' AND (OLD.status IS NULL OR OLD.status != 'Not Fit To Work') THEN
        INSERT INTO fit_to_work_validations (
            fit_to_work_id,
            user_nrp,
            user_nama,
            user_jabatan,
            user_site,
            status
        ) VALUES (
            NEW.id::UUID,  -- Cast to UUID to ensure compatibility
            NEW.nrp,
            NEW.nama,
            NEW.jabatan,
            NEW.site,
            'Pending Review'
        );
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 6. Trigger untuk auto-create validasi
CREATE TRIGGER trigger_create_fit_to_work_validation
    AFTER INSERT OR UPDATE ON fit_to_work
    FOR EACH ROW
    EXECUTE FUNCTION create_fit_to_work_validation();

-- 7. Function untuk mendapatkan reviewer berdasarkan jabatan
CREATE OR REPLACE FUNCTION get_reviewer_by_jabatan(user_jabatan VARCHAR)
RETURNS TABLE(reviewer_jabatan VARCHAR, reviewer_level INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CASE 
            WHEN user_jabatan IN ('Crew', 'Mekanik', 'Quality Controller') THEN 'Leading Hand'
            WHEN user_jabatan = 'Admin' THEN 'SHE'
            WHEN user_jabatan IN ('Blaster', 'Leading Hand') THEN 'Asst. Penanggung Jawab Operasional'
            WHEN user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service') THEN 'Penanggung Jawab Operasional'
            WHEN user_jabatan IN ('Operator MMU', 'Operator Plant') THEN 'Leading Hand'
            ELSE 'SHE' -- Default fallback
        END,
        CASE 
            WHEN user_jabatan IN ('Crew', 'Mekanik', 'Quality Controller') THEN 1
            WHEN user_jabatan = 'Admin' THEN 2
            WHEN user_jabatan IN ('Blaster', 'Leading Hand') THEN 1
            WHEN user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service') THEN 1
            WHEN user_jabatan IN ('Operator MMU', 'Operator Plant') THEN 1
            ELSE 2 -- Default fallback
        END;
END;
$$ language 'plpgsql';

-- 8. Comments untuk dokumentasi
COMMENT ON TABLE fit_to_work_validations IS 'Tabel untuk menyimpan validasi Fit To Work dengan workflow 2-level';
COMMENT ON COLUMN fit_to_work_validations.status IS 'Status validasi: Pending Review -> Initial Review -> SHE Validation -> Completed';
COMMENT ON COLUMN fit_to_work_validations.level1_reviewer_nama IS 'Nama reviewer level 1 (Leading Hand/Ast. PJO)';
COMMENT ON COLUMN fit_to_work_validations.level2_reviewer_nama IS 'Nama reviewer level 2 (SHE)';
COMMENT ON COLUMN fit_to_work_validations.level2_faktor_penyebab IS 'Array faktor penyebab fatigue (checkboxes)';
COMMENT ON COLUMN fit_to_work_validations.level2_status_rekomendasi IS 'Rekomendasi final: Fit To Work atau Not Fit To Work';

-- 9. Row Level Security (RLS) - Optional
-- ALTER TABLE fit_to_work_validations ENABLE ROW LEVEL SECURITY;

-- 10. Sample data untuk testing (optional)
-- INSERT INTO fit_to_work_validations (
--     fit_to_work_id, user_nrp, user_nama, user_jabatan, user_site, status
-- ) VALUES (
--     '00000000-0000-0000-0000-000000000001'::UUID, '12345', 'John Doe', 'Crew', 'Site A', 'Pending Review'
-- ); 