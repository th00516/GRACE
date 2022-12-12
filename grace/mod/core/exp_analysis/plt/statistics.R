core.exp_analysis.plt.statistics.exp_dist <- function(D, C_type, F_idx, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (!is.null(F_idx)) {
    
    if (!is.null(D$var[[C_type]])) {
      
      dt <- data.frame(Freq. = D$X[D$obs_names[F_idx],],
                       Cluster = D$var[[C_type]])
      
      
      fig <- plot_ly(data = dt,
                     x = ~Cluster,
                     y = ~Freq.,
                     color = ~Cluster,
                     type = 'violin', points = F, spanmode = 'hard',
                     showlegend = F,
                     hoverinfo = 'y')
      
      fig <- fig %>% config(displayModeBar = F)
      
      
      return(fig)
      
    }
    
  }
  
}
