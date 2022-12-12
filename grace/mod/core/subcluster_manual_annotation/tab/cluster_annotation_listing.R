core.subcluster_manual_annotation.tab.cluster_annotation_listing <- function(D, C_type, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(C_type)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  
  
  dt <- data.frame(Raw.Cluster.Name = levels(D$var[[C_type]]),
                   New.Cluster.Name = '')
  
  
  tab <- datatable(dt, selection = 'none', options = list(dom = 'tp'),
                   editable = list(target = 'cell', disable = list(columns = c(0))),
                   rownames = F)
  
  
  return(tab)
  
}