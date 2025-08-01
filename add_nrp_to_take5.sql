-- Add nrp column to take_5 table (pelapor_nama already exists)
-- nrp will be populated from logged in user's employee number

-- Check if nrp column already exists
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'take_5' 
AND column_name = 'nrp';

-- Add nrp column only if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'take_5' AND column_name = 'nrp'
    ) THEN
        ALTER TABLE take_5 ADD COLUMN nrp VARCHAR(50);
        RAISE NOTICE 'Column nrp added successfully';
    ELSE
        RAISE NOTICE 'Column nrp already exists';
    END IF;
END $$;

-- Update existing records with empty nrp if needed
UPDATE take_5 
SET nrp = ''
WHERE nrp IS NULL;

-- Add comment for documentation
COMMENT ON COLUMN take_5.nrp IS 'Nomor Registrasi Pegawai pelapor';

-- Verify the final table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'take_5' 
AND column_name IN ('pelapor_nama', 'nrp')
ORDER BY column_name; 