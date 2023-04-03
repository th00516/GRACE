core.data_filtering.plt.cell_umi.drp <- function(D, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dat <- D[, order(D$var$nCount, decreasing = T)]
  
  dt <- data.frame(Cell = log10(1:dat$n_vars), 
                   UMI.Count = log10(dat$var$nCount), 
                   Group = dat$var$SingletOrDoublet,
                   row.names = dat$var_names)
  
  
  fig <- plot_ly() %>%
    
    add_trace(name = 'Doublet',
              data = dt[dt$Group == 'Doublet',],
              x = ~Cell,
              y = ~UMI.Count,
              type = 'scattergl', mode = 'markers',
              marker = list(color = 'lightgray'),
              showlegend = T,
              hoverinfo = 'text',
              hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Doublet',]),
                                 '</br> UMI Count: ', sprintf('%.2f', UMI.Count))) %>%
    
    add_trace(name = 'Singlet',
              data = dt[dt$Group == 'Singlet',], 
              x = ~Cell, 
              y = ~UMI.Count, 
              type = 'scattergl', mode = 'markers',
              marker = list(color = 'orange'),
              showlegend = T,
              hoverinfo = 'text',
              hovertext = ~paste('</br> Cell: ', rownames(dt[dt$Group == 'Singlet',]),
                                 '</br> UMI Count (log10): ', sprintf('%.2f', UMI.Count)))
  
  fig <- fig %>% config(displayModeBar = F)
  
  
  return(fig)
  
}




core.data_filtering.plt.feature_umi.sct <- function(D, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dt <- data.frame(nFeature = D$var$nFeature, 
                   nCount = D$var$nCount,
                   row.names = D$var_names)
  
  
  fig <- plot_ly(data = dt, 
                 x = ~nFeature, 
                 y = ~nCount,
                 type = 'scattergl', mode = 'markers',
                 showlegend = F,
                 hoverinfo = 'text',
                 hovertext = ~paste('</br> Cell: ', rownames(dt),
                                    '</br> Feature Count: ', sprintf('%d', nFeature),
                                    '</br> UMI Count: ', sprintf('%d', nCount)))
  
  fig <- fig %>% config(displayModeBar = F)
  
  
  return(fig)
  
}




core.data_filtering.plt.feature_umi.hst <- function(D, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dt <- data.frame(Freq. = c(D$var$nFeature, D$var$nCount), 
                   Group = c(rep('Prop. of Feature', length(D$var$nFeature)), 
                             rep('Prop. of UMI', length(D$var$nCount))))
  
  
  fig <- plot_ly(data = dt, 
                 x = ~Freq., 
                 color = ~Group, 
                 type = 'histogram', histnorm = 'percent',
                 showlegend = T,
                 hovertemplate = '</br>Count: %{x}</br>Freq.: %{y:.2f}')
  
  fig <- fig %>% config(displayModeBar = F)
  
  
  return(fig)
  
}




core.data_filtering.plt.feature.vln <- function(D, feature, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dt <- data.frame(Freq. = D$var[[feature]])
  
  
  fig <- plot_ly(data = dt, 
                 y = ~Freq.,
                 type = 'violin', points = F, spanmode = 'hard',
                 showlegend = F,
                 hoverinfo = 'y',
                 name = feature)
    
  fig <- fig %>% config(displayModeBar = F)
  
  
  return(fig)
  
}
