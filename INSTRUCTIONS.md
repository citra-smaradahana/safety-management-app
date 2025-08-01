# 📋 Instruksi Setup Git, GitHub & Vercel

## 🔄 Setelah Install Git

### 1. Restart Terminal/PowerShell

- Tutup terminal/PowerShell yang sedang terbuka
- Buka terminal/PowerShell baru
- Navigasi ke folder aplikasi: `cd "D:\lenovo data\KMB\BSIB\Web Development\Test\my-react-app"`

### 2. Verifikasi Git Terinstall

```bash
git --version
```

Seharusnya menampilkan versi Git (contoh: `git version 2.40.0.windows.1`)

### 3. Jalankan Script Manual

```bash
manual-setup.bat
```

## 🚀 Langkah Manual (Jika Script Tidak Berfungsi)

### Step 1: Konfigurasi Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 2: Inisialisasi Repository

```bash
git init
git add .
git commit -m "Initial commit: Aplikasi Manajemen Keselamatan Kerja"
```

### Step 3: Buat Repository di GitHub

1. Buka https://github.com
2. Login ke akun GitHub
3. Klik tombol "+" di pojok kanan atas
4. Pilih "New repository"
5. Isi form:
   - **Repository name**: `safety-management-app`
   - **Description**: `Aplikasi Manajemen Keselamatan Kerja`
   - **Visibility**: Public atau Private
   - **JANGAN** centang "Initialize this repository with a README"
6. Klik "Create repository"

### Step 4: Hubungkan ke GitHub

```bash
git remote add origin https://github.com/USERNAME/safety-management-app.git
git branch -M main
git push -u origin main
```

_Ganti `USERNAME` dengan username GitHub Anda_

### Step 5: Deploy ke Vercel

```bash
npm install -g vercel
vercel login
vercel --prod
```

## 🔧 Environment Variables di Vercel

Setelah deploy, set environment variables:

1. Buka project di Vercel dashboard
2. Klik "Settings" tab
3. Klik "Environment Variables"
4. Tambahkan:
   - `VITE_SUPABASE_URL` = `your_supabase_url`
   - `VITE_SUPABASE_ANON_KEY` = `your_supabase_anon_key`
5. Klik "Save"

## 📁 File yang Sudah Disiapkan

- ✅ `dist/` - Build production (1.7 MB)
- ✅ `README.md` - Dokumentasi lengkap
- ✅ `DEPLOYMENT.md` - Panduan deployment
- ✅ `vercel.json` - Konfigurasi Vercel
- ✅ `.gitignore` - File yang diabaikan
- ✅ `package.json` - Dependencies
- ✅ `LICENSE` - Lisensi MIT
- ✅ `CHANGELOG.md` - Tracking perubahan

## 🆘 Troubleshooting

### Git tidak ditemukan setelah install

- Restart komputer
- Atau restart terminal/PowerShell
- Atau tambahkan Git ke PATH manual

### Error saat push ke GitHub

- Pastikan repository sudah dibuat di GitHub
- Pastikan URL repository benar
- Pastikan sudah login ke GitHub

### Error saat deploy Vercel

- Pastikan sudah login: `vercel login`
- Coba deploy dari folder dist: `vercel --prod dist`
- Periksa environment variables

## ✅ Checklist

- [ ] Git terinstall dan terdeteksi
- [ ] Repository GitHub dibuat
- [ ] Kode di-push ke GitHub
- [ ] Vercel CLI terinstall
- [ ] Login ke Vercel
- [ ] Deploy ke Vercel
- [ ] Environment variables diset
- [ ] Aplikasi berjalan di URL Vercel

## 🎯 Hasil Akhir

Aplikasi Anda akan live di URL seperti:
`https://safety-management-app-xxxxx.vercel.app`
