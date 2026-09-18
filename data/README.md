# Asal dan penggunaan data

## hospital.csv: data penelitian yang diolah untuk pelatihan

Menurut konfirmasi Firdaus Hafidz pada 18 September 2026, `hospital.csv` berasal dari data penelitian asli yang telah diolah oleh penulis agar siap digunakan untuk pelatihan. Penulis mengizinkan distribusi ulang berkas ini dan pembuatan adaptasi pembelajaran. Pernyataan ini berlaku untuk dataset pelatihan yang dibagikan, bukan akses terhadap data mentah lain atau hak untuk mengidentifikasi fasilitas.

Berkas dasar dipertahankan tanpa perubahan dalam pembaruan ini. Angka dalam berkas pelatihan tidak boleh langsung diperlakukan sebagai gambaran kinerja rumah sakit saat ini. Rincian periode penelitian, transformasi sebelumnya, definisi satuan, dan kamus variabel perlu dilengkapi dari dokumentasi penelitian; nama kolom saja tidak cukup untuk memastikan definisinya.

## Dataset sintetis dan turunan

Semua berkas bernama `*-sintetis.csv` merupakan data buatan, bukan pengamatan fasilitas yang sebenarnya. Script `R/advanced_cases.R` membuat contoh dengan seed tetap dan menyimpan hasil ke `results/`. Contoh ini digunakan untuk mengajarkan metode, bukan mereplikasi hasil empiris artikel.

Jika data asli disederhanakan, simpan sebagai berkas baru dan dokumentasikan baris/kolom yang diubah beserta alasannya. Jika variabel dummy ditambahkan pada data asli, gunakan nama berkas `hospital-pembelajaran-campuran.csv`, beri akhiran `_sim` pada kolom simulasi, dan sertakan kamus variabel yang menyebutkan sumber, satuan, rumus pembangkitan, dan seed. Data tersebut adalah **campuran data penelitian dan simulasi**, bukan data penelitian asli sepenuhnya.

Hubungan antara variabel dummy dan input/output yang sengaja dibentuk untuk latihan tidak merupakan bukti empiris atau hubungan kausal. Jangan mengganti nilai yang tampak aneh sebelum memeriksa satuan, definisi, dan alasan ilmiahnya. Analisis sensitivitas lebih tepat daripada mengubah angka semata-mata agar hasil terlihat baik.
