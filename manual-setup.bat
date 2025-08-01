@echo off
echo ========================================
echo Manual Setup - Git, GitHub & Vercel
echo ========================================
echo.
echo Pastikan Git sudah terinstall dan terminal sudah di-restart!
echo.

echo STEP 1: Konfigurasi Git
echo ========================================
set /p userName="Masukkan nama Anda: "
set /p userEmail="Masukkan email Anda: "

git config --global user.name "%userName%"
git config --global user.email "%userEmail%"

echo.
echo STEP 2: Inisialisasi Git Repository
echo ========================================
git init
git add .
git commit -m "Initial commit: Aplikasi Manajemen Keselamatan Kerja"

echo.
echo STEP 3: Buat Repository di GitHub
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

set /p githubUsername="Masukkan username GitHub Anda: "
set /p repositoryName="Masukkan nama repository (default: safety-management-app): "

if "%repositoryName%"=="" set repositoryName=safety-management-app

echo.
echo STEP 4: Hubungkan ke Repository GitHub
echo ========================================
git remote add origin https://github.com/%githubUsername%/%repositoryName%.git
git branch -M main

echo Repository URL: https://github.com/%githubUsername%/%repositoryName%.git

set /p pushToGitHub="Apakah Anda ingin push ke GitHub sekarang? (y/n): "
if /i "%pushToGitHub%"=="y" (
    git push -u origin main
    echo Kode berhasil di-push ke GitHub!
)

echo.
echo STEP 5: Deploy ke Vercel
echo ========================================
echo Installing Vercel CLI...
npm install -g vercel

echo.
echo Login ke Vercel...
vercel login

echo.
set /p deployToVercel="Apakah Anda ingin deploy ke Vercel sekarang? (y/n): "
if /i "%deployToVercel%"=="y" (
    echo Deploying ke Vercel...
    vercel --prod
    echo Deploy ke Vercel selesai!
)

echo.
echo STEP 6: Environment Variables
echo ========================================
echo Setelah deploy, jangan lupa set environment variables di Vercel dashboard:
echo 1. Buka project di Vercel dashboard
echo 2. Klik "Settings" tab
echo 3. Klik "Environment Variables"
echo 4. Tambahkan:
echo    - VITE_SUPABASE_URL = your_supabase_url
echo    - VITE_SUPABASE_ANON_KEY = your_supabase_anon_key
echo 5. Klik "Save"
echo.

echo ========================================
echo SELESAI! Aplikasi Anda siap di-deploy!
echo ========================================
pause 