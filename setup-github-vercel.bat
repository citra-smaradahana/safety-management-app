@echo off
echo ========================================
echo Setup Git, GitHub & Vercel Deployment
echo ========================================

echo.
echo STEP 1: Install Git
echo ========================================
echo Git belum terinstall di sistem Anda.
echo.
echo Silakan download dan install Git dari:
echo https://git-scm.com/download/win
echo.
echo Setelah install Git:
echo 1. Restart terminal/PowerShell ini
echo 2. Jalankan script ini lagi
echo.
pause

echo.
echo STEP 2: Konfigurasi Git
echo ========================================
echo Setelah Git terinstall, jalankan perintah berikut:
echo.
echo git config --global user.name "Your Name"
echo git config --global user.email "your.email@example.com"
echo.

echo.
echo STEP 3: Inisialisasi Git Repository
echo ========================================
echo git init
echo git add .
echo git commit -m "Initial commit: Aplikasi Manajemen Keselamatan Kerja"
echo.

echo.
echo STEP 4: Buat Repository di GitHub
echo ========================================
echo 1. Buka https://github.com
echo 2. Login ke akun GitHub Anda
echo 3. Klik tombol "+" di pojok kanan atas
echo 4. Pilih "New repository"
echo 5. Beri nama repository: safety-management-app
echo 6. Tambahkan deskripsi: "Aplikasi Manajemen Keselamatan Kerja"
echo 7. Pilih "Public" atau "Private"
echo 8. JANGAN centang "Initialize this repository with a README"
echo 9. Klik "Create repository"
echo.

echo.
echo STEP 5: Hubungkan ke Repository GitHub
echo ========================================
echo Setelah repository dibuat, GitHub akan menampilkan perintah.
echo Jalankan perintah berikut (ganti USERNAME dengan username GitHub Anda):
echo.
echo git remote add origin https://github.com/USERNAME/safety-management-app.git
echo git branch -M main
echo git push -u origin main
echo.

echo.
echo STEP 6: Deploy ke Vercel
echo ========================================
echo 1. Install Vercel CLI:
echo    npm install -g vercel
echo.
echo 2. Login ke Vercel:
echo    vercel login
echo.
echo 3. Deploy aplikasi:
echo    vercel --prod
echo.
echo Atau untuk deploy dari folder dist:
echo    vercel --prod dist
echo.

echo.
echo STEP 7: Environment Variables di Vercel
echo ========================================
echo Setelah deploy, set environment variables di Vercel dashboard:
echo 1. Buka project di Vercel dashboard
echo 2. Klik "Settings" tab
echo 3. Klik "Environment Variables"
echo 4. Tambahkan:
echo    - VITE_SUPABASE_URL = your_supabase_url
echo    - VITE_SUPABASE_ANON_KEY = your_supabase_anon_key
echo 5. Klik "Save"
echo.

echo.
echo ========================================
echo SELESAI! Aplikasi Anda siap di-deploy!
echo ========================================
echo.
echo File yang sudah disiapkan:
echo - dist/ (build production)
echo - README.md (dokumentasi)
echo - DEPLOYMENT.md (panduan deployment)
echo - .gitignore (file yang diabaikan)
echo - package.json (konfigurasi)
echo.
pause 