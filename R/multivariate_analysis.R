# R script for Principal Component Analysis (PCA) and multivariate techniques

library(FactoMineR)
library(factoextra)
library(dplyr)
library(ggplot2)

perform_pca <- function(data, numeric_cols, group_col = NULL) {
  pca_data <- data %>% select(all_of(numeric_cols))
  
  pca_res <- PCA(pca_data, scale.unit = TRUE, graph = FALSE)
  
  if (!is.null(group_col) && group_col %in% names(data)) {
    p <- fviz_pca_biplot(
      pca_res,
      habillage = data[[group_col]],
      addEllipses = TRUE,
      ellipse.level = 0.95,
      repel = TRUE,
      title = "PCA Biplot of Physiological Traits"
    ) +
      theme_minimal()
  } else {
    p <- fviz_pca_biplot(
      pca_res,
      repel = TRUE,
      title = "PCA Biplot of Physiological Traits"
    ) +
      theme_minimal()
  }
  
  return(list(model = pca_res, plot = p))
}
