core.data_upload.act.init_proj_record <- function(dbpath) {
  
  if (is.null(dbpath)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if (!('proj_records' %in% DBI::dbListTables(con))) {
    
    fields <- c('TEXT', 'TEXT', 'TEXT')
    names(fields) <- c('PROJ_ID', 'NAME_', 'CREATED_DATE')
    
    DBI::dbCreateTable(con, 'proj_records', fields)
    
  }
  
  DBI::dbDisconnect(con)
  
}




core.data_upload.act.init_data_record <- function(dbpath) {
  
  if (is.null(dbpath)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if (!('data_records' %in% DBI::dbListTables(con))) {
    
    fields <- c('TEXT',
                'TEXT', 'TEXT',
                'TEXT',
                'TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT',
                'INTEGER', 'INTEGER', 'TEXT')
    names(fields) <- c('PROJ_ID',
                       'DATA_ID', 'NAME_',
                       'SPEC_',
                       'DESC_', 'CREATED_DATE', 'GROUP_', 'LIB_PLTF', 'LIB_TYPE', 'SEQ_PLTF',
                       'CELL_COUNT', 'FEA_COUNT', 'DATAPATH')
    
    DBI::dbCreateTable(con, 'data_records', fields)
    
  }
  
  DBI::dbDisconnect(con)
  
}




core.data_upload.act.init_grp_record <- function(dbpath) {
  
  if (is.null(dbpath)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if (!('grp_records' %in% DBI::dbListTables(con))) {

    fields <- c('TEXT', 'TEXT', 'TEXT', 'TEXT', 'TEXT', 'INTEGER', 'TEXT')
    names(fields) <- c('PROJ_ID', 'DATA_ID',
                       'GRP_ID', 'GRP_TYPE', 'GRP_NAME', 'CELL_COUNT', 'DATAPATH')

    DBI::dbCreateTable(con, 'grp_records', fields)

  }
  
  DBI::dbDisconnect(con)
  
}