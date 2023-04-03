core.denovo_annotation.act.annotate_cell <- function(dbpath, data.id, D, file_path, switch1, switch2) {
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    D <- D[, D$var$isUsed]
    
    
    group_type <- D$var[[switch1]]

    ref <- if (!is.null(file_path)) {
      
      readRDS(file_path)
      
    } else if (switch2 == 'Human Primary Cell Atlas') {

      readRDS('mod/core/denovo_annotation/dbs/HumanPrimaryCellAtlasData.rds')

    } else if (switch2 == 'Mouse RNAseq') {

      readRDS('mod/core/denovo_annotation/dbs/MouseRNAseqData.rds')

    }
    
    
    
    
    incProgress(0.2, message = 'Cell Annotation')
    
    
    label.main <- ref$label.main
    label.fine <- ref$label.fine

    cell_type.main <- SingleR(test = D$X, ref = ref, labels = label.main, clusters = group_type, fine.tune = T)
    cell_type.fine <- SingleR(test = D$X, ref = ref, labels = label.fine, clusters = group_type, fine.tune = T)

    cell_type.main <- cell_type.main$pruned.labels
    cell_type.fine <- cell_type.fine$pruned.labels

    cell_type.main[is.na(cell_type.main)] <- paste('Unknown', sprintf('%02d', 1:length(which(is.na(cell_type.main)))), sep = '_')
    cell_type.fine[is.na(cell_type.fine)] <- paste('Unknown', sprintf('%02d', 1:length(which(is.na(cell_type.fine)))), sep = '_')

    D$var$clusters.ann.SingleR.main <- group_type
    D$var$clusters.ann.SingleR.fine <- group_type

    levels(D$var$clusters.ann.SingleR.main) <- cell_type.main
    levels(D$var$clusters.ann.SingleR.fine) <- cell_type.fine
    
    
    
    
    incProgress(0.8, message = 'Data Extracting')
    
    
    con <- dbConnect(RSQLite::SQLite(), dbpath)
    
    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
    )
    
    dbDisconnect(con)
    
    
    D$write_h5ad(path$DATAPATH)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}