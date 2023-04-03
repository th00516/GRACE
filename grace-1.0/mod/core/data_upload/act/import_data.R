#### GLOBAL OPTION ####
options(shiny.maxRequestSize = 100 * 1024 ^ 3)
####




core.data_upload.act.import_data.h5ad <- function(dbpath, proj.id, data.id) {
  
  if (is.null(proj.id)) {return(NULL)}
  if (is.null(data.id)) {return(NULL)}
  
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
    
    if ('data_records' %in% DBI::dbListTables(con)) {
    
      datapath <- DBI::dbGetQuery(
        con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
      )
      
      
      
      
      incProgress(0.1, message = 'Reading')
      
      
      if (length(datapath$DATAPATH) == 0) {return(NULL)}
      
      D <- anndata::read_h5ad(datapath$DATAPATH)
      
      dat <- D[, D$var$isUsed]
      
      
      
      
      incProgress(1.0, message = 'Finished')
      
      
      return(dat)
    
    }
    
    DBI::dbDisconnect(con)
    
  })
  
}