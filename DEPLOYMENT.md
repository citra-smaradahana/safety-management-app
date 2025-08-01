# Panduan Deployment Aplikasi

## Status Build

✅ **Build berhasil dibuat!**

- Folder `dist/` telah dibuat dan siap untuk deployment
- Ukuran total: ~1.7 MB (terkompresi: ~490 KB)

## Opsi Deployment

### 1. Vercel (Rekomendasi)

**Keuntungan**: Gratis, auto-deploy, mudah setup

1. Install Vercel CLI:

```bash
npm install -g vercel
```

2. Login ke Vercel:

```bash
vercel login
```

3. Deploy dari folder dist:

```bash
vercel --prod dist
```

### 2. Netlify

**Keuntungan**: Gratis, drag & drop deployment

1. Buka https://netlify.com
2. Drag & drop folder `dist/` ke area deployment
3. Atau connect repository GitHub untuk auto-deploy

### 3. GitHub Pages

**Keuntungan**: Gratis, terintegrasi dengan GitHub

1. Push kode ke GitHub
2. Buka repository settings
3. Scroll ke "GitHub Pages"
4. Set source ke "Deploy from a branch"
5. Pilih branch "main" dan folder "/ (root)"
6. Klik "Save"

### 4. Firebase Hosting

**Keuntungan**: Gratis, terintegrasi dengan Google

1. Install Firebase CLI:

```bash
npm install -g firebase-tools
```

2. Login dan inisialisasi:

```bash
firebase login
firebase init hosting
```

3. Deploy:

```bash
firebase deploy
```

## Setup Repository GitHub

### Langkah 1: Install Git

Download dari: https://git-scm.com/download/win

### Langkah 2: Konfigurasi Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Langkah 3: Inisialisasi Repository

```bash
git init
git add .
git commit -m "Initial commit: Aplikasi Manajemen Keselamatan Kerja"
```

### Langkah 4: Buat Repository di GitHub

1. Buka https://github.com
2. Klik "New repository"
3. Beri nama: `safety-management-app`
4. Jangan centang "Initialize with README"
5. Klik "Create repository"

### Langkah 5: Push ke GitHub

```bash
git remote add origin https://github.com/USERNAME/safety-management-app.git
git branch -M main
git push -u origin main
```

## Environment Variables

Sebelum deploy, pastikan environment variables sudah diset:

### Vercel

1. Buka project di Vercel dashboard
2. Klik "Settings" → "Environment Variables"
3. Tambahkan:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

### Netlify

1. Buka site settings
2. Klik "Environment variables"
3. Tambahkan variables yang sama

## Troubleshooting

### Build Errors

- Pastikan semua dependencies terinstall: `npm install`
- Jalankan linting: `npm run lint`
- Periksa console untuk error details

### Deployment Issues

- Pastikan folder `dist/` ada dan berisi file
- Periksa environment variables
- Pastikan domain sudah dikonfigurasi dengan benar

### Performance

- Build size cukup besar (1.7MB), pertimbangkan code splitting
- Gunakan lazy loading untuk komponen besar
- Optimize images dan assets

## Monitoring

Setelah deploy, monitor:

- Performance dengan Lighthouse
- Error logs di platform hosting
- User analytics
- Database performance

## Backup

- Backup kode ke GitHub
- Backup database Supabase
- Backup environment variables
- Dokumentasikan konfigurasi deployment
