core.exp_cor_analysis.plt.statistics.exp_bub <- function(D, G_type, features, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (length(features) < 2) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[G_type]])) {return(NULL)}
  
  dt.exp <- data.frame(sapply(features, function(x) {
    
    tapply(D$X[x,], D$var[[G_type]], mean)
    
  }))
  dt.exp <- tidyr::gather(dt.exp, 'Feature')
  
  dt.ratio <- data.frame(sapply(features, function(x) {
    
    tapply(D$X[x,], D$var[[G_type]], function(y) {length(which(y > 0)) / length(y)})
    
  }))
  dt.ratio <- tidyr::gather(dt.ratio, 'Feature')
  
  dt <- data.frame(Exp.mean = dt.exp$value, Exp.ratio = dt.ratio$value)
    
  dt$Feature <- rep(features, each = length(levels(D$var[[G_type]])))
  dt$Cluster <- rep(levels(D$var[[G_type]]), length(features))
  
  
  fig <- plot_ly(data = dt, 
                 x = ~Cluster, 
                 y = ~Feature,
                 color = ~Exp.mean,
                 colors = 'Reds',
                 type = 'scatter', mode = 'markers',
                 marker = list(size = ~((Exp.ratio + 0.000001) / max(Exp.ratio + 0.000001) * 50),
                               line = list(width = 0)),
                 hoverinfo = 'text',
                 hovertext = ~paste('</br> Exp. Mean: ', sprintf('%.4f', Exp.mean),
                                    '</br> Exp. Ratio: ', sprintf('%.4f', Exp.ratio),
                                    '</br> Group: ', sprintf('%s', Cluster),
                                    '</br> Feature: ', sprintf('%s', Feature)))
  
  fig <- fig %>% config(displayModeBar = F)
  
  
  return(fig)
  
}
