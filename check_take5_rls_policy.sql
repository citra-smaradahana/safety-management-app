-- Check current RLS policy for take_5 table
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'take_5';

-- If RLS is enabled but policy is too restrictive, update it
-- Example: Allow insert for authenticated users with new columns
DROP POLICY IF EXISTS "Users can insert take_5" ON take_5;

CREATE POLICY "Users can insert take_5" ON take_5
FOR INSERT 
TO authenticated
WITH CHECK (true);

-- Or if you want to keep existing policy, just ensure it allows the new columns
-- The policy should not restrict pelapor_nama and nrp fields

-- Check table structure after adding columns
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'take_5' 
ORDER BY ordinal_position; 