core.exp_analysis.plt.cluster_heatmap <- function(D, sampled_set, C_type, F_idx, reduction, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dat <- D[, sampled_set]
  
  
  if (is.null(dat$var[[C_type]])) {return(NULL)}
  if (is.null(dat$varm[[reduction]])) {return(NULL)}
  
  
  dt <- data.frame(x = dat$varm[[reduction]][, 1],
                   y = dat$varm[[reduction]][, 2],
                   Cluster = dat$var[[C_type]],
                   row.names = dat$var_names)
  
  dt$Val <- if (is.null(F_idx)) {rep(0, dat$n_vars)} else {dat$X[dat$obs_names[F_idx],]}
  
  
  fig <- plot_ly() %>%
    
    add_trace(data = dt[dt$Val == 0,],
              x = ~x,
              y = ~y,
              type = 'scattergl', mode = 'markers',
              marker = list(color = 'lightgray'),
              showlegend = F,
              hoverinfo = 'text',
              hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Val == 0,]),
                                 '</br> Cluster: ', Cluster,
                                 '</br> Exp.: ', Val)) %>%
    
    add_trace(data = dt[dt$Val > 0,],
              x = ~x,
              y = ~y,
              type = 'scattergl', mode = 'markers',
              marker = list(color = ~Val,
                            colorscale = 'Reds',
                            showscale = T),
              showlegend = F,
              hoverinfo = 'text',
              hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Val > 0,]),
                                 '</br> Cluster: ', Cluster,
                                 '</br> Exp.: ', Val))
  
  
  return(fig)
  
}