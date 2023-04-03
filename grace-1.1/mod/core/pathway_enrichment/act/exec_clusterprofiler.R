core.pathway_enrichment.act.exec_clusterprofiler <- function(dbpath, grp.id, D, ctl) {
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    D <- D[, D$var$isUsed]
    
    
    obj <- CreateSeuratObject(counts = D$X)
    
    obj <- PercentageFeatureSet(obj, pattern = '^MT-', col.name = 'percent.mt')
    
    obj <- SCTransform(obj, method = 'glmGamPoi', vars.to.regress = 'percent.mt', verbose = F)
    
    features <- VariableFeatures(obj)
    
    obj <- RunPCA(obj, features = features, verbose = F)
    
    
    
    
    incProgress(0.5, message = 'Markers Finding')
    
    
    dim.max <- ctl
    
    markers <- unique(unlist(lapply(1:dim.max, function(x) {TopFeatures(obj, x, 100)})))
    
    
    
    
    incProgress(0.1, message = 'ClusterProfiler Running')
    
    ego_BP <- enrichGO(markers, 
                       OrgDb = 'org.Hs.eg.db', keyType = 'SYMBOL', 
                       ont = 'BP', 
                       pAdjustMethod = 'BH', pvalueCutoff  = 0.01, qvalueCutoff = 0.05)
    
    
    
    
    incProgress(0.7, message = 'Data Processing')
    
    enriched_go <- strsplit(ego_BP@result$geneID, '/')
    names(enriched_go) <- ego_BP@result$ID
    
    enriched_go <- if (length(enriched_go) > 200) {enriched_go[1:200]} else {enriched_go}
    
    
    GO_score <- lapply(1:length(enriched_go), function(x) {
      
      gr <- as.numeric(strsplit(ego_BP@result$GeneRatio[x], '/')[[1]])
      br <- as.numeric(strsplit(ego_BP@result$BgRatio[x], '/')[[1]])
      q <- ego_BP@result$qvalue[x]
      
      fscore <- (gr[1] / gr[2]) / (br[1] / br[2])
    
      return(sprintf("%0.4f,%0.8f", fscore, q))
      
    })
    names(GO_score) <- names(enriched_go)
    
    
    cell_enrichment_score <- lapply(1:length(enriched_go), function(x) {
      
      fscore <- as.numeric(strsplit(GO_score[[x]], ',')[[1]])
      
      log10(colSums(obj[enriched_go[[x]],]@assays$RNA@counts > 2) * fscore[1] / (fscore[2] + 1e-8) + 1)
    
    })
    names(cell_enrichment_score) <- names(enriched_go)

    
    cell_enrichment_score.sd <- sapply(1:length(enriched_go), function(x) {
      
      sd(cell_enrichment_score[[x]])
      
    })
    names(cell_enrichment_score.sd) <- names(enriched_go)
    
    cell_enrichment_score <- cell_enrichment_score[order(cell_enrichment_score.sd, decreasing = T)]
    cell_enrichment_score.top10 <- cell_enrichment_score[1:10]
    
    GO_score <- GO_score[order(cell_enrichment_score.sd, decreasing = T)]
    GO_score.top10 <- GO_score[1:10]
    
    
    if (length(grep('^GO:', colnames(D$var))) != 0) {
      
      D$var <- D$var[, -grep('^GO:', colnames(D$var))]
      
      D$uns$GO_score.top10 <- NULL
      
    }
    
    D$var <- cbind(D$var, cell_enrichment_score.top10)
    
    D$uns$GO_score.top10 <- GO_score.top10
    
    
    
    
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