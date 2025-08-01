# Aplikasi Manajemen Keselamatan Kerja

Aplikasi React untuk manajemen keselamatan kerja yang mencakup Fit to Work, Hazard forms, Take5 forms, dan manajemen pengguna.

## Fitur Utama

- **Fit to Work Form**: Form untuk validasi kesiapan kerja
- **Hazard Form**: Form untuk pelaporan bahaya di tempat kerja
- **Take5 Form**: Form untuk penilaian keselamatan sebelum memulai pekerjaan
- **User Management**: Manajemen pengguna dan hak akses
- **Monitoring Page**: Halaman monitoring untuk tracking status
- **Profile Management**: Manajemen profil pengguna

## Teknologi yang Digunakan

- **Frontend**: React 19.1.0 dengan Vite
- **Styling**: Tailwind CSS
- **Database**: Supabase
- **PDF Generation**: jsPDF
- **Excel Export**: xlsx
- **Image Processing**: react-easy-crop

## Instalasi

1. Clone repository ini:

```bash
git clone [URL_REPOSITORY]
cd my-react-app
```

2. Install dependencies:

```bash
npm install
```

3. Setup environment variables:
   Buat file `.env` di root directory dan tambahkan konfigurasi Supabase:

```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Jalankan aplikasi dalam mode development:

```bash
npm run dev
```

## Build untuk Production

Untuk membuat build production:

```bash
npm run build
```

Build akan tersimpan di folder `dist/` yang siap untuk di-deploy.

## Struktur Proyek

```
src/
├── components/
│   ├── Dropzone/           # Komponen upload file
│   ├── FitToWorkForm/      # Form Fit to Work
│   ├── FitToWorkValidation/ # Validasi Fit to Work
│   ├── HazardForm/         # Form Hazard
│   ├── Take5Form/          # Form Take5
│   ├── TasklistPage/       # Halaman tasklist
│   ├── UserManagement/     # Manajemen pengguna
│   └── Profile/            # Manajemen profil
├── config/
│   └── siteLocations.js    # Konfigurasi lokasi
└── supabaseClient.js       # Konfigurasi Supabase
```

## Scripts

- `npm run dev` - Menjalankan aplikasi dalam mode development
- `npm run build` - Membuat build production
- `npm run preview` - Preview build production
- `npm run lint` - Menjalankan ESLint

## Deployment

Aplikasi ini dapat di-deploy ke berbagai platform:

### Vercel

1. Push kode ke GitHub
2. Connect repository ke Vercel
3. Deploy otomatis

### Netlify

1. Upload folder `dist/` ke Netlify
2. Atau connect repository untuk auto-deploy

### GitHub Pages

1. Push kode ke GitHub
2. Enable GitHub Pages di repository settings
3. Set source ke folder `dist/`

## Kontribusi

1. Fork repository
2. Buat branch fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

## Kontak

Untuk pertanyaan atau dukungan, silakan hubungi tim pengembang.
