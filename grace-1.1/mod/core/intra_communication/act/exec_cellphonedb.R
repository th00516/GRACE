core.intra_communication.act.exec_cellphonedb <- function(dbpath, grp.id, D, C_type) {
  
  as_matrix.large <- function(mat) {
    
    tmp <- matrix(data = 0L, nrow = mat@Dim[1], ncol = mat@Dim[2])
    
    row_pos <- mat@i + 1
    col_pos <- findInterval(seq(mat@x) - 1, mat@p[-1]) + 1
    
    val <- mat@x
    
    for (i in seq_along(val)) {
      tmp[row_pos[i], col_pos[i]] <- val[i]
    }
    
    rownames(tmp) <- mat@Dimnames[[1]]
    colnames(tmp) <- mat@Dimnames[[2]]
    
    return(tmp)
    
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
    
    
    if (is.null(D$var[[C_type]])) {return(NULL)}
    
    
    dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
    
    
    meta.1 <- data.frame(D[, D$var$Group == 'Group 1']$var_names, D[, D$var$Group == 'Group 1']$var[[C_type]])
    count.1 <- as_matrix.large(D[, D$var$Group == 'Group 1']$X)
    
    cellphonedb_path.1 <- file.path(getwd(), dir_path, 'cellphonedb', 'g1')
    dir.create(cellphonedb_path.1, recursive = T)
    
    write.table(meta.1, file.path(cellphonedb_path.1, 'meta.txt'), sep = '\t', quote = F, row.names = F, col.names = F)
    write.table(count.1, file.path(cellphonedb_path.1, 'count.txt'), sep = '\t', quote = F)
    
    
    if ('Group 2' %in% levels(D$var$Group)) {
      
      meta.2 <- data.frame(D[, D$var$Group == 'Group 2']$var_names, D[, D$var$Group == 'Group 2']$var[[C_type]])
      count.2 <- as_matrix.large(D[, D$var$Group == 'Group 2']$X)
      
      cellphonedb_path.2 <- file.path(getwd(), dir_path, 'cellphonedb', 'g2')
      dir.create(cellphonedb_path.2, recursive = T)
      
      write.table(meta.2, file.path(cellphonedb_path.2, 'meta.txt'), sep = '\t', quote = F, row.names = F, col.names = F)
      write.table(count.2, file.path(cellphonedb_path.2, 'count.txt'), sep = '\t', quote = F)
      
    }
    
    
    
    
    incProgress(0.3, message = 'CellphoneDB Running')
    
    
    system(paste('source "/opt/miniconda3/etc/profile.d/conda.sh" && conda activate cellphonedb &&',
                 'cellphonedb method statistical_analysis',
                 file.path(cellphonedb_path.1, 'meta.txt'),
                 file.path(cellphonedb_path.1, 'count.txt'),
                 paste0('--output-path=', cellphonedb_path.1),
                 '--counts-data=gene_name --threshold=0.3 --pvalue=0.05'))
    
    chk <- read.table(file.path(cellphonedb_path.1, 'meta.txt'))
    
    if (length(unique(chk$V2)) > 1) {
      
      system(paste('source "/opt/miniconda3/etc/profile.d/conda.sh" && conda activate cellphonedb &&',
                   'cellphonedb plot heatmap_plot',
                   file.path(cellphonedb_path.1, 'meta.txt'),
                   paste0('--pvalues-path=', file.path(cellphonedb_path.1, 'pvalues.txt')),
                   paste0('--output-path=', cellphonedb_path.1),
                   '--pvalue=0.05'))
      
    }
    
    if ('Group 2' %in% levels(D$var$Group)) {
      
      system(paste('source "/opt/miniconda3/etc/profile.d/conda.sh" && conda activate cellphonedb &&',
                   'cellphonedb method statistical_analysis',
                   file.path(cellphonedb_path.2, 'meta.txt'),
                   file.path(cellphonedb_path.2, 'count.txt'),
                   paste0('--output-path=', cellphonedb_path.2),
                   '--counts-data=gene_name --threshold=0.3 --pvalue=0.05'))
      
      chk <- read.table(file.path(cellphonedb_path.2, 'meta.txt'))
      
      if (length(unique(chk$V2)) > 1) {
        
        system(paste('source "/opt/miniconda3/etc/profile.d/conda.sh" && conda activate cellphonedb &&',
                     'cellphonedb plot heatmap_plot',
                     file.path(cellphonedb_path.2, 'meta.txt'),
                     paste0('--pvalues-path=', file.path(cellphonedb_path.2, 'pvalues.txt')),
                     paste0('--output-path=', cellphonedb_path.2),
                     '--pvalue=0.05'))
        
      }
      
    }
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
  
}