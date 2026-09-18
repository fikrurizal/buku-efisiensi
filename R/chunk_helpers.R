# Helpers for the numbered, step-by-step code in the online edition.
book_begin_chapter <- function(chapter, packages = character()) {
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing)) {
    stop(
      sprintf(
        "%s belum dapat dimulai karena paket berikut belum terpasang: %s. ",
        chapter, paste(missing, collapse = ", ")
      ),
      "Jalankan renv::restore() dari akar proyek, lalu ulangi Chunk ",
      sub("Bab ", "B", chapter), ".01.",
      call. = FALSE
    )
  }
  assign(".book_chapter", chapter, envir = .GlobalEnv)
  invisible(chapter)
}

book_require <- function(chunk, objects) {
  missing <- objects[!vapply(objects, exists, logical(1), envir = .GlobalEnv,
                             inherits = FALSE)]
  if (length(missing)) {
    stop(
      sprintf(
        "Chunk %s belum dapat dijalankan karena objek '%s' belum tersedia. ",
        chunk, paste(missing, collapse = "', '")
      ),
      "Jalankan chunk prasyarat yang disebutkan tepat sebelum chunk ini, ",
      "atau jalankan ulang dari Chunk ", sub("\\..*$", ".01", chunk), ".",
      call. = FALSE
    )
  }
  invisible(TRUE)
}
