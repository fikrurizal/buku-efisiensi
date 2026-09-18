# Dimuat oleh chunk tersembunyi di awal Bab III-VI.
# - Opsi tampilan knitr/ggplot/flextable untuk edisi daring.
# - Direktori kerja chunk diarahkan ke folder data/ agar contoh edisi cetak
#   yang memakai berkas hospital.csv tetap kompatibel.

suppressPackageStartupMessages({
  library(tidyverse)
  library(labelled)
  library(gtsummary)
  library(flextable)
  library(modelsummary)
})

knitr::opts_chunk$set(comment = "#>", fig.align = "center", out.width = "85%",
                      message = FALSE)
knitr::opts_knit$set(root.dir = normalizePath("data"))
set_flextable_defaults(font.size = 10, padding = 3)
