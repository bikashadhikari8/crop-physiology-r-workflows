# Workflow Guide: Crop Physiology R Analysis

This guide provides an overview of how to use the R scripts provided in this repository to process, analyze, and visualize your crop physiology data.

## 1. Data Processing (`R/physiology_data_processing.R`)

Start by cleaning your raw data files. This script contains functions designed to handle common physiological outputs, such as from LI-COR systems.

**Key functions:**
- `process_licor_data(file_path)`: Reads CSV files, selects key gas exchange variables (A, gsw, Ci, etc.), and removes obvious outliers.
- `calculate_wue(data)`: Calculates intrinsic or instantaneous water use efficiency from your dataset.

## 2. Statistical Analysis (`R/mixed_model_analysis.R`)

Once your data is clean and structured, use linear mixed models to analyze the effects of treatments across blocks or time.

**Key functions:**
- `analyze_physiology_trait(data, response, fixed_effects, random_effects, compare_by)`: 
  - Fits an `lmer` model.
  - Runs ANOVA.
  - Extracts Estimated Marginal Means (`emmeans`).
  - Generates Compact Letter Displays (CLD) for finding significant differences between groups using Tukey's HSD.

## 3. Data Visualization (`R/data_visualization.R`)

Finally, generate publication-ready plots.

**Key features:**
- `theme_scientific()`: A clean `ggplot2` theme removing background grids and adding strong axes, ideal for journals.
- `plot_emmeans_cld(cld_data, x_var)`: Automatically plots a bar chart with error bars and adds the significance letters from your analysis step on top of the bars.
- `plot_stress_response(data, x_var, y_var, group_var)`: Plots line graphs with standard error bars to show trait changes over time or stress gradients.

---
*Note: Make sure to review your data structure and adjust the function parameters (like column names) to match your specific datasets.*
