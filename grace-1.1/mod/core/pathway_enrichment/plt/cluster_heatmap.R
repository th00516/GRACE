core.pathway_enrichment.plt.cluster_heatmap <- function(D, C_type, GO_idx, reduction, disp) {
  
  if (is.null(disp)) (return(NULL))
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  if (is.null(D$varm[[reduction]])) {return(NULL)}
  
  
  dt <- data.frame(x = D$varm[[reduction]][, 1],
                   y = D$varm[[reduction]][, 2],
                   Cluster = D$var[[C_type]],
                   row.names = D$var_names)
  
  dt$Val <- if (!is.null(GO_idx)) {
    
    GO_idx <- GO_idx + min(grep('^GO:', colnames(D$var))) - 1
    
    D$var[[GO_idx]]
    
  } else {
    
    rep(0, D$n_vars)
    
  }
  

  
  fig <- plot_ly() %>%
    
    add_trace(data = dt[dt$Val == 0,],
              x = ~x,
              y = ~y,
              type = 'scattergl', mode = 'markers',
              marker = list(color = 'lightgray'),
              opacity = 0.6,
              showlegend = F,
              hoverinfo = 'text',
              hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Val == 0,]),
                                 '</br> Cluster: ', Cluster,
                                 '</br> Score: ', Val)) %>%
    
    add_trace(data = dt[dt$Val > 0,],
              x = ~x,
              y = ~y,
              type = 'scattergl', mode = 'markers',
              marker = list(color = ~Val,
                            colorscale = c('yellow', 'red'),
                            showscale = T),
              opacity = 0.6,
              showlegend = F,
              hoverinfo = 'text',
              hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Val > 0,]),
                                 '</br> Cluster: ', Cluster,
                                 '</br> Score: ', Val))
  
  
  return(fig)
  
}
