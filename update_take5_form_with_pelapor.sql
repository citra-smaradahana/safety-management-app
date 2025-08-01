-- Update Take 5 form submission to include pelapor_nama and nrp
-- This should be implemented in the Take 5 form component

/*
PSEUDO CODE untuk update form Take 5:

1. Saat user login, ambil data user:
   - user.nama (untuk pelapor_nama)
   - user.nrp (untuk nrp)

2. Saat submit form Take 5, tambahkan field:
   pelapor_nama: user.nama,
   nrp: user.nrp

3. Update query insert:
   INSERT INTO take_5 (
     pic, site, tanggal, waktu, lokasi, 
     kondisi_sebelum, kondisi_sesudah, 
     tindakan_pencegahan, status, 
     pelapor_nama, nrp  -- tambahan field baru
   ) VALUES (
     $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
   )

4. Update form component untuk otomatis mengisi:
   - pelapor_nama dari user session
   - nrp dari user session
*/

-- Contoh query untuk mengambil data user yang login
-- SELECT nama, nrp FROM users WHERE id = auth.uid();

-- Contoh query untuk insert dengan field baru
/*
INSERT INTO take_5 (
  pic, site, tanggal, waktu, lokasi,
  kondisi_sebelum, kondisi_sesudah,
  tindakan_pencegahan, status,
  pelapor_nama, nrp
) VALUES (
  'PIC Name', 'Site Name', '2024-01-01', '08:00', 'Location',
  'Condition Before', 'Condition After',
  'Prevention Action', 'Submit',
  'Logged User Name', '123456'  -- dari user session
);
*/ 