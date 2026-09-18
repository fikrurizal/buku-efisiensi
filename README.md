# Analisis Efisiensi Fasilitas Kesehatan: Aplikasi Menggunakan Software R

Firdaus Hafidz dan Muhammad Fikru Rizal

Buku daring dibangun dengan [Quarto](https://quarto.org) dan diterbitkan melalui
GitHub Pages.

## Struktur

| Folder | Isi |
|---|---|
| `chapters/` | Bab 1–7 (teori dan aplikasi), dikonversi dari naskah Word |
| `praktikum/` | Praktikum R yang dapat dijalankan |
| `R/setup.R` | Fungsi bersama untuk bab praktikum (`load_hospital()`) |
| `data/hospital.csv` | Dataset latihan (198 rumah sakit) |
| `images/draf/` | Gambar, persamaan, dan tabel dari naskah Word |
| `_freeze/` | Hasil eksekusi kode R yang dibekukan (di-*commit*) |

## Membangun buku secara lokal

Membutuhkan Quarto ≥ 1.9 dan R 4.5. *Package* R dikelola dengan `renv`.

```r
renv::restore()   # sekali saja, memasang package sesuai renv.lock
```

```sh
quarto preview    # pratinjau langsung di browser
quarto render     # membangun buku ke _book/
```

## Alur kerja

1. Sunting berkas `.qmd`.
2. Jalankan `quarto render` secara lokal. Bab yang kodenya berubah akan
   dieksekusi ulang dan hasilnya disimpan di `_freeze/`.
3. *Commit* perubahan **termasuk `_freeze/`**, lalu *push* ke `main`.
   GitHub Actions akan membangun dan menerbitkan buku tanpa menjalankan R.
