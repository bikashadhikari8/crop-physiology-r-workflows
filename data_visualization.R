# data_visualization.R
# R script for generating publication-quality figures for crop physiology data

library(ggplot2)
library(dplyr)
library(tidyr)

# Set a custom clean theme for scientific publications
theme_scientific <- function(base_size = 14) {
  theme_bw(base_size = base_size) %+replace%
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
      axis.text = element_text(color = "black"),
      axis.title = element_text(face = "bold"),
      legend.position = "bottom",
      legend.title = element_text(face = "bold"),
      strip.background = element_rect(fill = "grey90", color = "black"),
      strip.text = element_text(face = "bold")
    )
}

# Set the theme as default
theme_set(theme_scientific())

#' Plot Estimated Marginal Means with Compact Letter Display
#'
#' @param cld_data The data frame resulting from `multcomp::cld()`.
#' @param x_var String specifying the variable on the x-axis (e.g., "Treatment").
#' @param y_var String specifying the response variable (e.g., "emmean").
#' @param error_var String specifying the standard error variable (e.g., "SE").
#' @param letter_var String specifying the column containing the CLD letters (e.g., ".group").
#' @param y_label String for the y-axis label.
#' @param fill_var Optional string for a variable to map to fill color.
#'
#' @return A ggplot object.
plot_emmeans_cld <- function(cld_data, x_var, y_var = "emmean", error_var = "SE", 
                             letter_var = ".group", y_label = "Trait Value", fill_var = NULL) {
  
  # Clean up whitespace in letters group
  cld_data[[letter_var]] <- trimws(cld_data[[letter_var]])
  
  p <- ggplot(cld_data, aes_string(x = x_var, y = y_var))
  
  if (!is.null(fill_var)) {
    p <- p + geom_bar(stat = "identity", aes_string(fill = fill_var), position = "dodge", color = "black", width = 0.7)
  } else {
    p <- p + geom_bar(stat = "identity", fill = "steelblue", color = "black", width = 0.7)
  }
  
  p <- p + 
    geom_errorbar(aes_string(ymin = paste0(y_var, " - ", error_var), 
                             ymax = paste0(y_var, " + ", error_var)), 
                  width = 0.2, position = position_dodge(0.7)) +
    geom_text(aes_string(y = paste0(y_var, " + ", error_var), label = letter_var), 
              vjust = -0.5, position = position_dodge(0.7), size = 5) +
    labs(x = x_var, y = y_label) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.15))) # Add space for letters
  
  return(p)
}

#' Plot Line Graph for Time-Series or Stress Response
#'
#' @param data A data frame.
#' @param x_var The time or continuous variable.
#' @param y_var The response variable.
#' @param group_var The grouping variable (e.g., "Treatment").
#' @param y_label Y-axis label.
#' @param x_label X-axis label.
#'
#' @return A ggplot object.
plot_stress_response <- function(data, x_var, y_var, group_var, y_label = "Response", x_label = "Time") {
  
  # Calculate summary statistics
  summary_df <- data %>%
    group_by(!!sym(x_var), !!sym(group_var)) %>%
    summarise(
      mean_val = mean(!!sym(y_var), na.rm = TRUE),
      se_val = sd(!!sym(y_var), na.rm = TRUE) / sqrt(n()),
      .groups = "drop"
    )
  
  p <- ggplot(summary_df, aes_string(x = x_var, y = "mean_val", color = group_var, group = group_var)) +
    geom_line(linewidth = 1) +
    geom_point(size = 3) +
    geom_errorbar(aes(ymin = mean_val - se_val, ymax = mean_val + se_val), width = 0.2) +
    labs(x = x_label, y = y_label, color = group_var) +
    scale_color_brewer(palette = "Set1")
  
  return(p)
}
