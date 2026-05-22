# physiology_data_processing.R
# R script for processing and cleaning crop physiology data

library(dplyr)
library(tidyr)
library(readr)

#' Process LI-COR Gas Exchange Data
#' 
#' This function reads a typical gas exchange output file, filters for 
#' steady-state measurements, and selects key columns.
#'
#' @param file_path Path to the data file.
#' @param filter_status If TRUE, filters for records where status indicates stability (depends on machine).
#'
#' @return A cleaned data frame.
process_licor_data <- function(file_path, filter_status = TRUE) {
  # Note: LI-COR 6800 files often have header rows to skip. Adjust `skip` as needed.
  # This is a generic framework.
  
  # Try reading - this assumes CSV format, but can be adapted for Excel
  raw_data <- tryCatch({
    read_csv(file_path, comment = "#", show_col_types = FALSE)
  }, error = function(e) {
    message("Could not read as simple CSV. You may need to specify skip rows or use readxl.")
    return(NULL)
  })
  
  if (is.null(raw_data)) return(NULL)
  
  clean_data <- raw_data %>%
    # Select common physiology parameters (A, gs, Ci, E)
    select(any_of(c("obs", "time", "A", "gsw", "Ci", "E", "VPDleaf", "Tleaf", "PARi"))) %>%
    # Remove rows where A (photosynthesis) is NA
    filter(!is.na(A))
  
  # Basic outlier removal (example: A should usually be between -5 and 50)
  clean_data <- clean_data %>%
    filter(A > -5 & A < 60)
  
  return(clean_data)
}

#' Calculate Water Use Efficiency
#'
#' @param data A data frame containing photosynthesis (A) and transpiration (E) or stomatal conductance (gsw).
#' @param a_col Name of the column for Assimilation (A).
#' @param water_col Name of the column for water loss (E or gsw).
#' @param type "intrinsic" (A/gsw) or "instantaneous" (A/E).
#'
#' @return The data frame with a new WUE column.
calculate_wue <- function(data, a_col = "A", water_col = "gsw", type = "intrinsic") {
  
  if (!(a_col %in% names(data)) | !(water_col %in% names(data))) {
    stop("Specified columns not found in data.")
  }
  
  if (type == "intrinsic") {
    data <- data %>% mutate(iWUE = !!sym(a_col) / !!sym(water_col))
  } else if (type == "instantaneous") {
    data <- data %>% mutate(WUE = !!sym(a_col) / !!sym(water_col))
  } else {
    stop("Type must be 'intrinsic' or 'instantaneous'")
  }
  
  return(data)
}
