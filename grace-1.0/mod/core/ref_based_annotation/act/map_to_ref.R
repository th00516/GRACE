core.ref_based_annotation.act.map_to_ref <- function(dbpath, data.id, D, file_path, switch1, switch2) {
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    D <- D[, D$var$isUsed]
    
    obj <- CreateSeuratObject(counts = D$X)
    
    obj <- PercentageFeatureSet(obj, pattern = '^MT-', col.name = 'percent.mt')

    obj <- SCTransform(obj, method = 'glmGamPoi', vars.to.regress = 'percent.mt', verbose = F)
    
    features <- VariableFeatures(obj)
    
    obj <- RunPCA(obj, features = features, verbose = F)
    
    
    
    
    incProgress(0.3, message = 'Mapping')
    
    
    reference <- if (switch1 == 'Yes') {
      
      if (!is.null(switch2)) {readRDS(switch2)}
      
    } else {
    
      readRDS(file_path)
      
    }
    
    
    anchors <- FindTransferAnchors(reference = reference, 
                                   query = obj, 
                                   normalization.method = 'SCT', 
                                   reference.reduction = 'pca',
                                   features = features)
    
    obj <- MapQuery(anchorset = anchors, 
                    query = obj, 
                    reference = reference,
                    refdata = list(clusters.ann = 'clusters.ann'),
                    reference.reduction = 'pca',
                    transferdata.args = list(k.weight = 20))
    
    
    
    
    incProgress(0.9, message = 'Data Extracting')
    
    
    con <- dbConnect(RSQLite::SQLite(), dbpath)
    
    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
    )
    
    dbDisconnect(con)
    
    
    D$var$predicted.clusters.ann <- obj$predicted.clusters.ann

    
    D$write_h5ad(path$DATAPATH)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}