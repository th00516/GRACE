core.data_upload.tab.proj_records <- function(dbpath) {
  
  if (is.null(dbpath)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if ('proj_records' %in% DBI::dbListTables(con)) {
    
    dt <- DBI::dbGetQuery(con, 'SELECT PROJ_ID, NAME_, CREATED_DATE FROM proj_records')
    
  }
  
  DBI::dbDisconnect(con)
  
  
  colnames(dt) <- c('PROJ.ID', 'NAME', 'CREATED.DATE')
  
  tab <- datatable(dt, selection = 'single', options = list(dom = 'tp'), escape = F)
  
  
  return(tab)
  
}




core.data_upload.tab.data_records <- function(dbpath, proj.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  if (is.null(proj.id)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
    
  if ('data_records' %in% DBI::dbListTables(con)) {
    
    dt <- DBI::dbGetQuery(
      con, paste0('SELECT DATA_ID, NAME_, GROUP_, CELL_COUNT FROM data_records WHERE PROJ_ID == "', proj.id, '"')
    )
    
  }
    
  DBI::dbDisconnect(con)
  
  
  colnames(dt) <- c('DATA.ID', 'NAME', 'GROUP', 'CELL.COUNT')
  
  tab <- datatable(dt, selection = 'single', options = list(dom = 'ftp'), escape = F)
  
  
  return(tab)
  
}




core.data_upload.tab.data_records_detail <- function(dbpath, data.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if ('data_records' %in% DBI::dbListTables(con)) {
    
    dt <- DBI::dbGetQuery(con, paste0('SELECT * FROM data_records WHERE DATA_ID == "', data.id, '"'))
    
  }
  
  DBI::dbDisconnect(con)
  
  
  colnames(dt) <- c('PROJ.ID', 
                    'DATA.ID', 'NAME',
                    'SPECIES',
                    'DESC', 'CREATED.DATE', 'GROUP', 'LIBRARY.PLATFORM', 'LIBRARY.TYPE', 'SEQUENCING.PLATFORM', 
                    'CELL.COUNT', 'FEATURE.COUNT', 'DATAPATH')
  
  dt <- dt[, c('PROJ.ID', 'DATA.ID', 'NAME', 'SPECIES', 'DESC', 'CREATED.DATE', 'GROUP', 'CELL.COUNT', 'FEATURE.COUNT', 'DATAPATH')]
  
  dt <- t(dt)
  colnames(dt) <- 'Value'
  
  tab <- datatable(dt, selection = 'none', options = list(dom = 'ftp'), escape = F)
  
  
  return(tab)
  
}