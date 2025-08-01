# 🚀 Quick Start - Deploy ke GitHub & Vercel

## Langkah Cepat (5 Menit)

### 1. Install Git
Download dari: https://git-scm.com/download/win

### 2. Jalankan Script Otomatis
```powershell
# Di PowerShell, jalankan:
.\setup-github-vercel.ps1
```

### 3. Atau Manual Setup

#### A. Setup Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

#### B. Inisialisasi Repository
```bash
git init
git add .
git commit -m "Initial commit: Aplikasi Manajemen Keselamatan Kerja"
```

#### C. Buat Repository di GitHub
1. Buka https://github.com
2. Klik "New repository"
3. Nama: `safety-management-app`
4. **JANGAN** centang "Initialize with README"
5. Klik "Create repository"

#### D. Push ke GitHub
```bash
git remote add origin https://github.com/USERNAME/safety-management-app.git
git branch -M main
git push -u origin main
```

#### E. Deploy ke Vercel
```bash
npm install -g vercel
vercel login
vercel --prod
```

## ✅ Selesai!

Aplikasi Anda akan live di URL yang diberikan Vercel.

## 🔧 Environment Variables

Set di Vercel Dashboard:
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`

## 📁 File Penting

- `dist/` - Build production
- `vercel.json` - Konfigurasi Vercel
- `package.json` - Dependencies
- `.gitignore` - File yang diabaikan

## 🆘 Troubleshooting

### Git tidak ditemukan
- Install Git dari https://git-scm.com/download/win
- Restart terminal

### Vercel error
- Pastikan login: `vercel login`
- Coba: `vercel --prod dist`

### Build error
- Jalankan: `npm install`
- Jalankan: `npm run build` 