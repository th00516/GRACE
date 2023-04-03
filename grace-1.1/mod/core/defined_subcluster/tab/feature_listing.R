core.defined_subcluster.tab.feature_listing <- function(D, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  dt <- data.frame(row.names = D$obs_names,
                   'Ave.Exp.' = sprintf('%.4f', D$obs$exp.mean),
                   'Exp.Ratio' = sprintf('%.4f', D$obs$exp.ratio))
  
  
  tab <- datatable(dt, selection = 'single', options = list(dom = 'ft'))
  
  
  return(tab)
  
}