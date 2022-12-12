core.pathway_enrichment.plt.statistics.bubble <- function(D, C_type, disp) {
  
  if (is.null(disp)) (return(NULL))
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  
  
  if (length(grep('^GO:', colnames(D$var))) == 0) {return(NULL)}
  if (is.null(D$uns$GO_score.top10)) (return(NULL))
  
  
  GO <- colnames(D$var)[grep('^GO:', colnames(D$var))]
  
  GO.score <- cbind(D$var[, GO], Subcluster = D$var[[C_type]])
  
  GO.score.mean <- data.frame(matrix(unlist(lapply(GO, function(x) {tapply(GO.score[[x]], GO.score[['Subcluster']], mean)})), ncol = 10))
  GO.score.sd <- data.frame(matrix(unlist(lapply(GO, function(x) {tapply(GO.score[[x]], GO.score[['Subcluster']], sd)})), ncol = 10))
  
  rownames(GO.score.mean) <- levels(GO.score$Subcluster)
  rownames(GO.score.sd) <- levels(GO.score$Subcluster)
  
  colnames(GO.score.mean) <- GO
  colnames(GO.score.sd) <- GO
  
  GO.score.mean$Subcluster <- rownames(GO.score.mean)
  GO.score.sd$Subcluster <- rownames(GO.score.sd)
  
  GO.score.mean <- tidyr::pivot_longer(GO.score.mean, -Subcluster)
  GO.score.sd <- tidyr::pivot_longer(GO.score.sd, -Subcluster)
  
  dt <- cbind(GO.score.mean, GO.score.sd$value)
  colnames(dt) <- c('Subcluster', 'GO', 'Score', 'SD')
  
  
  fig <- plot_ly(data = dt,
                 x = ~GO, 
                 y = ~Subcluster,
                 color = ~Score,
                 colors = 'Reds',
                 type = 'scatter', mode = 'markers',
                 marker = list(size = ~(-log10((SD + 0.000001) / max(SD + 0.000001)) * 20),
                               line = list(width = 0)),
                 hoverinfo = 'text',
                 hovertext = ~paste('</br> SCORE: ', sprintf('%.4f', Score),
                                    '</br> SD: ', sprintf('%s', SD)))
  
  
  return(fig)
  
}