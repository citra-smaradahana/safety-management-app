# 🏢 Hierarki Validator Fit To Work

## 📋 Overview

Sistem validasi Fit To Work menggunakan **2-level validation** dengan **site-based filtering** untuk memastikan validasi sesuai dengan hierarki organisasi dan lokasi kerja.

---

## 🎯 Level 1: Initial Review

### 👥 Jabatan yang Bisa Melakukan Level 1 Review:

#### 1. **Leading Hand** 🔧

- **Bisa validasi:** Crew, Mekanik, Quality Controller
- **Site:** Harus sama dengan user yang divalidasi
- **Status:** Pending Review → Initial Review

#### 2. **Asst. Penanggung Jawab Operasional** 👨‍💼

- **Bisa validasi:** Blaster, Leading Hand
- **Site:** Harus sama dengan user yang divalidasi
- **Status:** Pending Review → Initial Review

#### 3. **Penanggung Jawab Operasional** 👨‍💼

- **Bisa validasi:** Asst. Penanggung Jawab Operasional, SHERQ Officer, Technical Service
- **Site:** Harus sama dengan user yang divalidasi
- **Status:** Pending Review → Initial Review

#### 4. **Operator MMU** 🚛

- **Bisa validasi:** Crew, Mekanik
- **Site:** Harus sama dengan user yang divalidasi
- **Status:** Pending Review → Initial Review

#### 5. **Operator Plant** 🏭

- **Bisa validasi:** Crew, Mekanik
- **Site:** Harus sama dengan user yang divalidasi
- **Status:** Pending Review → Initial Review

---

## 🔍 Level 2: SHE Validation

### 👥 Jabatan yang Bisa Melakukan Level 2 Review:

#### 1. **SHE (Safety, Health & Environment)** 🛡️

- **Bisa validasi:** Semua yang sudah Initial Review
- **Site:** Harus sama dengan user yang divalidasi
- **Status:** Initial Review → Completed
- **Fungsi:** Final decision maker

#### 2. **SHERQ Officer** 🛡️

- **Bisa validasi:** Semua yang sudah Initial Review
- **Site:** Harus sama dengan user yang divalidasi
- **Status:** Initial Review → Completed
- **Fungsi:** Final decision maker

---

## 📊 Flow Status Validasi

```
┌─────────────────┐
│   Not Fit To    │ ← User submit "Not Fit To Work"
│     Work        │
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│  Pending Review │ ← Auto-create validation entry
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│ Initial Review  │ ← Level 1 validator action
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│ SHE Validation  │ ← Level 2 validator action
└─────────┬───────┘
          │
          ▼
┌─────────────────┐
│   Completed     │ ← Final status
└─────────────────┘
```

---

## 🏢 Site-Based Validation Rules

### ✅ **DIPERBOLEHKAN:**

- Leading Hand BSIB → validasi Crew BSIB ✅
- PJO ADRO → validasi Asst. PJO ADRO ✅
- SHE BSIB → validasi semua level 1 BSIB ✅

### ❌ **TIDAK DIPERBOLEHKAN:**

- Leading Hand BSIB → validasi Crew ADRO ❌
- PJO BSIB → validasi Asst. PJO ADRO ❌
- SHE BSIB → validasi level 1 ADRO ❌

---

## 🎯 Contoh Hierarki per Site

### **Site: BSIB**

```
Crew BSIB
├── Leading Hand BSIB (Level 1)
    └── SHE BSIB (Level 2)

Mekanik BSIB
├── Leading Hand BSIB (Level 1)
    └── SHE BSIB (Level 2)

Quality Controller BSIB
├── Leading Hand BSIB (Level 1)
    └── SHE BSIB (Level 2)

Blaster BSIB
├── Asst. PJO BSIB (Level 1)
    └── SHE BSIB (Level 2)

Leading Hand BSIB
├── Asst. PJO BSIB (Level 1)
    └── SHE BSIB (Level 2)

Asst. PJO BSIB
├── PJO BSIB (Level 1)
    └── SHE BSIB (Level 2)

SHERQ Officer BSIB
├── PJO BSIB (Level 1)
    └── SHE BSIB (Level 2)

Technical Service BSIB
├── PJO BSIB (Level 1)
    └── SHE BSIB (Level 2)
```

### **Site: ADRO**

```
Crew ADRO
├── Leading Hand ADRO (Level 1)
    └── SHE ADRO (Level 2)

Mekanik ADRO
├── Leading Hand ADRO (Level 1)
    └── SHE ADRO (Level 2)

Quality Controller ADRO
├── Leading Hand ADRO (Level 1)
    └── SHE ADRO (Level 2)

Blaster ADRO
├── Asst. PJO ADRO (Level 1)
    └── SHE ADRO (Level 2)

Leading Hand ADRO
├── Asst. PJO ADRO (Level 1)
    └── SHE ADRO (Level 2)

Asst. PJO ADRO
├── PJO ADRO (Level 1)
    └── SHE ADRO (Level 2)

SHERQ Officer ADRO
├── PJO ADRO (Level 1)
    └── SHE ADRO (Level 2)

Technical Service ADRO
├── PJO ADRO (Level 1)
    └── SHE ADRO (Level 2)
```

---

## 🔧 Technical Implementation

### **Database Functions:**

```sql
-- Function untuk mendapatkan reviewer berdasarkan jabatan dan site
CREATE OR REPLACE FUNCTION get_reviewer_by_jabatan_and_site(user_jabatan VARCHAR, user_site VARCHAR)
RETURNS TABLE(reviewer_jabatan VARCHAR, reviewer_level INTEGER, reviewer_site VARCHAR)
```

### **Frontend Logic:**

```javascript
// Site-based filtering
const canValidate = userSite === validation?.user_site;

// Level 1 validation
const canEditLevel1 = () => {
  if (userSite !== validation?.user_site) return false;
  // Check jabatan hierarchy
};

// Level 2 validation
const canEditLevel2 = () => {
  if (userSite !== validation?.user_site) return false;
  return (
    (userJabatan === "SHE" || userJabatan === "SHERQ Officer") &&
    status === "Initial Review"
  );
};
```

---

## 📱 Menu Access Rules

### **Desktop:**

- **Form Fit To Work:** Semua user
- **Validasi Fit To Work:** Evaluator + Admin + Jabatan validator

### **Mobile:**

- **Form Fit To Work:** Semua user
- **Validasi Fit To Work:** Tidak tersedia (desktop only)

---

## 🔔 Notification Rules

### **Level 1 Notifications:**

- Leading Hand → Crew, Mekanik, Quality Controller (site sama)
- Asst. PJO → Blaster, Leading Hand (site sama)
- PJO → Asst. PJO, SHERQ Officer, Technical Service (site sama)
- Operator MMU/Plant → Crew, Mekanik (site sama)

### **Level 2 Notifications:**

- SHE/SHERQ Officer → Semua Initial Review (site sama)

---

## 🎯 Key Benefits

1. **✅ Hierarki Organisasi:** Mengikuti struktur jabatan yang benar
2. **✅ Site Isolation:** Validasi terbatas per site
3. **✅ Two-Level Security:** Double validation untuk safety
4. **✅ Role-Based Access:** Menu dan notifikasi sesuai jabatan
5. **✅ Audit Trail:** Tracking lengkap per level
