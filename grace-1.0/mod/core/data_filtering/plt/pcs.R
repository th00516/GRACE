core.data_filtering.plt.pcs.elbow <- function(D, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dt <- D$uns$pcs_sd
  
  
  fig <- plot_ly(data = dt, 
                 x = ~PCs, 
                 y = ~SD,
                 type = 'scattergl', mode = 'markers',
                 marker = list(color = 'green'),
                 showlegend = F,
                 hoverinfo = 'text',
                 hovertext = ~paste('</br> PCs: ', sprintf('%s', PCs),
                                    '</br> SD: ', sprintf('%.2f', SD)))
  
  fig <- fig %>% config(displayModeBar = F)
  
  
  return(fig)
  
}