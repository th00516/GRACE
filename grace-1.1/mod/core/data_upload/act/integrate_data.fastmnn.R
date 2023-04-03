library(Seurat)
library(SeuratWrappers)




core.data_upload.act.integrate_data <- function(dbpath, proj.id, data.ids) {
  
  data.ids <- strsplit(data.ids, ',')[[1]]
  
  
  if (length(data.ids) > 1) {
    
    # withProgress({
      
      # incProgress(0.0, message = 'Initializing')
      
      ## get data path ##
      path.list <- lapply(data.ids, function(x) {
        
        # modified for nextflow
        # con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
        con <- DBI::dbConnect(RSQLite::SQLite(), file.path('../../..', dbpath))
        ####
        
        path <- DBI::dbGetQuery(con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', x, '"'))
        
        DBI::dbDisconnect(con)
        
        
        # modified for nextflow
        # path$DATAPATH
        file.path('../../..', path$DATAPATH)
        ####
        
      })
      
      
      
      
      ## generate seurat object ##
      obj.list <- lapply(1:length(path.list), function(x) {
        
        D <- anndata::read_h5ad(path.list[[x]])
        D <- D[, D$var$isUsed]

        obj <- CreateSeuratObject(counts = D$X)
        obj[['Ident']] <- D$var$Ident
        obj[['Group']] <- D$var$Group
        
        obj <- PercentageFeatureSet(obj, pattern = '^MT-', col.name = 'percent.mt')

        obj <- NormalizeData(obj)
        
        
        obj <- RenameCells(obj, new.names = paste(colnames(obj), x, sep = '_'))
        

        obj

      })




      # incProgress(0.3, message = 'Integration')

      ## data integration ##
      obj <- RunFastMNN(object.list = obj.list, features = 3000, reconstructed.assay = 'integrated')
      
      DefaultAssay(obj) <- 'integrated'
      
      
      
      
      # incProgress(0.5, message = 'Data Processing')

      ## generate single-cell data ##
      id <- paste0(sprintf('%05X', as.integer(format(Sys.time(), '%y%m%d'))),
                   sprintf('%05X', as.integer(format(Sys.time(), '%H%M%S'))))
      
      
      
      
      ## initializing ##
      obj <- FindVariableFeatures(obj, nfeatures = 2000)
      
      obj <- ScaleData(obj, features = rownames(obj))
      obj <- RunPCA(obj, features = VariableFeatures(obj))
      
      obj <- RunTSNE(obj, reduction = 'mnn', dims = 1:30)
      obj <- RunUMAP(obj, reduction = 'mnn', dims = 1:30)
      
      obj <- FindNeighbors(obj, reduction = 'mnn', dims = 1:30, annoy.metric = 'cosine',
                           graph.name=c('integrated_nn', 'integrated_snn'))
      
      obj <- FindClusters(obj, resolution = 0.2, algorithm = 2)
      obj <- FindClusters(obj, resolution = 0.5, algorithm = 2)
      obj <- FindClusters(obj, resolution = 0.8, algorithm = 2)
      obj <- FindClusters(obj, resolution = 1.2, algorithm = 2)
      
      
      D <- anndata::AnnData(X = obj@assays$RNA@counts)
      
      
      
      
      # incProgress(0.8, message = 'Data Extracting')
      
      ## extracting ##
      proj_id <- proj.id
      data_id <- paste0('D', id)
      name_ <- 'Integrated.FastMNN'
      desc_ <- paste(data.ids, collapse = ' + ')
      created_date <- format(Sys.time(), '%y-%m-%d')
      group_ <- paste(unique(obj$Group), collapse = ' + ')
      lib_pltf <- 'Integrated.FastMNN'
      lib_type <- 'Integrated.FastMNN'
      seq_pltf <- 'Integrated.FastMNN'
      cell_count <- D$n_vars
      fea_count <- D$n_obs
      data_path <- file.path(dirname(dbpath), proj_id, paste0('D', id, '.h5ad'))
      
      proj.id <- paste0('\'', proj_id, '\'')
      data.id <- paste0('\'', data_id, '\'')
      name. <- paste0('\'', name_, '\'')
      desc. <- paste0('\'', desc_, '\'')
      created.date <- paste0('\'', created_date, '\'')
      group. <- paste0('\'', group_, '\'')
      lib.pltf <- paste0('\'', lib_pltf, '\'')
      lib.type <- paste0('\'', lib_type, '\'')
      seq.pltf <- paste0('\'', seq_pltf, '\'')
      cell.count <- paste0('\'', cell_count, '\'')
      fea.count <- paste0('\'', fea_count, '\'')
      data.path <- paste0('\'', data_path, '\'')
      
      records <- paste(proj.id, 
                       data.id,
                       name., 
                       desc., created.date, group., lib.pltf, lib.type, seq.pltf, 
                       cell.count, fea.count, data.path, sep = ',')


      # modified for nextflow
      # con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
      con <- DBI::dbConnect(RSQLite::SQLite(), file.path('../../..', dbpath))
      ####

      res <- DBI::dbSendQuery(con, paste0('INSERT INTO ',
                                          'data_records(PROJ_ID, DATA_ID, NAME_, DESC_, CREATED_DATE, GROUP_, LIB_PLTF, LIB_TYPE, SEQ_PLTF, CELL_COUNT, FEA_COUNT, DATAPATH) ',
                                          paste0('VALUES(', records, ')')))

      DBI::dbClearResult(res)

      DBI::dbDisconnect(con)
      
      
      
      
      D$var$isUsed <- rep(T, D$n_vars)
      
      D$var$Ident <- obj$Ident
      D$var$Group <- obj$Group

      D$var$nCount <- obj$nCount_RNA
      D$var$nFeature <- obj$nFeature_RNA
      D$var$pFeature.mt <- obj$percent.mt
      D$var$eActivity.actb <- obj@assays$RNA@counts['ACTB',]
      
      D$var$SingletOrDoublet <- factor(rep('Singlet', D$n_vars), levels = c('Singlet', 'Doublet'))
      
      D$var$clusters.0.2 <- factor(sprintf('G%02d', obj$integrated_snn_res.0.2))
      D$var$clusters.0.5 <- factor(sprintf('G%02d', obj$integrated_snn_res.0.5))
      D$var$clusters.0.8 <- factor(sprintf('G%02d', obj$integrated_snn_res.0.8))
      D$var$clusters.1.2 <- factor(sprintf('G%02d', obj$integrated_snn_res.1.2))
      
      
      D$varm$pca <- obj@reductions$pca@cell.embeddings
      D$varm$tsne <- obj@reductions$tsne@cell.embeddings
      D$varm$umap <- obj@reductions$umap@cell.embeddings
      
      
      D$obs$exp.mean <- Matrix::rowMeans(D$X)
      D$obs$exp.ratio <- Matrix::rowSums(D$X > 0) / D$n_vars
      
      D$obs$isVariableFeature <- D$obs_names %in% VariableFeatures(obj)
      
      
      D$uns$pcs_sd <- data.frame(PCs = sprintf('PC_%02d', 1:50), SD = obj@reductions$pca@stdev)
      
      
      # modified for nextflow
      # D$write_h5ad(data_path)
      D$write_h5ad(file.path('../../..', data_path))
      ####
      
      
      
      
      # incProgress(1.0, message = 'Finished')
      
    # })
    
  }
  
}




# modified for nextflow
args <- commandArgs()
core.data_upload.act.integrate_data(args[6], args[7], args[8])
