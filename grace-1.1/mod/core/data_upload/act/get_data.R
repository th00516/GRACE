core.data_upload.act.get_data <- function(proj.id, data.id) {
  
  if (is.null(proj.id)) return(NULL)
  if (is.null(data.id)) return(NULL)
  
  
  handler <- NULL
  
  handler <- downloadHandler(filename = function() paste0(proj.id, '-', data.id, '.zip'),
                             content  = function(file) {
                               
                               path.base <- file.path('dbs', proj.id, data.id)
                               
                               
                               withProgress({
                               
                                 incProgress(0.2, message = 'Compressing')
                                 zip(file, c(paste0(path.base, '.h5ad'),
                                             paste0(path.base, '.running')),
                                     zip = 'zip')
                                 
                                 
                                 incProgress(1.0, message = 'Finished')
                               
                               })
                               
                             })
  
  
  return(handler)
  
}