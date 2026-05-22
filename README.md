# Crop Physiology R Workflows

![R Version](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg?logo=R)
![Status](https://img.shields.io/badge/Status-Active-success)

This repository contains reusable, reproducible R workflows designed for crop physiology, horticultural research, and sustainable specialty crop production.

The goal is to provide standardized scripts for analyzing physiological data (e.g., gas exchange, chlorophyll fluorescence, spectral indices) and generating publication-quality figures using robust statistical techniques like mixed-effects models.

## 📂 Repository Structure
- **`R/`**: Contains core functions for data analysis and visualization.
- **`docs/`**: Documentation and guides.
- **`data/`**: Directory meant to store raw or processed dataset files.

## 🚀 Getting Started
1. Clone the repository to your local machine.
2. Place your raw data into the `data/` folder.
3. Open an R script or RMarkdown file and source the functions from the `R/` folder.
File 2: R/mixed_model_analysis.R

# R script for linear mixed model analysis of crop physiology data
library(lme4)
library(lmerTest)
library(emmeans)
library(multcomp)

analyze_physiology_trait <- function(data, response, fixed_effects, random_effects, compare_by) {
  formula_str <- paste(response, "~", fixed_effects, "+", random_effects)
  model <- lmer(as.formula(formula_str), data = data)
  
  anova_res <- anova(model)
  emm_formula <- as.formula(paste("~", compare_by))
  emm <- emmeans(model, specs = emm_formula)
  cld_res <- cld(emm, Letters = letters, reversed = TRUE, adjust = "tukey")
  
  return(list(model = model, anova = anova_res, emmeans = emm, cld = cld_res))
}
File 3: R/data_visualization.R

# R script for generating publication-quality figures for crop physiology data
library(ggplot2)

theme_scientific <- function(base_size = 14) {
  theme_bw(base_size = base_size) %+replace%
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
      axis.text = element_text(color = "black"),
      legend.position = "bottom"
    )
}
theme_set(theme_scientific())

plot_emmeans_cld <- function(cld_data, x_var, y_var = "emmean", error_var = "SE", letter_var = ".group") {
  cld_data[[letter_var]] <- trimws(cld_data[[letter_var]])
  ggplot(cld_data, aes_string(x = x_var, y = y_var)) +
    geom_bar(stat = "identity", fill = "steelblue", color = "black", width = 0.7) +
    geom_errorbar(aes_string(ymin = paste0(y_var, " - ", error_var), ymax = paste0(y_var, " + ", error_var)), width = 0.2) +
    geom_text(aes_string(y = paste0(y_var, " + ", error_var), label = letter_var), vjust = -0.5)
}
File 4: R/physiology_data_processing.R

# R script for processing and cleaning crop physiology data
library(dplyr)
library(readr)

process_licor_data <- function(file_path) {
  raw_data <- read_csv(file_path, comment = "#", show_col_types = FALSE)
  clean_data <- raw_data %>%
    select(any_of(c("obs", "time", "A", "gsw", "Ci", "E", "VPDleaf", "Tleaf"))) %>%
    filter(!is.na(A)) %>%
    filter(A > -5 & A < 60)
  return(clean_data)
}
