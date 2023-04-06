core.inter_cellchat.act.exec_cellchat <- function(dbpath, data.id, D, C_type, args.list) {
  
  run_cellchat <- function(data, C_type, out_dir, args_lst) {
    
    #### Preprocessing ####
    species <- args_lst[[1]]
    db.used <- args_lst[[2]]
    
    
    if (species == 'Homo sapiens') {
      
      ppi        <- PPI.human
      CellChatDB <- CellChatDB.human
      
    }
    
    if (species == 'Mus musculus') {
      
      ppi        <- PPI.mouse
      CellChatDB <- CellChatDB.mouse
      
    }
    
    
    mtx <- CreateAssayObject(data$copy()$X)
    mtx <- NormalizeData(mtx)@data
    
    
    #### CellChat Running ####
    cellchat_obj <- createCellChat(object = mtx)
    
    cellchat_obj <- addMeta(cellchat_obj, meta = data$var)
    cellchat_obj <- setIdent(cellchat_obj, ident.use = C_type)
    
    
    CellChatDB.used <- subsetDB(CellChatDB, search = db.used)
    cellchat_obj@DB <- CellChatDB.used
    
    
    cellchat_obj <- subsetData(cellchat_obj)
    
    
    cellchat_obj <- identifyOverExpressedGenes(cellchat_obj)
    cellchat_obj <- identifyOverExpressedInteractions(cellchat_obj)
    
    cellchat_obj <- projectData(cellchat_obj, ppi)
    
    
    cellchat_obj <- computeCommunProb(cellchat_obj, raw.use = F)
    cellchat_obj <- filterCommunication(cellchat_obj, min.cells = 10)
    
    
    cellchat_obj <- computeCommunProbPathway(cellchat_obj)
    
    
    cellchat_obj <- aggregateNet(cellchat_obj)
    
    
    #### Post-processing ####
    saveRDS(cellchat_obj, file.path(out_dir, 'cellchatObj.rds'))
    
  }
  
  
  
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    con <- dbConnect(RSQLite::SQLite(), dbpath)
    
    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
    )
    
    dbDisconnect(con)
    
    
    
    
    incProgress(0.1, message = 'Preparing')
    
    
    D <- D[, D$var$isUsed]
    
    
    dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
    
    
    
    
    incProgress(0.3, message = 'CellChat Running')
    
    
    cellchat_path.1 <- file.path(getwd(), dir_path, 'cellchat', 'g1')
    dir.create(cellchat_path.1, recursive = T)
    
    cellchat_path.2 <- file.path(getwd(), dir_path, 'cellchat', 'g2')
    dir.create(cellchat_path.2, recursive = T)
    
    ad1 <- D[, D$var$Group == 'Group 1']
    ad2 <- D[, D$var$Group == 'Group 2']
    
    if (ncol(ad1) > 100 & C_type %in% ad1$var_keys())
      run_cellchat(ad1, C_type, cellchat_path.1, args.list)
    
    if (ncol(ad2) > 100 & C_type %in% ad2$var_keys())
      run_cellchat(ad2, C_type, cellchat_path.2, args.list)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}