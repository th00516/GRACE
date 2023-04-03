#### GLOBAL OPTION ####
options(shiny.maxRequestSize = 100 * 1024 ^ 3)
####




core.defined_subcluster.act.import_data.h5ad <- function(dbpath, proj.id, data.id, grp.id) {
  
  if (is.null(proj.id)) {return(NULL)}
  if (is.null(data.id)) {return(NULL)}
  if (is.null(grp.id)) {return(NULL)}
  
  
  withProgress({
    
    incProgress(0.0)
    
    
    con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
    
    if ('grp_records' %in% DBI::dbListTables(con)) {
    
      datapath <- DBI::dbGetQuery(
        con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
      )
      
      
      
      
      incProgress(0.3)
      
      
      if (length(datapath$DATAPATH) == 0) {return(NULL)}
      
      D <- anndata::read_h5ad(datapath$DATAPATH)
      
      dat <- D[, D$var$isUsed]
      
      
      
      
      incProgress(1.0)
      
      
      return(dat)
      
    }
    
    DBI::dbDisconnect(con)
    
  })
  
}