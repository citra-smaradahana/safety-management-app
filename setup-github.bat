@echo off
echo ========================================
echo Setup Git dan GitHub Repository
echo ========================================

echo.
echo 1. Install Git (jika belum terinstall)
echo Silakan download dan install Git dari: https://git-scm.com/download/win
echo Setelah install, restart terminal ini dan jalankan script lagi.
echo.

echo 2. Konfigurasi Git (setelah Git terinstall)
echo git config --global user.name "Your Name"
echo git config --global user.email "your.email@example.com"
echo.

echo 3. Inisialisasi Git Repository
echo git init
echo.

echo 4. Tambahkan semua file ke staging
echo git add .
echo.

echo 5. Commit pertama
echo git commit -m "Initial commit: Aplikasi Manajemen Keselamatan Kerja"
echo.

echo 6. Buat repository di GitHub
echo - Buka https://github.com
echo - Login ke akun GitHub Anda
echo - Klik "New repository"
echo - Beri nama repository (misal: safety-management-app)
echo - Jangan centang "Initialize this repository with a README"
echo - Klik "Create repository"
echo.

echo 7. Hubungkan ke repository GitHub
echo git remote add origin https://github.com/USERNAME/REPOSITORY_NAME.git
echo git branch -M main
echo git push -u origin main
echo.

echo ========================================
echo Langkah-langkah di atas sudah siap!
echo ========================================
pause 