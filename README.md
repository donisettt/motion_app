# Motion — Aplikasi Eksplorasi Film

Motion adalah aplikasi mobile modern berbasis Flutter untuk mengeksplorasi dunia sinema, melihat detail film terkini, dan mengelola daftar tontonan favorit. Motion menggunakan data real-time dari **TMDb API**.

---

## 🎬 Fitur Utama

- **Home Screen Dinamis**
  - Menampilkan kategori film: Now Playing (Carousel), Trending, Popular, Top Rated

- **Detail Film Komprehensif**
  - Sinopsis, rating (TMDb/IMDb), tanggal rilis, Cast & Crew, hingga ulasan pengguna

- **Tonton Trailer**
  - Akses cepat trailer via YouTube menggunakan `url_launcher`

- **Pencarian Global**
  - Search Screen yang dapat mencari film berdasarkan judul

- **Daftar Favorit**
  - Favorite Screen untuk mengelola daftar film favorit

- **Profil Pengguna**
  - Profile Screen untuk personalisasi akun

- **Navigasi Cepat**
  - Menggunakan `BottomNavigationBar`

---

## 🛠️ Teknologi dan Dependencies

| Kategori        | Nama Teknologi / Library | Deskripsi                                           |
|-----------------|--------------------------|-----------------------------------------------------|
| Framework       | Flutter (3.x+)           | Kerangka kerja cross-platform untuk membangun UI    |
| Network         | http                     | Digunakan untuk panggilan HTTP ke TMDb API         |
| External Link   | url_launcher             | Digunakan untuk membuka trailer YouTube/Browser     |
| Data API        | The Movie Database (TMDb)| Sumber data film, cast, rating, trailer             |

---

## 🌐 Konfigurasi API (TMDb)

Aplikasi menggunakan API dari TMDb.

1. Daftar akun di TMDb  
2. Dapatkan API Key TMDb  
3. API Key dimasukkan di file:  
   `lib/services/api_services.dart`

---

## ## Demo Aplikasi

| Halaman | Preview |
|--------|---------|
| Home | ![Dashboard](https://github.com/user-attachments/assets/53d9b572-3904-43cf-8d06-b915aa35c43b) |
| Search | ![Search](https://github.com/user-attachments/assets/eb671def-866f-425c-bdb3-7de033df9b2e) |
| Home | ![Dashboard Bawah](https://github.com/user-attachments/assets/bd150707-0a05-4a34-a357-3875f25ed888) |
| Profil Dummy | ![Profil](https://github.com/user-attachments/assets/49f5ce46-9782-4ff3-9c1f-9b2facdb1877) |
