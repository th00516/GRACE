core.ref_based_annotation.plt.cluster <- function(D, sampled_set, C_type, C_idx, reduction, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dat <- D[, sampled_set]
  
  
  if (is.null(dat$var[[C_type]])) {return(NULL)}
  if (is.null(dat$varm[[reduction]])) {return(NULL)}
  
  
  dt <- data.frame(x = dat$varm[[reduction]][, 1],
                   y = dat$varm[[reduction]][, 2],
                   row.names = dat$var_names)
  
  
  if (!is.null(C_idx)) {
    
    cluster <- levels(D$var[[C_type]])[C_idx]
    
    swt <- factor(rep('Others', dat$n_vars), levels = c('Others', cluster))
    swt[dat$var[[C_type]] == cluster] <- cluster
    
    dt$Cluster <- swt
    
  } else {
    
    dt$Cluster <- dat$var[[C_type]]
    
  }
  
  
  fig <- plot_ly(data = dt, 
                 x = ~x, 
                 y = ~y,
                 color = ~Cluster,
                 type = 'scattergl', mode = 'markers',
                 showlegend = T,
                 hoverinfo = 'text',
                 hovertext = ~paste('</br> Cell: ', rownames(dt),
                                    '</br> Cluster: ', Cluster))
  
  
  return(fig)
  
}
