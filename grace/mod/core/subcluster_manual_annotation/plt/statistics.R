core.subcluster_manual_annotation.plt.statistics.cell_number <- function(D, C_type, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (!is.null(D$var[[C_type]])) {
    
    cnt <- table(D$var[[C_type]])
    
    dt <- data.frame(Cluster = factor(names(cnt), 
                                      levels = levels(D$var[[C_type]])),
                     Cell.Count = as.vector(cnt))
    
    
    fig <- plot_ly(data = dt,
                   x = ~Cluster,
                   y = ~Cell.Count, 
                   color = ~Cluster, 
                   type = 'bar',
                   showlegend = F,
                   hoverinfo = 'y')
    
    fig <- fig %>% config(displayModeBar = F)
    
    
    return(fig)
    
  } else {
    
    return(NULL)
    
  }
  
}
