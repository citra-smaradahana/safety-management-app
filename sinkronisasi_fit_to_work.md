# Sinkronisasi Fit To Work dan Fit To Work Validations

## Logika Sinkronisasi

### 1. Flow Utama

```
User mengisi Fit To Work Form
    ↓
Status = "Not Fit To Work"
    ↓
Trigger otomatis membuat record di fit_to_work_validations
    ↓
Status = "Pending Review"
    ↓
Validator melakukan review
    ↓
Status = "Completed" (setelah validasi selesai)
    ↓
Trigger otomatis update fit_to_work.status = "Validated"
```

### 2. Trigger dan Function

#### A. Trigger untuk Membuat Validasi

- **Event**: INSERT atau UPDATE pada tabel `fit_to_work`
- **Condition**: Status berubah menjadi "Not Fit To Work"
- **Action**: Membuat record baru di `fit_to_work_validations` dengan status "Pending Review"

#### B. Trigger untuk Update Status Fit To Work

- **Event**: UPDATE pada tabel `fit_to_work_validations`
- **Condition**: Status berubah menjadi "Completed"
- **Action**: Update `fit_to_work.status` menjadi "Validated"

### 3. Status Mapping

#### Tabel fit_to_work:

- `"Fit To Work"` - User sehat, tidak perlu validasi
- `"Not Fit To Work"` - User tidak sehat, perlu validasi
- `"Validated"` - Sudah divalidasi oleh reviewer

#### Tabel fit_to_work_validations:

- `"Pending Review"` - Menunggu review dari validator
- `"Initial Review"` - Sedang di-review Level 1
- `"SHE Validation"` - Menunggu review SHE (Level 2)
- `"Completed"` - Validasi selesai

### 4. Sinkronisasi Data

#### Saat User Submit Fit To Work:

```javascript
// Di FitToWorkForm
const insertData = {
  nama: user.nama,
  jabatan: user.jabatan,
  nrp: user.nrp,
  site: user.site,
  status: status, // "Fit To Work" atau "Not Fit To Work"
  // ... field lainnya
};

await supabase.from("fit_to_work").insert(insertData);
// Trigger otomatis membuat record di fit_to_work_validations jika status = "Not Fit To Work"
```

#### Saat Validator Submit Review:

```javascript
// Di FitToWorkValidationForm
const updatedValidation = {
  // ... data review
  status: "Completed", // atau status lainnya
};

await supabase.from("fit_to_work_validations").update(updatedValidation);
// Trigger otomatis update fit_to_work.status jika validation.status = "Completed"
```

### 5. Validasi Sinkronisasi

#### Query untuk cek sinkronisasi:

```sql
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
WHERE ftw.status = 'Not Fit To Work' OR ftwv.id IS NOT NULL;
```

### 6. Troubleshooting

#### Jika ada data yang tidak sinkron:

1. **Missing Validation**: Ada record `fit_to_work` dengan status "Not Fit To Work" tapi tidak ada di `fit_to_work_validations`

   - **Solusi**: Jalankan script untuk membuat validasi yang hilang

2. **Extra Validation**: Ada record di `fit_to_work_validations` tapi `fit_to_work` status bukan "Not Fit To Work"

   - **Solusi**: Hapus validasi yang tidak diperlukan

3. **Status Mismatch**: Status tidak sesuai dengan workflow
   - **Solusi**: Update status manual atau reset validasi

### 7. Testing

#### Test Case 1: User Submit "Not Fit To Work"

1. User mengisi form Fit To Work
2. Pilih "Not Fit To Work"
3. Submit form
4. **Expected**: Record dibuat di `fit_to_work` dan `fit_to_work_validations`

#### Test Case 2: Validator Review

1. Validator membuka menu "Validasi Fit To Work"
2. Melakukan review
3. Submit review
4. **Expected**: Status berubah sesuai workflow

#### Test Case 3: Validasi Selesai

1. SHE melakukan review final
2. Submit dengan status "Completed"
3. **Expected**: `fit_to_work.status` berubah menjadi "Validated"

### 8. Monitoring

#### Query untuk monitoring:

```sql
-- Cek jumlah record per status
SELECT
    'fit_to_work' as table_name,
    status,
    COUNT(*) as count
FROM fit_to_work
GROUP BY status
UNION ALL
SELECT
    'fit_to_work_validations' as table_name,
    status,
    COUNT(*) as count
FROM fit_to_work_validations
GROUP BY status;
```
