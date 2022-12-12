core.cell_cycle.plt.statistics.exp_dist <- function(D, C_type, F_idx, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  
  
  cnt <- table(D$var[[C_type]])
  
  dt <- data.frame(Cluster = factor(names(cnt), 
                                    levels = levels(D$var[[C_type]])),
                   Cell.Ratio = as.vector(cnt) / sum(as.vector(cnt)))
  
  
  fig <- plot_ly(data = dt,
                 x = ~Cluster,
                 y = ~Cell.Ratio, 
                 color = ~Cluster, 
                 type = 'bar',
                 showlegend = F,
                 hoverinfo = 'y')
  
  fig <- fig %>% config(displayModeBar = F)
  
  
  return(fig)
  
}
