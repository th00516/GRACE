core.data_filtering.tab.cell_counting <- function(D, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  D <- D[, D$var$isUsed]
  
  
  dt <- data.frame(Count = c(D$n_vars, D$n_obs), 
                   row.names = c('Used.Cells', 'Used.Features'))
  
  
  tab <- datatable(dt, selection = 'none', options = list(dom = ''))
  
  
  return(tab)
  
}