core.data_filtering.act.refine_data <- function(dbpath, data.id, D, attrs) {
  
  withProgress({
    
    incProgress(0.0, message = 'Initializing')
    
    
    D <- D[, D$var$isUsed]
    
    
    obj <- CreateSeuratObject(counts = D$X)
    
    obj <- PercentageFeatureSet(obj, pattern = '^MT-', col.name = 'percent.mt')
    
    
    
    
    incProgress(0.1, message = 'SCTransform & PCA')
    
    
    obj <- SCTransform(obj, method = 'glmGamPoi', vars.to.regress = 'percent.mt', verbose = F)
    
    features <- if (attrs[[1]] == 'Variation') {VariableFeatures(obj)} else {rownames(obj@assays$RNA)}
    
    obj <- RunPCA(obj, features = features, verbose = F)
    
    
    
    
    incProgress(0.5, message = 'Non-linear Dim. Reduction')
    
    
    dim1 <- as.numeric(if (attrs[[2]] == 'Yes') {2} else {1})
    dim2 <- as.numeric(attrs[[3]])
    
    obj <- RunTSNE(obj, dims = dim1:dim2)
    obj <- RunUMAP(obj, dims = dim1:dim2, min.dist = as.numeric(attrs[[4]]))
    
    
    
    
    incProgress(0.7, message = 'Clustering')
    
    
    obj <- FindNeighbors(obj, dims = dim1:dim2, annoy.metric = 'cosine', k.param = as.numeric(attrs[[5]]))
    
    algorithm <- as.numeric(attrs[[6]])
    
    obj <- FindClusters(obj, resolution = 0.2, algorithm = algorithm)
    obj <- FindClusters(obj, resolution = 0.5, algorithm = algorithm)
    obj <- FindClusters(obj, resolution = 0.8, algorithm = algorithm)
    obj <- FindClusters(obj, resolution = 1.2, algorithm = algorithm)
    
    
    
    
    incProgress(0.8, message = 'Data Extracting')
    
    
    con <- dbConnect(RSQLite::SQLite(), dbpath)
    
    path <- dbGetQuery(
      con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
    )
    
    dbDisconnect(con)
    
    
    
    
    D$var$clusters.0.2 <- factor(sprintf('C%02d', obj$SCT_snn_res.0.2))
    D$var$clusters.0.5 <- factor(sprintf('C%02d', obj$SCT_snn_res.0.5))
    D$var$clusters.0.8 <- factor(sprintf('C%02d', obj$SCT_snn_res.0.8))
    D$var$clusters.1.2 <- factor(sprintf('C%02d', obj$SCT_snn_res.1.2))
    
    
    D$varm$pca <- obj@reductions$pca@cell.embeddings
    D$varm$tsne <- obj@reductions$tsne@cell.embeddings
    D$varm$umap <- obj@reductions$umap@cell.embeddings
    
    
    D$obs$exp.mean <- Matrix::rowMeans(D$X)
    D$obs$exp.ratio <- Matrix::rowSums(D$X > 0) / D$n_vars
    
    D$obs$isVariableFeature <- D$obs_names %in% VariableFeatures(obj)
    
    
    D$uns$pcs_sd <- data.frame(PCs = sprintf('PC_%02d', 1:50), SD = obj@reductions$pca@stdev)
    
    
    D$write_h5ad(path$DATAPATH)
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}