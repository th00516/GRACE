core.data_upload.act.get_present_proj_id <- function(dbpath, idx.p) {
  
  if (is.null(idx.p)) {return(NULL)}
  
    
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if ('proj_records' %in% DBI::dbListTables(con)) {
    
    id <- DBI::dbGetQuery(con, paste0('SELECT PROJ_ID FROM proj_records LIMIT ', idx.p - 1, ',1'))
    
    
    return(id)
    
  }
  
  DBI::dbDisconnect(con)
  
}




core.data_upload.act.get_present_data_id <- function(dbpath, idx.p, idx.d) {
  
  if (is.null(idx.p)) {return(NULL)}
  if (is.null(idx.d)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if ('data_records' %in% DBI::dbListTables(con)) {
    
    id <- DBI::dbGetQuery(con, paste0('SELECT DATA_ID FROM data_records WHERE PROJ_ID == "', idx.p, '" LIMIT ', idx.d - 1, ',1'))
    
    
    return(id)
    
  }
  
  DBI::dbDisconnect(con)
  
}