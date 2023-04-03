core.defined_subcluster.tab.cluster_listing <- function(D, C_type, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  
  
  dt <- data.frame(Subcluster = levels(D$var[[C_type]]),
                   Cell.Count = as.vector(table(D$var[[C_type]])))
  
  
  tab <- datatable(dt, selection = 'none', options = list(dom = 'ftp'))
  
  
  return(tab)
  
}