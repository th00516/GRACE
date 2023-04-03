core.exp_cor_analysis.plt.correlation <- function(D, features, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (length(features) < 2) {return(NULL)}
  
  
  obj <- CreateSeuratObject(D$X)
  obj <- NormalizeData(obj)
  
  dt <- cor(log2(as.matrix(Matrix::t(obj@assays$RNA@data[features,])) + 0.000001), method = 'pearson')
  
  
  fig <- plot_ly(x = features, y = features,
                 z = dt,
                 zmax = 1, zmin = -1,
                 type = 'heatmap',
                 xgap = 1, ygap = 1,
                 showlegend = F,
                 hoverinfo = 'z',
                 name = 'Correlation')
  
  
  return(fig)
  
}