core.cell_cycle.act.score_cell_cycle <- function(dbpath, data.id, D) {
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    D <- D[, D$var$isUsed]
    
    
    obj <- CreateSeuratObject(counts = D$X)
    
    obj <- PercentageFeatureSet(obj, pattern = '^MT-', col.name = 'percent.mt')
    
    
    
    
    incProgress(0.1, message = 'SCTransform')
    
    
    obj <- SCTransform(obj, method = 'glmGamPoi', vars.to.regress = 'percent.mt', verbose = F)
    
    
    
    
    incProgress(0.5, message = 'Cell Cycle Scoring')
    
    
    g2m_genes <- CaseMatch(search = cc.genes$g2m.genes, match = rownames(obj))
    s_genes <- CaseMatch(search = cc.genes$s.genes, match = rownames(obj))
    
    obj <- CellCycleScoring(obj, g2m.features = g2m_genes, s.features = s_genes)
    
    
    
    
    incProgress(0.8, message = 'Data Extracting')
    
    
    con <- dbConnect(RSQLite::SQLite(), dbpath)
    
    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
    )
    
    dbDisconnect(con)
    
    
    
    
    D$var$cell_cycle <- obj$Phase
    D$var$G2M.score <- obj$G2M.Score
    D$var$S.score <- obj$S.Score
    
    
    D$write_h5ad(path$DATAPATH)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}