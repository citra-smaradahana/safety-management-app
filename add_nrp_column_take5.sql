-- Add nrp column to take_5 table
ALTER TABLE take_5 
ADD COLUMN nrp VARCHAR(50);

-- Update existing records with empty nrp
UPDATE take_5 
SET nrp = ''
WHERE nrp IS NULL;

-- Add comment for documentation
COMMENT ON COLUMN take_5.nrp IS 'Nomor Registrasi Pegawai pelapor';

-- Verify the column was added
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'take_5' 
AND column_name = 'nrp'; 