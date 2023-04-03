core.ddrtree_analysis.plt.cluster <- function(D, C_type, reduction, F_idx, switch, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (switch == 'No') {
    
    if (is.null(D$var[[C_type]])) {return(NULL)}
    if (is.null(D$varm[[reduction]])) {return(NULL)}
    
    
    dt <- data.frame(x = D$varm[[reduction]][, 1],
                     y = D$varm[[reduction]][, 2],
                     Cluster = D$var[[C_type]],
                     row.names = D$var_names)
    
    if (!is.null(F_idx)) {
      
      dt$Val <- D$X[D$obs_names[F_idx],]
      
      
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
                                colorscale = c('yellow', 'red'),
                                showscale = T),
                  showlegend = F,
                  hoverinfo = 'text',
                  hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Val > 0,]),
                                     '</br> Cluster: ', Cluster,
                                     '</br> Exp.: ', Val))
      
      
      return(fig)
      
    } else {
      
      dt$Val <- rep(0, D$n_vars)
      
      
      fig <- plot_ly() %>% 
        
        add_trace(data = dt,
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

  
  } else {
    
    if (is.null(D$var[[C_type]])) {return(NULL)}
    if (is.null(D$varm[[reduction]])) {return(NULL)}
    
    
    dt <- data.frame(x = D$varm[[reduction]][, 1],
                     y = D$varm[[reduction]][, 2],
                     Cluster = D$var[[C_type]],
                     Group = D$var$Group,
                     row.names = D$var_names)
    
    if (!is.null(F_idx)) {
      
      dt$Val <- D$X[D$obs_names[F_idx],]
      
      
      fig1 <- plot_ly() %>%
        
        add_trace(data = dt[dt$Group == 'Group 1',][dt$Val == 0,],
                  x = ~x,
                  y = ~y,
                  type = 'scattergl', mode = 'markers',
                  marker = list(color = 'lightgray'),
                  showlegend = F,
                  hoverinfo = 'text',
                  hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Group 1',][dt$Val == 0,]),
                                     '</br> Cluster: ', Cluster,
                                     '</br> Exp.: ', Val)) %>%
        
        add_trace(data = dt[dt$Group == 'Group 1',][dt$Val > 0,],
                  x = ~x,
                  y = ~y,
                  type = 'scattergl', mode = 'markers',
                  marker = list(color = ~Val,
                                colorscale = c('yellow', 'red'),
                                showscale = T),
                  showlegend = F,
                  hoverinfo = 'text',
                  hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Group 1',][dt$Val > 0,]),
                                     '</br> Cluster: ', Cluster,
                                     '</br> Exp.: ', Val))
      
      fig2 <- plot_ly() %>%
        
        add_trace(data = dt[dt$Group == 'Group 2',][dt$Val == 0,],
                  x = ~x,
                  y = ~y,
                  type = 'scattergl', mode = 'markers',
                  marker = list(color = 'lightgray'),
                  showlegend = F,
                  hoverinfo = 'text',
                  hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Group 2',][dt$Val == 0,]),
                                     '</br> Cluster: ', Cluster,
                                     '</br> Exp.: ', Val)) %>%
          
        add_trace(data = dt[dt$Group == 'Group 2',][dt$Val > 0,],
                  x = ~x,
                  y = ~y,
                  type = 'scattergl', mode = 'markers',
                  marker = list(color = ~Val,
                                colorscale = c('yellow', 'red'),
                                showscale = T),
                  showlegend = F,
                  hoverinfo = 'text',
                  hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Group 2',][dt$Val > 0,]),
                                     '</br> Cluster: ', Cluster,
                                     '</br> Exp.: ', Val))
      
      fig <- subplot(fig1, fig2, shareX = T, shareY = T)
      
      
      return(fig)
      
    } else {
      
      dt$Val <- rep(0, D$n_vars)
      
      
      fig1 <- plot_ly(data = dt[dt$Group == 'Group 1',],
                      x = ~x, 
                      y = ~y,
                      color = ~Cluster,
                      type = 'scattergl', mode = 'markers',
                      legendgroup = ~Group,
                      showlegend = T,
                      hoverinfo = 'text',
                      hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Group 1',]),
                                         '</br> Cluster: ', Cluster))
        
      fig2 <- plot_ly(data = dt[dt$Group == 'Group 2',],
                      x = ~x, 
                      y = ~y,
                      color = ~Cluster,
                      type = 'scattergl', mode = 'markers',
                      legendgroup = ~Group,
                      showlegend = T,
                      hoverinfo = 'text',
                      hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Group 2',]),
                                         '</br> Cluster: ', Cluster))
      
      fig <- subplot(fig1, fig2, shareX = T, shareY = T)
      
      
      return(fig)
      
    }
    
  }

}