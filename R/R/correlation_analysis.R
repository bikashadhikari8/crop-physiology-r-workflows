# R script for generating correlation matrices and visualizations

library(Hmisc)
library(corrplot)
library(dplyr)

plot_correlation_matrix <- function(data, numeric_cols, method = "pearson") {
  num_data <- data %>% select(all_of(numeric_cols))
  
  res <- rcorr(as.matrix(num_data), type = method)
  
  corrplot(
    res$r,
    type = "upper",
    order = "hclust",
    p.mat = res$P,
    sig.level = 0.05,
    insig = "blank",
    tl.col = "black",
    tl.srt = 45,
    title = paste(tools::toTitleCase(method), "Correlation Matrix"),
    mar = c(0, 0, 1, 0)
  )
  
  return(list(r_matrix = res$r, p_matrix = res$P))
}
