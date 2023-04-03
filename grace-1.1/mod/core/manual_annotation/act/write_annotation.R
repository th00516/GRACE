core.manual_annotation.act.write_annotation <- function(dbpath, data.id, D, C_type, current_manual_annotation) {
  
  D <- D[, D$var$isUsed]
  
  
  D$var$clusters.ann.manual <- D$var[[C_type]]
  levels(D$var$clusters.ann.manual) <- current_manual_annotation
  
  
  withProgress({

    incProgress(0.3, message = 'Data Extracting')


    con <- dbConnect(RSQLite::SQLite(), dbpath)

    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
    )

    dbDisconnect(con)


    D$write_h5ad(path$DATAPATH)
    
    
    
    
    incProgress(1.0, message = 'Finished')

  })
  
}