# Logika Validasi Fit To Work - Update

## Perubahan Logika Validasi

### Sebelumnya:

- Semua validasi memerlukan 2 level review (Level 1 + Level 2 SHE)
- Status: Pending Review → Initial Review → Completed

### Sekarang:

- **PJO (Penanggung Jawab Operasional)**: Langsung selesai tanpa perlu SHE validation
- **Jabatan lain**: Perlu review oleh SHERQ setelah Level 1
- Status: Pending Review → Initial Review → SHE Validation → Completed

## Flow Validasi Baru

### 1. Level 1 Review (Leading Hand, Asst. PJO, PJO, SHE)

- **Leading Hand**: Review Crew, Mekanik, QC, Operator MMU, Operator Plant
- **Asst. PJO**: Review Blaster, Leading Hand
- **PJO**: Review Asst. PJO, SHERQ Officer, Technical Service
- **SHE**: Review Admin

### 2. Setelah Level 1 Review:

- **Jika reviewer adalah PJO**: Status langsung menjadi "Completed"
- **Jika reviewer bukan PJO**: Status menjadi "SHE Validation" (menunggu review SHE)

### 3. Level 2 Review (SHE)

- **Hanya SHE** yang bisa melakukan Level 2 review
- **Hanya untuk validasi dengan status "SHE Validation"**
- Setelah review SHE: Status menjadi "Completed"

## Database Changes

### Constraint Baru:

```sql
CONSTRAINT valid_status_flow CHECK (
    (status = 'Pending Review' AND level1_reviewer_nama IS NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'Initial Review' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'SHE Validation' AND level1_reviewer_nama IS NOT NULL AND level2_reviewer_nama IS NULL) OR
    (status = 'Completed' AND level1_reviewer_nama IS NOT NULL AND (
        (user_jabatan = 'Penanggung Jawab Operasional' AND level2_reviewer_nama IS NULL) OR
        (user_jabatan != 'Penanggung Jawab Operasional' AND level2_reviewer_nama IS NOT NULL)
    ))
)
```

## Frontend Changes

### 1. FitToWorkValidationForm.jsx

- **handleSubmit**: Logika baru untuk menentukan status setelah Level 1
- **canEditLevel2**: Hanya SHE yang bisa edit Level 2, status harus "SHE Validation"

### 2. FitToWorkValidation/index.jsx

- **fetchValidations**: Filter berdasarkan status yang bisa diakses
- **Leading Hand/Asst. PJO**: Hanya lihat "Pending Review"
- **PJO**: Lihat "Pending Review" (bisa langsung selesai)
- **SHE**: Lihat "SHE Validation" dan "Pending Review" untuk Admin

### 3. App.jsx (Notifications)

- **Notifikasi**: Mengakomodasi status "SHE Validation"
- **SHE**: Dapat notifikasi untuk validasi "SHE Validation"
- **Jabatan lain**: Dapat notifikasi untuk validasi "Pending Review"

## Data yang Dikirim ke Supabase

### Level 1 Review:

- `level1_reviewer_nama`: Nama reviewer
- `level1_reviewer_jabatan`: Jabatan reviewer
- `level1_reviewed_at`: Timestamp review
- `level1_tindakan_[jabatan]`: Tindakan yang diambil sesuai jabatan reviewer
- `status`: "Completed" (jika PJO) atau "SHE Validation" (jika bukan PJO)

### Level 2 Review (SHE):

- `level2_reviewer_nama`: Nama reviewer SHE
- `level2_reviewer_jabatan`: "SHE"
- `level2_reviewed_at`: Timestamp review
- Semua field level2\_\*: Data dari form Level 2
- `status`: "Completed"

## Testing

### Test Cases:

1. **Crew submit "Not Fit To Work"** → Leading Hand review → SHE review → Completed
2. **Admin submit "Not Fit To Work"** → SHE review → Completed
3. **SHERQ Officer submit "Not Fit To Work"** → PJO review → Completed (langsung)
4. **Asst. PJO submit "Not Fit To Work"** → PJO review → Completed (langsung)

### Expected Results:

- PJO tidak perlu menunggu SHE validation
- Jabatan lain tetap perlu SHE validation
- Data tersimpan dengan benar di Supabase
- Notifikasi muncul sesuai status
