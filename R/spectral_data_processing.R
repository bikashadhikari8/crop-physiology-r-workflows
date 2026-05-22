# R script for processing spectral reflectance data and calculating vegetation indices

library(dplyr)

calculate_ndvi <- function(data, nir_col = "NIR", red_col = "Red") {
  data %>%
    mutate(
      NDVI = (!!sym(nir_col) - !!sym(red_col)) /
        (!!sym(nir_col) + !!sym(red_col))
    )
}

calculate_sr <- function(data, nir_col = "NIR", red_col = "Red") {
  data %>%
    mutate(
      SR = !!sym(nir_col) / !!sym(red_col)
    )
}

batch_calculate_indices <- function(data, bands) {
  if (!all(c("NIR", "Red") %in% names(bands))) {
    stop("Bands list must contain 'NIR' and 'Red' elements.")
  }
  
  data %>%
    calculate_ndvi(nir_col = bands$NIR, red_col = bands$Red) %>%
    calculate_sr(nir_col = bands$NIR, red_col = bands$Red)
}
