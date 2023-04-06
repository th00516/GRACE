core.intra_cellcall.act.exec_cellcall <- function(dbpath, grp.id, D, C_type, args.list) {
  
  run_cellcall <- function(data, cell_type.list, out_dir, args_lst) {
    
    mtx <- as.data.frame(Matrix::as.matrix(data$copy()$X))
    
    cell_type.list <- gsub('_', '.', cell_type.list)
    cell_type.list <- gsub('\\+', '.H.', cell_type.list)
    cell_type.list <- gsub('\\-', '.L.', cell_type.list)
    
    colnames(mtx) <- gsub('_', '.', colnames(mtx))
    colnames(mtx) <- paste(colnames(mtx), cell_type.list, sep = '_')
    
    species <- args_lst[[1]]
    padjust <- as.numeric(args_lst[[2]])
    
    
    cellcallObj <- CreateNichConObject(data = mtx,
                                       min.feature = 3,
                                       names.field = 2,
                                       source = 'UMI',
                                       scale.factor = 10^4,
                                       Org = species)
    
    
    cellcallObj <- TransCommuProfile(object = cellcallObj,
                                     pValueCor = 0.05,
                                     CorValue = 0.25,
                                     topTargetCor = 1,
                                     p.adjust = padjust,
                                     use.type = 'mean',
                                     method = 'weighted',
                                     IS_core = T,
                                     Org = species)
    
    saveRDS(cellcallObj, 'test.rds')
    n <- cellcallObj@data$expr_l_r_log2_scale
    
    pathway.list <- lapply(colnames(n), function(i) {
      
      tmp <- getHyperPathway(data = n, object = cellcallObj, cella_cellb = i, Org = species)
      
      
      return(tmp)
      
    })
    
    names(pathway.list) <- colnames(cellcallObj@data$expr_l_r_log2_scale)
    
    
    saveRDS(cellcallObj, file.path(out_dir, 'cellcallObj.rds'))
    saveRDS(pathway.list, file.path(out_dir, 'pathway.list.rds'))
    
  }
  
  
  
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    con <- dbConnect(RSQLite::SQLite(), dbpath)
    
    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
    )
    
    dbDisconnect(con)
    
    
    
    
    incProgress(0.1, message = 'Preparing')
    
    
    D <- D[, D$var$isUsed]
    
    
    dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
    
    
    
    
    incProgress(0.3, message = 'CellCall Running')
    
    
    cellcall_path.1 <- file.path(getwd(), dir_path, 'cellcall', 'g1')
    dir.create(cellcall_path.1, recursive = T)
    
    cellcall_path.2 <- file.path(getwd(), dir_path, 'cellcall', 'g2')
    dir.create(cellcall_path.2, recursive = T)
    
    ad1 <- D[, D$var$Group == 'Group 1']
    ad2 <- D[, D$var$Group == 'Group 2']
    
    if (ncol(ad1) > 100 & C_type %in% ad1$var_keys())
      run_cellcall(ad1, ad1$var[[C_type]], cellcall_path.1, args.list)
    
    if (ncol(ad2) > 100 & C_type %in% ad2$var_keys())
      run_cellcall(ad2, ad2$var[[C_type]], cellcall_path.2, args.list)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}