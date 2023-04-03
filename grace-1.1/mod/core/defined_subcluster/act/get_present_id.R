core.defined_subcluster.act.get_present_grp_id <- function(dbpath, idx.p, idx.d, idx.g) {
  
  if (is.null(idx.p)) {return(NULL)}
  if (is.null(idx.d)) {return(NULL)}
  if (is.null(idx.g)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if ('grp_records' %in% DBI::dbListTables(con)) {
    
    id <- DBI::dbGetQuery(con, paste0('SELECT GRP_ID FROM grp_records WHERE DATA_ID == "', idx.d, '" LIMIT ', idx.g - 1, ',1'))
    
    
    return(id)
    
  }
  
  DBI::dbDisconnect(con)
  
}