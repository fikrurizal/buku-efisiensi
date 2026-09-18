# Analisis Efisiensi Fasilitas Kesehatan: Aplikasi Menggunakan Software R

Firdaus Hafidz dan Muhammad Fikru Rizal

Edisi daring dari buku terbitan UGM Press (2021), dibangun dengan
[Quarto](https://quarto.org) dan diterbitkan melalui GitHub Pages:
<https://fikrurizal.github.io/buku-efisiensi/>

## Struktur

| Berkas/folder | Isi |
|---|---|
| `index.qmd`, `kata-pengantar.qmd`, `00-petunjuk.qmd`, `00-glosarium.qmd` | Bagian awal buku, petunjuk, glosarium, dan singkatan |
| `chapters/` | Bab I–VIII; kode R pada Bab III–VI dijalankan saat buku dibangun |
| `daftar-pustaka.qmd`, `tentang-penulis.qmd` | Bagian akhir buku |
| `R/setup.R` | Opsi tampilan untuk bab berkode (dimuat oleh chunk tersembunyi) |
| `data/hospital.csv` | Dataset latihan (198 rumah sakit) |
| `images/` | Gambar statis dari edisi cetak (diagram, tangkapan layar RStudio) |
| `_freeze/` | Hasil eksekusi kode R yang dibekukan (di-*commit*) |

Naskah dikonversi dari PDF final edisi cetak dengan skrip di `_sources/`
(folder ini tidak ikut di-*commit*). Bab-bab di `chapters/` kini menjadi sumber
utama; suntinglah langsung berkas `.qmd`.

## Data

Dataset latihan yang dipakai pada Bab III–VI adalah
[`data/hospital.csv`](data/hospital.csv). Kode contoh membacanya langsung dari
URL raw GitHub berikut, sehingga tetap dapat dijalankan setelah disalin ke
*R script* di luar folder proyek:

```text
https://raw.githubusercontent.com/fikrurizal/buku-efisiensi/main/data/hospital.csv
```

Saat buku dirender, file yang sama juga tetap menjadi sumber daya proyek
(`data/hospital.csv`). Tidak ada data eksternal yang harus diunduh secara
manual: Bab VI memakai `charnes1981` dari paket **Benchmarking** dan `milkProd`
dari paket **frontier**; data contoh lain dibuat langsung di dalam kode.

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
