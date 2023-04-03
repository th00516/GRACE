core.spring_analysis.act.exec_spring <- function(dbpath, grp.id, D, args) {
  
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
    spring_path <- file.path(getwd(), dir_path, 'spring')
    
    dir.create(spring_path, recursive = T)
    
    
    RcppCNPy::npySave(file.path(spring_path, 'E.npy'), Matrix::as.matrix(D$copy()$T$X))
    write.table(D$obs_names, file.path(spring_path, 'gene_list'), quote = F, row.names = F, col.names = F)
    write.csv(D$var, file.path(spring_path, 'metadata'), quote = F, row.names = F)
    
    
    
    incProgress(0.3, message = 'SPRING Running')
    
    
    system(paste('cd', spring_path, '&&',
                 'source "/opt/miniconda3/etc/profile.d/conda.sh" && conda activate spring &&',
                 paste('pythonw ../../../../mod/core/spring_analysis/act/libexec/generate_spring.py',
                       args[1], args[2], args[3], args[4], args[5], args[6])))
    
    
    
    
    incProgress(1.0, message = 'Finished')
    
  })
  
}