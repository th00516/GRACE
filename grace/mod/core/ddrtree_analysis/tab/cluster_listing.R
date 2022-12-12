core.ddrtree_analysis.tab.cluster_listing <- function(D, C_type, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  
  
  dt <- data.frame(Group = levels(D$var[[C_type]]),
                   Cell.Count = as.vector(table(D$var[[C_type]])))
  
  
  tab <- datatable(dt, selection = 'none', options = list(dom = 'ftp'))
  
  
  return(tab)
  
}