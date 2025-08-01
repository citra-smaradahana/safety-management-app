-- Add updated_at column to fit_to_work table
-- Jalankan script ini di Supabase SQL Editor

-- 1. Cek apakah kolom updated_at sudah ada
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'fit_to_work' 
AND column_name = 'updated_at';

-- 2. Tambahkan kolom updated_at jika belum ada
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'fit_to_work' 
        AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE fit_to_work 
        ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();
        
        RAISE NOTICE 'Column updated_at added to fit_to_work table';
    ELSE
        RAISE NOTICE 'Column updated_at already exists in fit_to_work table';
    END IF;
END $$;

-- 3. Buat trigger untuk auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 4. Drop trigger jika sudah ada
DROP TRIGGER IF EXISTS update_fit_to_work_updated_at ON fit_to_work;

-- 5. Buat trigger baru
CREATE TRIGGER update_fit_to_work_updated_at
    BEFORE UPDATE ON fit_to_work
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 6. Test update dengan kolom updated_at
UPDATE fit_to_work 
SET status = 'Fit To Work'
WHERE id = '74425fee-ce77-4030-ae9c-4d5e4f682426';

-- 7. Cek hasil
SELECT 
    'Test Update with updated_at' as info,
    id,
    nrp,
    nama,
    status,
    created_at,
    updated_at
FROM fit_to_work 
WHERE id = '74425fee-ce77-4030-ae9c-4d5e4f682426'; 