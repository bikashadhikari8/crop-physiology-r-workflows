# Crop Physiology R Workflows

![R Version](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg?logo=R)
![Status](https://img.shields.io/badge/Status-Active-success)

This repository contains reusable, reproducible R workflows designed for crop physiology, horticultural research, and sustainable specialty crop production.

The goal is to provide standardized scripts for analyzing physiological data (e.g., gas exchange, chlorophyll fluorescence, spectral indices) and generating publication-quality figures using robust statistical techniques like mixed-effects models.

## 📂 Repository Structure

- **`R/`**: Contains core functions for data analysis and visualization.
  - `physiology_data_processing.R`: Functions for tidying raw data from instruments (like LI-COR).
  - `mixed_model_analysis.R`: Wrapper functions for Linear Mixed Models (`lme4`), ANOVA, and post-hoc pairwise comparisons (`emmeans`, `multcomp`).
  - `data_visualization.R`: Custom `ggplot2` themes and functions for creating scientific bar charts (with significance letters) and stress response curves.
- **`docs/`**: Documentation and guides.
  - `workflow_guide.md`: A detailed guide on how to string these scripts together for a complete analysis pipeline.
- **`data/`**: Directory meant to store raw or processed dataset files (ignored in version control by default).

## 🛠️ Prerequisites

To use these scripts, you will need R installed along with the following packages:

```R
install.packages(c("tidyverse", "lme4", "lmerTest", "emmeans", "multcomp"))
```

## 🚀 Getting Started

1. Clone the repository to your local machine.
2. Place your raw data into the `data/` folder.
3. Open an R script or RMarkdown file.
4. Source the necessary workflow functions:
   ```R
   source("R/physiology_data_processing.R")
   source("R/mixed_model_analysis.R")
   source("R/data_visualization.R")
   ```
5. Follow the [Workflow Guide](docs/workflow_guide.md) for step-by-step instructions.

## 👨‍🔬 About the Author

**Bikash Adhikari** is a plant stress physiologist and horticultural scientist focusing on how crops respond to environmental and management stresses. 

- **Connect:** [@bikashadhikari8](https://github.com/bikashadhikari8)
- **Email:** bikashadhikari8@gmail.com
