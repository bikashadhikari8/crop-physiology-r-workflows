# mixed_model_analysis.R
# R script for linear mixed model analysis of crop physiology data

# Load required libraries
library(lme4)
library(lmerTest)
library(emmeans)
library(multcomp)
library(dplyr)

#' Fit Linear Mixed Model and Generate Estimated Marginal Means
#'
#' @param data A data frame containing the data.
#' @param response A string specifying the response variable (e.g., "Yield", "Photosynthesis").
#' @param fixed_effects A string specifying the fixed effects formula (e.g., "Treatment * Genotype").
#' @param random_effects A string specifying the random effects formula (e.g., "(1|Block)").
#' @param compare_by A string specifying the term for pairwise comparisons (e.g., "Treatment").
#' 
#' @return A list containing the model, ANOVA table, estimated marginal means, and compact letter display.
analyze_physiology_trait <- function(data, response, fixed_effects, random_effects, compare_by) {
  
  # Ensure necessary columns are factors if needed (assumes data prep is done)
  
  # Construct formula
  formula_str <- paste(response, "~", fixed_effects, "+", random_effects)
  cat("\nFitting model:", formula_str, "\n")
  
  # Fit the model
  model <- lmer(as.formula(formula_str), data = data)
  
  # Perform ANOVA
  cat("\n--- ANOVA ---\n")
  anova_res <- anova(model)
  print(anova_res)
  
  # Calculate Estimated Marginal Means (emmeans)
  cat("\n--- Estimated Marginal Means ---\n")
  # Construct emmeans formula
  emm_formula <- as.formula(paste("~", compare_by))
  emm <- emmeans(model, specs = emm_formula)
  print(emm)
  
  # Generate Compact Letter Display (CLD) for significant differences
  cat("\n--- Pairwise Comparisons (CLD) ---\n")
  # Note: multcomp::cld is used for emmeans objects
  cld_res <- cld(emm, Letters = letters, reversed = TRUE, adjust = "tukey")
  print(cld_res)
  
  # Return a comprehensive list
  return(list(
    model = model,
    anova = anova_res,
    emmeans = emm,
    cld = cld_res
  ))
}

# Example usage (commented out):
# my_data <- data.frame(
#   Yield = rnorm(100, 50, 10),
#   Treatment = factor(rep(c("Control", "Stress"), each = 50)),
#   Genotype = factor(rep(c("A", "B"), times = 50)),
#   Block = factor(rep(1:5, times = 20))
# )
# results <- analyze_physiology_trait(
#   data = my_data, 
#   response = "Yield", 
#   fixed_effects = "Treatment * Genotype", 
#   random_effects = "(1|Block)",
#   compare_by = "Treatment"
# )
