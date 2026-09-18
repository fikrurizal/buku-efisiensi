# Dimuat oleh chunk tersembunyi di awal Bab III-VI.
# - Opsi tampilan knitr/ggplot/flextable untuk edisi daring.
# - Direktori kerja chunk diarahkan ke folder data/, sehingga kode buku
#   read_csv("hospital.csv") berjalan persis seperti yang dicetak.

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
