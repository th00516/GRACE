core.ddrtree_analysis.plt.cluster_heatmap <- function(D, C_type, value, reduction, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  if (is.null(D$varm[[reduction]])) {return(NULL)}
  
  
  dt <- data.frame(x = D$varm[[reduction]][, 1],
                   y = D$varm[[reduction]][, 2],
                   Val = D$var[[value]],
                   Cluster = D$var[[C_type]],
                   row.names = D$var_names)
  
  
  fig <- plot_ly() %>%
    
    add_trace(data = dt,
              x = ~x,
              y = ~y,
              type = 'scattergl', mode = 'markers',
              marker = list(color = ~Val,
                            colorscale = 'Viridis',
                            showscale = T),
              opacity = 0.6,
              showlegend = F,
              hoverinfo = 'text',
              hovertext = ~paste('</br> Cell: ', rownames(dt),
                                 '</br> Cluster: ', Cluster,
                                 '</br> Exp.: ', Val))
  
  
  return(fig)
  
}
