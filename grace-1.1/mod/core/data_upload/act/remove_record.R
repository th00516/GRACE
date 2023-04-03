core.data_upload.act.remove_proj <- function(dbpath, proj.id) {
  
  if (is.null(proj.id)) {return(NULL)}
  
  
  unlink(file.path(dirname(dbpath), proj.id), recursive = T)

  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  res <- DBI::dbSendQuery(con, paste0('DELETE FROM proj_records WHERE PROJ_ID == "', proj.id, '"'))
  DBI::dbClearResult(res)
  
  res <- DBI::dbSendQuery(con, paste0('DELETE FROM data_records WHERE PROJ_ID == "', proj.id, '"'))
  DBI::dbClearResult(res)
  
  res <- DBI::dbSendQuery(con, paste0('DELETE FROM grp_records WHERE PROJ_ID == "', proj.id, '"'))
  DBI::dbClearResult(res)
  
  DBI::dbDisconnect(con)
  
}




core.data_upload.act.remove_data <- function(dbpath, proj.id, data.id) {
  
  if (is.null(proj.id)) {return(NULL)}
  if (is.null(data.id)) {return(NULL)}
  
  
  unlink(file.path(dirname(dbpath), proj.id, paste0(data.id, '*.h5ad')))
  unlink(file.path(dirname(dbpath), proj.id, paste0(data.id, '*.running')), recursive = T)
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  res <- DBI::dbSendQuery(con, paste0('DELETE FROM data_records WHERE DATA_ID == "', data.id, '"'))
  DBI::dbClearResult(res)
  
  res <- DBI::dbSendQuery(con, paste0('DELETE FROM grp_records WHERE DATA_ID == "', data.id, '"'))
  DBI::dbClearResult(res)
  
  DBI::dbDisconnect(con)
  
}