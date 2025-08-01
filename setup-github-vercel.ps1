# Setup Git, GitHub & Vercel Deployment Script
# PowerShell Script untuk otomatisasi deployment

Write-Host "========================================" -ForegroundColor Green
Write-Host "Setup Git, GitHub & Vercel Deployment" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Check if Git is installed
try {
    $gitVersion = git --version
    Write-Host "✅ Git terinstall: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git belum terinstall!" -ForegroundColor Red
    Write-Host "Silakan download dan install Git dari: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "Setelah install, restart PowerShell dan jalankan script ini lagi." -ForegroundColor Yellow
    Read-Host "Tekan Enter untuk keluar"
    exit
}

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js terinstall: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js belum terinstall!" -ForegroundColor Red
    Write-Host "Silakan download dan install Node.js dari: https://nodejs.org/" -ForegroundColor Yellow
    Read-Host "Tekan Enter untuk keluar"
    exit
}

Write-Host ""
Write-Host "STEP 1: Konfigurasi Git" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$userName = Read-Host "Masukkan nama Anda untuk Git config"
$userEmail = Read-Host "Masukkan email Anda untuk Git config"

git config --global user.name $userName
git config --global user.email $userEmail

Write-Host "✅ Git config berhasil diset!" -ForegroundColor Green

Write-Host ""
Write-Host "STEP 2: Inisialisasi Git Repository" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

git init
git add .
git commit -m "Initial commit: Aplikasi Manajemen Keselamatan Kerja"

Write-Host "✅ Git repository berhasil diinisialisasi!" -ForegroundColor Green

Write-Host ""
Write-Host "STEP 3: Buat Repository di GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "1. Buka https://github.com" -ForegroundColor Yellow
Write-Host "2. Login ke akun GitHub Anda" -ForegroundColor Yellow
Write-Host "3. Klik tombol '+' di pojok kanan atas" -ForegroundColor Yellow
Write-Host "4. Pilih 'New repository'" -ForegroundColor Yellow
Write-Host "5. Beri nama repository: safety-management-app" -ForegroundColor Yellow
Write-Host "6. Tambahkan deskripsi: 'Aplikasi Manajemen Keselamatan Kerja'" -ForegroundColor Yellow
Write-Host "7. Pilih 'Public' atau 'Private'" -ForegroundColor Yellow
Write-Host "8. JANGAN centang 'Initialize this repository with a README'" -ForegroundColor Yellow
Write-Host "9. Klik 'Create repository'" -ForegroundColor Yellow

$githubUsername = Read-Host "Masukkan username GitHub Anda"
$repositoryName = Read-Host "Masukkan nama repository (default: safety-management-app)" 
if ([string]::IsNullOrEmpty($repositoryName)) {
    $repositoryName = "safety-management-app"
}

Write-Host ""
Write-Host "STEP 4: Hubungkan ke Repository GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$remoteUrl = "https://github.com/$githubUsername/$repositoryName.git"
git remote add origin $remoteUrl
git branch -M main

Write-Host "Repository URL: $remoteUrl" -ForegroundColor Green

$pushToGitHub = Read-Host "Apakah Anda ingin push ke GitHub sekarang? (y/n)"
if ($pushToGitHub -eq "y" -or $pushToGitHub -eq "Y") {
    git push -u origin main
    Write-Host "✅ Kode berhasil di-push ke GitHub!" -ForegroundColor Green
}

Write-Host ""
Write-Host "STEP 5: Deploy ke Vercel" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check if Vercel CLI is installed
try {
    $vercelVersion = vercel --version
    Write-Host "✅ Vercel CLI terinstall: $vercelVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Vercel CLI belum terinstall!" -ForegroundColor Red
    Write-Host "Installing Vercel CLI..." -ForegroundColor Yellow
    npm install -g vercel
}

$deployToVercel = Read-Host "Apakah Anda ingin deploy ke Vercel sekarang? (y/n)"
if ($deployToVercel -eq "y" -or $deployToVercel -eq "Y") {
    Write-Host "Deploying ke Vercel..." -ForegroundColor Yellow
    vercel --prod
    Write-Host "✅ Deploy ke Vercel selesai!" -ForegroundColor Green
}

Write-Host ""
Write-Host "STEP 6: Environment Variables" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "Setelah deploy, jangan lupa set environment variables di Vercel dashboard:" -ForegroundColor Yellow
Write-Host "1. Buka project di Vercel dashboard" -ForegroundColor Yellow
Write-Host "2. Klik 'Settings' tab" -ForegroundColor Yellow
Write-Host "3. Klik 'Environment Variables'" -ForegroundColor Yellow
Write-Host "4. Tambahkan:" -ForegroundColor Yellow
Write-Host "   - VITE_SUPABASE_URL = your_supabase_url" -ForegroundColor Yellow
Write-Host "   - VITE_SUPABASE_ANON_KEY = your_supabase_anon_key" -ForegroundColor Yellow
Write-Host "5. Klik 'Save'" -ForegroundColor Yellow

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SELESAI! Aplikasi Anda siap di-deploy!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host ""
Write-Host "File yang sudah disiapkan:" -ForegroundColor Cyan
Write-Host "- dist/ (build production)" -ForegroundColor White
Write-Host "- README.md (dokumentasi)" -ForegroundColor White
Write-Host "- DEPLOYMENT.md (panduan deployment)" -ForegroundColor White
Write-Host "- .gitignore (file yang diabaikan)" -ForegroundColor White
Write-Host "- package.json (konfigurasi)" -ForegroundColor White

Read-Host "Tekan Enter untuk keluar" 