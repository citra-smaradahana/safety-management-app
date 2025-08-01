-- Add pelapor_nama and nrp columns to take_5 table
-- pelapor_nama will be populated from logged in user's name
-- nrp will be populated from logged in user's employee number

-- Add pelapor_nama column
ALTER TABLE take_5 
ADD COLUMN pelapor_nama VARCHAR(255);

-- Add nrp column  
ALTER TABLE take_5 
ADD COLUMN nrp VARCHAR(50);

-- Update existing records with default values
-- For existing records, we'll set pelapor_nama to pic (as fallback)
-- and nrp to empty string (will be populated when form is updated)
UPDATE take_5 
SET pelapor_nama = COALESCE(pic, 'Unknown'),
    nrp = ''
WHERE pelapor_nama IS NULL;

-- Add comments for documentation
COMMENT ON COLUMN take_5.pelapor_nama IS 'Nama pelapor yang diambil dari user yang login';
COMMENT ON COLUMN take_5.nrp IS 'Nomor Registrasi Pegawai pelapor';

-- Verify the changes
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'take_5' 
AND column_name IN ('pelapor_nama', 'nrp')
ORDER BY column_name; 