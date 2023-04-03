core.ref_based_annotation.act.select_group <- function(dbpath, proj_id, data_id, D, C_type, C_idx, switch) {
  
  if (is.null(C_idx)) {return(NULL)}
  
  
  withProgress({
    
    id <- paste0(sprintf('%05X', as.integer(format(Sys.time(), '%y%m%d'))),
                 sprintf('%05X', as.integer(format(Sys.time(), '%H%M%S'))))
    
    
    D <- D[, D$var$isUsed]
    
    
    if (is.null(D$var[[C_type]])) {return(NULL)}
    
    selected_cluster <- levels(D$var[[C_type]])[C_idx]
    
    dat <- D[, D$var[[C_type]] == selected_cluster]
    
    dat$var$clusters.ann.SingleR.main <- NULL
    dat$var$clusters.ann.SingleR.fine <- NULL
    
    
    
    
    incProgress(0.0, message = 'Initializing')
    
    
    obj <- CreateSeuratObject(counts = dat$X)
    
    obj <- PercentageFeatureSet(obj, pattern = '^MT-', col.name = 'percent.mt')

    obj <- SCTransform(obj, method = 'glmGamPoi', vars.to.regress = 'percent.mt', verbose = F)
    
    features <- VariableFeatures(obj)
    ignore_genes <- unique(c(unlist(unname(cc.genes)), rownames(obj)[grep('^RP[SL]', rownames(obj))]))
    features <- setdiff(features, ignore_genes)
    
    obj <- RunPCA(obj, features = features, verbose = F)
    
    obj <- RunTSNE(obj, dims = 1:10)
    obj <- RunUMAP(obj, dims = 1:10, min.dist = 0.01)
    
    obj <- FindNeighbors(obj, dims = 1:10, annoy.metric = 'cosine', k.param = 20)
    
    obj <- FindClusters(obj, resolution = 0.2, algorithm = 2)
    obj <- FindClusters(obj, resolution = 0.5, algorithm = 2)
    obj <- FindClusters(obj, resolution = 0.8, algorithm = 2)
    obj <- FindClusters(obj, resolution = 1.2, algorithm = 2)
    
    
    
    
    incProgress(0.2, message = 'Cell Annotation')
    
    
    group_type <- obj[[paste0('SCT_snn_res.', 0.8)]][[1]]
    
    ref <- if (switch == 'Human Primary Cell Atlas') {
      
      readRDS('mod/core/denovo_annotation/dbs/HumanPrimaryCellAtlasData.rds')
      
    } else if (switch == 'Mouse RNAseq') {
      
      readRDS('mod/core/denovo_annotation/dbs/MouseRNAseqData.rds')
      
    }
    
    label.main <- ref$label.main
    label.fine <- ref$label.fine
    
    cell_type.main <- SingleR(test = obj@assays$SCT@data, ref = ref, labels = label.main, clusters = group_type, fine.tune = T)
    cell_type.fine <- SingleR(test = obj@assays$SCT@data, ref = ref, labels = label.fine, clusters = group_type, fine.tune = T)
    
    cell_type.main <- cell_type.main$pruned.labels
    cell_type.fine <- cell_type.fine$pruned.labels
    
    cell_type.main[is.na(cell_type.main)] <- paste('Unknown', sprintf('%02d', 1:length(which(is.na(cell_type.main)))), sep = '_')
    cell_type.fine[is.na(cell_type.fine)] <- paste('Unknown', sprintf('%02d', 1:length(which(is.na(cell_type.fine)))), sep = '_')
    
    obj[['SingleR.main']] <- group_type
    obj[['SingleR.fine']] <- group_type
    
    levels(obj$SingleR.main) <- cell_type.main
    levels(obj$SingleR.fine) <- cell_type.fine
    
    
    
    
    incProgress(0.5, message = 'Data Extracting')
    
    
    ## extracting ##
    grp_id <- paste0('G', id)
    grp_name <- selected_cluster
    cell_count <- dat$n_vars
    data_path <- file.path(dirname(dbpath), proj_id, paste0(data_id, '.', grp_id, '.h5ad'))
    
    proj.id <- paste0('\'', proj_id, '\'')
    data.id <- paste0('\'', data_id, '\'')
    grp.id <- paste0('\'', grp_id, '\'')
    grp.name <- paste0('\'', grp_name, '\'')
    grp.type <- paste0('\'', C_type, '\'')
    cell.count <- paste0('\'', cell_count, '\'')
    data.path <- paste0('\'', data_path, '\'')
    
    records <- paste(proj.id, data.id, grp.id, grp.type, grp.name, cell.count, data.path, sep = ',')
    
    
    con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
    
    res <- DBI::dbSendQuery(
      con, 
      paste0('INSERT INTO ',
             'grp_records(PROJ_ID, DATA_ID, GRP_ID, GRP_TYPE, GRP_NAME, CELL_COUNT, DATAPATH) ',
             paste0('VALUES(', records, ')'))
    )
    
    DBI::dbClearResult(res)
    
    DBI::dbDisconnect(con)
    
    
    
    
    dat$var$clusters.0.2 <- factor(sprintf('subC%02d', obj$SCT_snn_res.0.2))
    dat$var$clusters.0.5 <- factor(sprintf('subC%02d', obj$SCT_snn_res.0.5))
    dat$var$clusters.0.8 <- factor(sprintf('subC%02d', obj$SCT_snn_res.0.8))
    dat$var$clusters.1.2 <- factor(sprintf('subC%02d', obj$SCT_snn_res.1.2))
    
    dat$var$clusters.ann.SingleR.main <- obj$SingleR.main
    dat$var$clusters.ann.SingleR.fine <- obj$SingleR.fine
    
    
    dat$varm$pca <- obj@reductions$pca@cell.embeddings
    dat$varm$tsne <- obj@reductions$tsne@cell.embeddings
    dat$varm$umap <- obj@reductions$umap@cell.embeddings
    
    
    dat$obs$exp.mean <- Matrix::rowMeans(dat$X)
    dat$obs$exp.ratio <- Matrix::rowSums(dat$X > 0) / dat$n_vars
    
    dat$obs$isVariableFeature <- dat$obs_names %in% features
    
    
    dat$uns$pcs_sd <- data.frame(PCs = sprintf('PC_%02d', 1:50), SD = obj@reductions$pca@stdev)
    
    
    dat$write_h5ad(data_path)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
}