core.defined_subcluster.plt.statistics.exp_dist <- function(D, C_type, F_idx, switch, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (switch == 'No') {
    
    if (!is.null(F_idx)) {
      
      if (is.null(D$var[[C_type]])) {return(NULL)}
      
      
      dt <- data.frame(Freq. = D$X[D$obs_names[F_idx],],
                       Cluster = D$var[[C_type]])
      
      dt$Group <- D$var$Group
      
      
      fig <- plot_ly(data = dt,
                     x = ~Cluster,
                     y = ~Freq.,
                     color = ~Cluster,
                     type = 'violin', points = F, spanmode = 'hard',
                     showlegend = F,
                     hoverinfo = 'y')
      
      fig <- fig %>% config(displayModeBar = F)
      
      
      return(fig)
      
    } else {
      
      if (is.null(D$var[[C_type]])) {return(NULL)}
      
      
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
      
    }
    
  } else {
    
    if (!is.null(F_idx)) {
      
      if (is.null(D$var[[C_type]])) {return(NULL)}
      
      
      dt <- data.frame(Freq. = D$X[D$obs_names[F_idx],],
                       Cluster = D$var[[C_type]])
      
      dt$Group <- D$var$Group
      
      
      fig1 <- plot_ly(data = dt[dt$Group == 'Group 1',],
                      x = ~Cluster,
                      y = ~Freq.,
                      color = ~Cluster,
                      type = 'violin', points = F, spanmode = 'hard',
                      showlegend = F,
                      hoverinfo = 'y')
      
      fig2 <- plot_ly(data = dt[dt$Group == 'Group 2',],
                      x = ~Cluster,
                      y = ~Freq.,
                      color = ~Cluster,
                      type = 'violin', points = F, spanmode = 'hard',
                      showlegend = F,
                      hoverinfo = 'y')
      
      fig <- subplot(fig1, fig2, shareX = T, shareY = T) %>% layout(annotations = list(list(text = 'Group 1',
                                                                                            x = 0.25, y = 1.0,
                                                                                            xref = 'paper', yref = 'paper',
                                                                                            xanchor = 'center', yanchor = 'bottom',
                                                                                            showarrow = F),
                                                                                       list(text = 'Group 2',
                                                                                            x = 0.75, y = 1.0,
                                                                                            xref = 'paper', yref = 'paper',
                                                                                            xanchor = 'center', yanchor = 'bottom',
                                                                                            showarrow = F)))
      
      fig <- fig %>% config(displayModeBar = F)
      
      
      return(fig)
      
    } else {
      
      if (is.null(D$var[[C_type]])) {return(NULL)}
      
      
      cnt1 <- table(D[, D$var$Group == 'Group 1']$var[[C_type]])
      cnt2 <- table(D[, D$var$Group == 'Group 2']$var[[C_type]])
      
      dt1 <- data.frame(Cluster = factor(names(cnt1), 
                                         levels = levels(D$var[[C_type]])),
                        Cell.Count = as.vector(cnt1))
      
      dt2 <- data.frame(Cluster = factor(names(cnt2), 
                                         levels = levels(D$var[[C_type]])),
                        Cell.Count = as.vector(cnt2))
      
      
      fig1 <- plot_ly(data = dt1,
                      x = ~Cluster,
                      y = ~Cell.Count, 
                      color = ~Cluster, 
                      type = 'bar',
                      showlegend = F,
                      hoverinfo = 'y')
      
      fig2 <- plot_ly(data = dt2,
                      x = ~Cluster,
                      y = ~Cell.Count, 
                      color = ~Cluster, 
                      type = 'bar',
                      showlegend = F,
                      hoverinfo = 'y')
      
      fig <- subplot(fig1, fig2, shareX = T, shareY = T) %>% layout(annotations = list(list(text = 'Group 1',
                                                                                            x = 0.25, y = 1.0,
                                                                                            xref = 'paper', yref = 'paper',
                                                                                            xanchor = 'center', yanchor = 'bottom',
                                                                                            showarrow = F),
                                                                                       list(text = 'Group 2',
                                                                                            x = 0.75, y = 1.0,
                                                                                            xref = 'paper', yref = 'paper',
                                                                                            xanchor = 'center', yanchor = 'bottom',
                                                                                            showarrow = F)))
      
      fig <- fig %>% config(displayModeBar = F)
      
      
      return(fig)
      
    }
    
  }
  
}
