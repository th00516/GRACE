library(Seurat)
library(DoubletFinder)




core.data_upload.act.generate_sc_data <- function(dbpath, proj_id, file_path, ctls) {
  
  if (is.null(proj_id)) {return(NULL)}
  if (is.null(file_path)) {return(NULL)}
  
  
  ctls <- strsplit(ctls, ',')[[1]]
  
  
  if (ctls[1] != '') {
    
    if (file.exists(file_path)) {
      
      # withProgress({
        
        # incProgress(0.0, message = 'Initializing')
        
        
        id <- paste0(sprintf('%05X', as.integer(format(Sys.time(), '%y%m%d'))),
                     sprintf('%05X', as.integer(format(Sys.time(), '%H%M%S'))))
        
        
        
        
        ## initializing ##
        splited_basename <- strsplit(basename(file_path), '.', fixed = T)[[1]]
        
        gene_name <- vector(length = 40000)
        
        mat <- if (splited_basename[length(splited_basename)] == 'h5') {
          
          tmp_mat <- Read10X_h5(file_path)
          gene_name <- rownames(tmp_mat)
          
          tmp_mat
          
        } else if (splited_basename[length(splited_basename)] == 'gz' |
                   splited_basename[length(splited_basename)] == 'csv' |
                   splited_basename[length(splited_basename)] == 'tsv' |
                   splited_basename[length(splited_basename)] == 'txt') {
          
          tmp_mat <- data.table::fread(file_path)
          gene_name <- tmp_mat$V1
          tmp_mat <- tmp_mat[, -1, drop = F]
          
          tmp_mat
          
        } else if (splited_basename[length(splited_basename)] == 'rds') {
          
          tmp_mat <- readRDS(file_path)
          gene_name <- rownames(tmp_mat@assays$RNA@counts)
          tmp_mat <- tmp_mat@assays$RNA@counts
          
          tmp_mat
          
        }
        
        
        obj <- CreateSeuratObject(counts = mat, min.cells = 3, min.features = 200, row.names = gene_name)
        
        obj <- PercentageFeatureSet(obj, pattern = '^MT-', col.name = 'percent.mt')
        obj <- subset(obj, subset = percent.mt < 20)
        
        obj <- SCTransform(obj, method = 'glmGamPoi', vars.to.regress = 'percent.mt', verbose = F)
        
        obj <- RunPCA(obj, features = VariableFeatures(obj), verbose = F)
        
        obj <- RunTSNE(obj, dims = 1:30)
        obj <- RunUMAP(obj, dims = 1:30)
        
        obj <- FindNeighbors(obj, dims = 1:30, annoy.metric = 'cosine')
        
        obj <- FindClusters(obj, resolution = 0.2, algorithm = 2)
        obj <- FindClusters(obj, resolution = 0.5, algorithm = 2)
        obj <- FindClusters(obj, resolution = 0.8, algorithm = 2)
        obj <- FindClusters(obj, resolution = 1.2, algorithm = 2)
        
        
        
        if (ctls[7] == 'Yes') {
          
          # incProgress(0.2, message = 'Find Doublet')
  
  
          obj.par <- paramSweep_v3(obj, PCs = 1:30, sct = T)
          obj.stat <- summarizeSweep(obj.par, GT = F)
          obj.bcmvn <- find.pK(obj.stat)
          obj.mpK <- as.numeric(as.vector(obj.bcmvn$pK[which.max(obj.bcmvn$BCmetric)]))
          obj.homotypic.prop <- modelHomotypic(obj$SCT_snn_res.0.5)
  
          obj.nExp_poi <- round(0.075 * length(colnames(obj)))
          obj.nExp_poi.adj <- round(obj.nExp_poi * (1 - obj.homotypic.prop))
  
          obj <- doubletFinder_v3(obj, PCs = 1:30, pN = 0.25, pK = obj.mpK, nExp = obj.nExp_poi,
                                  sct = T, reuse.pANN = F)
  
          obj <- doubletFinder_v3(obj, PCs = 1:30, pN = 0.25, pK = obj.mpK, nExp = obj.nExp_poi.adj,
                                  sct = T, reuse.pANN = paste('pANN_0.25', obj.mpK, obj.nExp_poi, sep = '_'))
  
          obj[['Singlet_or_Doublet']] <- obj[[paste('DF.classifications_0.25', obj.mpK, obj.nExp_poi, sep = '_')]]
          
        } else {
          
          obj[['Singlet_or_Doublet']] <- rep('Singlet', length(colnames(obj)))
          
        }
        
        
        
        # incProgress(0.8, message = 'Data Extracting')
        
        
        D <- anndata::AnnData(X = obj@assays$RNA@counts)
        
        
        ## extracting ##
        data_id <- paste0('D', id)
        name_ <- ctls[1]
        spec_ <- ctls[2]
        desc_ <- 'Single Data'
        created_date <- format(Sys.time(), '%y-%m-%d')
        group_ <- ctls[3]
        lib_pltf <- ctls[4]
        lib_type <- ctls[5]
        seq_pltf <- ctls[6]
        cell_count <- D$n_vars
        fea_count <- D$n_obs
        data_path <- file.path(dirname(dbpath), proj_id, paste0(data_id, '.h5ad'))
        
        proj.id <- paste0('\'', proj_id, '\'')
        data.id <- paste0('\'', data_id, '\'')
        name. <- paste0('\'', name_, '\'')
        spec. <- paste0('\'', spec_, '\'')
        desc. <- paste0('\'', desc_, '\'')
        created.date <- paste0('\'', created_date, '\'')
        group. <- paste0('\'', group_, '\'')
        lib.pltf <- paste0('\'', lib_pltf, '\'')
        lib.type <- paste0('\'', lib_type, '\'')
        seq.pltf <- paste0('\'', seq_pltf, '\'')
        cell.count <- paste0('\'', cell_count, '\'')
        fea.count <- paste0('\'', fea_count, '\'')
        data.path <- paste0('\'', data_path, '\'')
        
        records <- paste(proj.id, data.id, name.,
                         spec.,
                         desc., created.date, group., lib.pltf, lib.type, seq.pltf,
                         cell.count, fea.count, data.path,
                         sep = ',')
        
        
        # modified for nextflow
        # con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
        con <- DBI::dbConnect(RSQLite::SQLite(), file.path('../../..', dbpath))
        ####
        
        res <- DBI::dbSendQuery(
          con, 
          paste0('INSERT INTO ',
                 'data_records(PROJ_ID, DATA_ID, NAME_, SPEC_, DESC_, CREATED_DATE, GROUP_, LIB_PLTF, LIB_TYPE, SEQ_PLTF, CELL_COUNT, FEA_COUNT, DATAPATH) ',
                 paste0('VALUES(', records, ')'))
        )
        
        DBI::dbClearResult(res)
        
        DBI::dbDisconnect(con)
        
        
        D$var$isUsed <- rep(T, D$n_vars)
        
        D$var$Ident <- rep(name_, D$n_vars)
        D$var$Group <- rep(group_, D$n_vars)
        
        D$var$nCount <- obj$nCount_RNA
        D$var$nFeature <- obj$nFeature_RNA
        D$var$pFeature.mt <- obj$percent.mt
        D$var$eActivity.actb <- obj@assays$RNA@counts['ACTB',]
        
        D$var$SingletOrDoublet <- factor(obj$Singlet_or_Doublet, levels = c('Singlet', 'Doublet'))
        
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
        
        
        # modified for nextflow
        # D$write_h5ad(data_path)
        D$write_h5ad(file.path('../../..', data_path))
        ####
        
        
        
        
        # incProgress(1.0, message = 'Finished')
        
      # })
      
    }
    
  }
  
}




args <- commandArgs()
core.data_upload.act.generate_sc_data(args[6], args[7], args[8], args[9])
