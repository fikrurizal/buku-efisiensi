# Dipanggil di awal setiap bab praktikum: memuat package dan dataset rumah sakit
# yang sudah diberi label. Setiap bab Quarto dijalankan pada sesi R terpisah,
# sehingga data perlu dimuat ulang di setiap bab.

suppressPackageStartupMessages({
  library(tidyverse)
  library(labelled)
  library(gtsummary)
  library(flextable)
  library(modelsummary)
})

knitr::opts_chunk$set(comment = "#>", fig.align = "center", out.width = "85%")
theme_set(theme_minimal(base_size = 12))
set_flextable_defaults(font.size = 10, padding = 3)

# Path relatif terhadap root proyek (_quarto.yml: execute-dir: project)
load_hospital <- function(path = "data/hospital.csv") {
  read_csv(path, show_col_types = FALSE) |>
    set_variable_labels(
      id_rs = "ID Rumah Sakit",
      gp_FTE = "Jumlah Dokter Umum",
      spec_FTE = "Jumlah Dokter Spesialis",
      nurse_total = "Jumlah Perawat",
      other_prof = "Jumlah Karyawan Lain",
      beds = "Jumlah Bed",
      outpatients = "Jumlah Kunjungan Rajal",
      bed_days = "Total Bed Days",
      admissions1 = "Jumlah Admisi",
      bed_occ = "Bed Occupancy",
      throughput = "Throughput",
      alos = "Average Length of Stay",
      totalcost_op = "Total Biaya Rajal",
      total_cost_bd = "Total Biaya Bed Days",
      totalcost_ip = "Total Biaya Ranap",
      publichospital = "Kepemilikan",
      poorins = "Proporsi Jamkesmas",
      classCD = "Kelas",
      non_JavaBali = "Regional"
    ) |>
    set_value_labels(
      publichospital = c("Pemerintah" = 1, "Swasta" = 0),
      classCD = c("Kelas C/D" = 1, "Kelas A/B" = 0),
      non_JavaBali = c("Non Jawa-Bali" = 1, "Jawa-Bali" = 0)
    ) |>
    to_factor()
}
