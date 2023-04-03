core.cell_cycle.plt.cluster <- function(D, sampled_set, C_type, F_idx, reduction, disp) {
  
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
  
  dt$Cluster <- dat$var[[C_type]]
  
  if (F_idx == 'Score of G2M & S Phase') {
    
    dt$Val.g2m <- dat$var$G2M.score
    dt$Val.s <- dat$var$S.score
    
    
    fig <- plot_ly() %>%
      
      add_trace(data = dt[dt$Cluster == 'G2M',],
                x = ~x,
                y = ~y,
                type = 'scattergl', mode = 'markers',
                marker = list(color = ~Val.g2m,
                              colorscale = 'Reds',
                              showscale = F),
                showlegend = F,
                hoverinfo = 'text',
                hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Cluster == 'G2M',]),
                                   '</br> Cluster: ', Cluster,
                                   '</br> Exp.: ', Val.g2m)) %>%
      
      add_trace(data = dt[dt$Cluster == 'S',],
                x = ~x,
                y = ~y,
                type = 'scattergl', mode = 'markers',
                marker = list(color = ~Val.s,
                              colorscale = 'Blues',
                              showscale = F),
                showlegend = F,
                hoverinfo = 'text',
                hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Cluster == 'S',]),
                                   '</br> Cluster: ', Cluster,
                                   '</br> Exp.: ', Val.s))
    
    
    return(fig)
    
  } else {
    
    dt$Val <- rep(0, dat$n_vars)
    
    
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
  
}