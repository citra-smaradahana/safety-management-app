# 🏢 Hierarki Validator Fit To Work - Simplified

## 📊 Flow Diagram

```
User Submit "Not Fit To Work"
           │
           ▼
    ┌─────────────┐
    │ Pending     │ ← Auto-create validation
    │ Review      │
    └─────┬───────┘
          │
          ▼
    ┌─────────────┐
    │ Level 1     │ ← Initial Review
    │ Validator   │   (Leading Hand, Asst. PJO, PJO)
    └─────┬───────┘
          │
          ▼
    ┌─────────────┐
    │ Level 2     │ ← SHE Validation
    │ Validator   │   (SHE, SHERQ Officer)
    └─────┬───────┘
          │
          ▼
    ┌─────────────┐
    │ Completed   │ ← Final Status
    └─────────────┘
```

## 👥 Level 1 Validators (Initial Review)

| Validator                              | Bisa Validasi                                                   | Site Rule  |
| -------------------------------------- | --------------------------------------------------------------- | ---------- |
| **Leading Hand**                       | Crew, Mekanik, Quality Controller, Operator MMU, Operator Plant | Harus sama |
| **Asst. Penanggung Jawab Operasional** | Blaster, Leading Hand                                           | Harus sama |
| **Penanggung Jawab Operasional**       | Asst. PJO, SHERQ Officer, Technical Service                     | Harus sama |

## 🔍 Level 2 Validators (SHE Validation)

| Validator         | Bisa Validasi                   | Site Rule  |
| ----------------- | ------------------------------- | ---------- |
| **SHE**           | Semua yang sudah Initial Review | Harus sama |
| **SHERQ Officer** | Semua yang sudah Initial Review | Harus sama |

## 🏢 Site Examples

### BSIB Site:

- Leading Hand BSIB → Crew BSIB ✅
- Leading Hand BSIB → Operator MMU BSIB ✅
- Leading Hand BSIB → Operator Plant BSIB ✅
- PJO BSIB → Asst. PJO BSIB ✅
- SHE BSIB → Semua level 1 BSIB ✅

### ADRO Site:

- Leading Hand ADRO → Crew ADRO ✅
- Leading Hand ADRO → Operator MMU ADRO ✅
- Leading Hand ADRO → Operator Plant ADRO ✅
- PJO ADRO → Asst. PJO ADRO ✅
- SHE ADRO → Semua level 1 ADRO ✅

## ❌ Cross-Site Validation (Tidak Diizinkan):

- Leading Hand BSIB → Crew ADRO ❌
- Leading Hand BSIB → Operator MMU ADRO ❌
- PJO BSIB → Asst. PJO ADRO ❌
- SHE BSIB → Level 1 ADRO ❌
