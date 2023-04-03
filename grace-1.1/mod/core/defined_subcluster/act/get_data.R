core.defined_subcluster.act.get_data <- function(proj.id, data.id, grp.id) {
  
  if (is.null(proj.id)) return(NULL)
  if (is.null(data.id)) return(NULL)
  if (is.null(grp.id))  return(NULL)
  
  
  handler <- NULL
  
  handler <- downloadHandler(filename = function() paste0(proj.id, '-', data.id, '.', grp.id, '.zip'),
                             content  = function(file) {
                               
                               path.base <- file.path('dbs', proj.id, data.id)
                               
                               
                               withProgress({
                               
                                 incProgress(0.2, message = 'Compressing')
                                 zip(file, c(paste0(path.base, '.', grp.id, '.h5ad'),
                                             paste0(path.base, '.', grp.id, '.running')),
                                     zip = 'zip')
                                 
                                 
                                 incProgress(1.0, message = 'Finished')
                               
                               })
                               
                             })
  
  
  return(handler)
  
}