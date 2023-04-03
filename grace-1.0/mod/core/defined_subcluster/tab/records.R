core.defined_subcluster.tab.grp_records <- function(dbpath, data.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if ('grp_records' %in% DBI::dbListTables(con)) {
    
    dt <- DBI::dbGetQuery(con, paste0('SELECT DATA_ID, GRP_ID, GRP_TYPE, GRP_NAME, CELL_COUNT FROM grp_records WHERE DATA_ID == "', data.id, '"'))
    
  } else {
    
    return(NULL)
    
  }
  
  DBI::dbDisconnect(con)
  
  
  if (length(dt$DATA_ID) == 0) {return(NULL)}
  
  trans_ann_type <- c('clusters.ann.SingleR.main' = 'SingleR Main-label',
                      'clusters.ann.SingleR.fine' = 'SingleR Fine-label',
                      'predicted.clusters.ann' = 'Reference Mapped',
                      'clusters.ann.manual' = 'Manually Defined')
  
  colnames(dt) <- c('DATA.ID', 'GRP.ID', 'ANNOTATION.TYPE', 'CLUSTER.NAME', 'CELL.COUNT')
  
  dt$ANNOTATION.TYPE <- trans_ann_type[dt$ANNOTATION.TYPE]
  
  
  tab <- datatable(dt, selection = 'single', options = list(dom = 'ftp'), escape = F)
    
    
  return(tab)
  
}