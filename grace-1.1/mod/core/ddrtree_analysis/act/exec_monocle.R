core.ddrtree_analysis.act.exec_monocle <- function(dbpath, grp.id, D) {
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    D <- D[, D$var$isUsed]
    
    
    fea <- data.frame(gene_short_name = D$obs_names, row.names = D$obs_names)
    
    
    pd <- AnnotatedDataFrame(D$var)
    fd <- AnnotatedDataFrame(fea)
    
    
    
    
    incProgress(0.1, message = 'Monocle Running')
    
    
    monocle_obj <- newCellDataSet(D$X, phenoData = pd, featureData = fd)
    
    monocle_obj <- estimateSizeFactors(monocle_obj)
    monocle_obj <- estimateDispersions(monocle_obj, relative_expr = T)
    
    disp_genes <- D[D$obs$isVariableFeature,]$obs_names
    
    monocle_obj <- setOrderingFilter(monocle_obj, disp_genes)
    
    monocle_obj <- reduceDimension(monocle_obj, max_components = 2, method = 'DDRtree')
    monocle_obj <- orderCells(monocle_obj)
    
    
    
    
    # incProgress(0.3, message = 'Branch Test Running')
    
    # BEAM_res <- BEAM(monocle_obj[monocle_obj@featureData@data$use_for_ordering,], branch_point = 1)
    # BEAM_res <- BEAM_res[order(BEAM_res$qval),]
    
    
    
    
    incProgress(0.7, message = 'Data Processing')
    
    D$var$Pseudotime <- monocle_obj$Pseudotime
    D$var$State <- monocle_obj$State
    
    D$varm$ddrtree <- t(monocle_obj@reducedDimS)
    D$uns$ddrtree_b <- t(monocle_obj@reducedDimK)

    # D$obs$BranchMarkerQ <- 1.0
    # D$obs[BEAM_res$gene_short_name,]$BranchMarkerQ <- BEAM_res$qval
    
    
    
    
    incProgress(0.8, message = 'Data Extracting')
    
    con <- dbConnect(RSQLite::SQLite(), dbpath)
    
    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
    )
    
    dbDisconnect(con)
    
    
    D$write_h5ad(path$DATAPATH)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}