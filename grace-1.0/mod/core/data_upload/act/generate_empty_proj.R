core.data_upload.act.generate_empty_proj <- function(dbpath, name.p) {
  
  if (name.p != '') {
    
    id <- id <- paste0(sprintf('%05X', as.integer(format(Sys.time(), '%y%m%d'))),
                       sprintf('%05X', as.integer(format(Sys.time(), '%H%M%S'))))
    
    
    proj.id <- paste0('\'', 'P', id, '\'')
    name. <- paste0('\'', name.p, '\'')
    created.date <- paste0('\'', format(Sys.time(), '%y-%m-%d'), '\'')
    
    records <- paste(proj.id, name., created.date, sep = ',')
    
    
    con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
    
    res <- DBI::dbSendQuery(con, paste0('INSERT INTO ',
                                        'proj_records(PROJ_ID, NAME_, CREATED_DATE) ',
                                        paste0('VALUES(', records, ')')))
    
    DBI::dbClearResult(res)
    
    DBI::dbDisconnect(con)
    
    
    dir.create(file.path(dirname(dbpath), paste0('P', id)))
    
  }
  
}