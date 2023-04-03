core.subcluster_manual_annotation.tab.cluster_listing <- function(D, C_type, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (!is.null(D$var[[C_type]])) {
    
    dt <- data.frame(Subcluster = levels(D$var[[C_type]]),
                     Cell.Count = as.vector(table(D$var[[C_type]])))
    
    
    tab <- datatable(dt, selection = 'single', options = list(dom = 'ftp'))
    
    
    return(tab)
    
  }
  
}