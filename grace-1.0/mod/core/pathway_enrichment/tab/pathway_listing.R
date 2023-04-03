core.pathway_enrichment.tab.pathway_listing <- function(D, disp) {
  
  if (is.null(disp)) (return(NULL))
  
  
  D <- D[, D$var$isUsed]
  
  
  if (length(grep('^GO:', colnames(D$var))) == 0) {return(NULL)}
  if (is.null(D$uns$GO_score.top10)) (return(NULL))
  
  
  GO <- colnames(D$var)[grep('^GO:', colnames(D$var))]
  
  GO.score <- strsplit(unlist(D$uns$GO_score.top10), ',')
  GO.score <- t(matrix(unlist(GO.score), nrow = 2))

  dt <- data.frame('SCORE' = sprintf('%.2f', as.numeric(GO.score[, 1])),
                   'Q' = sprintf('%.4f', as.numeric(GO.score[, 2])),
                   row.names = GO)
  
  
  tab <- datatable(dt, selection = 'single', options = list(dom = 'tp'))
  
  
  return(tab)
  
}