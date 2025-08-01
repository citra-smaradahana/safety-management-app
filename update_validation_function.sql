-- Update Function untuk mendapatkan reviewer berdasarkan jabatan dan site
-- Jalankan script ini di Supabase SQL Editor

-- Update function untuk mendapatkan reviewer berdasarkan jabatan
CREATE OR REPLACE FUNCTION get_reviewer_by_jabatan(user_jabatan VARCHAR)
RETURNS TABLE(reviewer_jabatan VARCHAR, reviewer_level INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CASE 
            WHEN user_jabatan IN ('Crew', 'Mekanik', 'Quality Controller', 'Operator MMU', 'Operator Plant') THEN 'Leading Hand'::VARCHAR
            WHEN user_jabatan = 'Admin' THEN 'SHE'::VARCHAR
            WHEN user_jabatan IN ('Blaster', 'Leading Hand') THEN 'Asst. Penanggung Jawab Operasional'::VARCHAR
            WHEN user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service') THEN 'Penanggung Jawab Operasional'::VARCHAR
            ELSE 'SHE'::VARCHAR -- Default fallback
        END,
        CASE 
            WHEN user_jabatan IN ('Crew', 'Mekanik', 'Quality Controller', 'Operator MMU', 'Operator Plant') THEN 1
            WHEN user_jabatan = 'Admin' THEN 2
            WHEN user_jabatan IN ('Blaster', 'Leading Hand') THEN 1
            WHEN user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service') THEN 1
            ELSE 2 -- Default fallback
        END;
END;
$$ language 'plpgsql';

-- Function untuk mendapatkan reviewer berdasarkan jabatan dan site
CREATE OR REPLACE FUNCTION get_reviewer_by_jabatan_and_site(user_jabatan VARCHAR, user_site VARCHAR)
RETURNS TABLE(reviewer_jabatan VARCHAR, reviewer_level INTEGER, reviewer_site VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        CASE 
            WHEN user_jabatan IN ('Crew', 'Mekanik', 'Quality Controller', 'Operator MMU', 'Operator Plant') THEN 'Leading Hand'::VARCHAR
            WHEN user_jabatan = 'Admin' THEN 'SHE'::VARCHAR
            WHEN user_jabatan IN ('Blaster', 'Leading Hand') THEN 'Asst. Penanggung Jawab Operasional'::VARCHAR
            WHEN user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service') THEN 'Penanggung Jawab Operasional'::VARCHAR
            ELSE 'SHE'::VARCHAR -- Default fallback
        END,
        CASE 
            WHEN user_jabatan IN ('Crew', 'Mekanik', 'Quality Controller', 'Operator MMU', 'Operator Plant') THEN 1
            WHEN user_jabatan = 'Admin' THEN 2
            WHEN user_jabatan IN ('Blaster', 'Leading Hand') THEN 1
            WHEN user_jabatan IN ('Asst. Penanggung Jawab Operasional', 'SHERQ Officer', 'Technical Service') THEN 1
            ELSE 2 -- Default fallback
        END,
        user_site::VARCHAR; -- Reviewer harus dari site yang sama
END;
$$ language 'plpgsql';

-- Test functions
SELECT * FROM get_reviewer_by_jabatan('Crew');
SELECT * FROM get_reviewer_by_jabatan('Leading Hand');
SELECT * FROM get_reviewer_by_jabatan('Asst. Penanggung Jawab Operasional');
SELECT * FROM get_reviewer_by_jabatan('Penanggung Jawab Operasional');
SELECT * FROM get_reviewer_by_jabatan('Operator MMU');
SELECT * FROM get_reviewer_by_jabatan('Operator Plant');

SELECT * FROM get_reviewer_by_jabatan_and_site('Crew', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Leading Hand', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Asst. Penanggung Jawab Operasional', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Penanggung Jawab Operasional', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Operator MMU', 'BSIB');
SELECT * FROM get_reviewer_by_jabatan_and_site('Operator Plant', 'BSIB'); 