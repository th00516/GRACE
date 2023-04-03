core.defined_subcluster.act.remove_grp <- function(dbpath, proj.id, data.id, grp.id) {
  
  if (is.null(proj.id)) {return(NULL)}
  if (is.null(data.id)) {return(NULL)}
  if (is.null(grp.id)) {return(NULL)}
  
  
  unlink(file.path(dirname(dbpath), proj.id, paste0(data.id, '.', grp.id, '.h5ad')))
  unlink(file.path(dirname(dbpath), proj.id, paste0(data.id, '.', grp.id, '.running')), recursive = T)
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  res <- DBI::dbSendQuery(con, paste0('DELETE FROM grp_records WHERE GRP_ID == "', grp.id, '"'))
  DBI::dbClearResult(res)
  
  DBI::dbDisconnect(con)
  
}