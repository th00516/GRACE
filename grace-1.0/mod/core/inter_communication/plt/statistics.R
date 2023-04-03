core.inter_communication.plt.statistics.bubble.1 <- function(dbpath, data.id, G_dir, cluster.1, cluster.2, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(cluster.1)) {return(NULL)}
  if (is.null(cluster.2)) {return(NULL)}
  
  if (is.null(data.id)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) - 5), '.running')
  
  cellphonedb_path <- file.path(getwd(), dir_path, 'cellphonedb', G_dir)
  cellphonedb_path.0 <- if (G_dir == 'g1') {
    
    file.path(getwd(), dir_path, 'cellphonedb', 'g2')
    
  } else {
    
    file.path(getwd(), dir_path, 'cellphonedb', 'g1')
    
  }
  

  if (!file.exists(file.path(cellphonedb_path, 'means.txt'))) {return(NULL)}
  if (!file.exists(file.path(cellphonedb_path, 'pvalues.txt'))) {return(NULL)}
  
  
  cluster <- paste(cluster.1, cluster.2, sep = '|')
  
  
  dat <- read.table(file.path(cellphonedb_path, 'means.txt'), header = T, sep = '\t', check.names = F)
  dat.p <- read.table(file.path(cellphonedb_path, 'pvalues.txt'), header = T, sep = '\t', check.names = F)
  
  
  if (is.null(dat[[cluster]])) {return(NULL)}
  
  dt <- dat[dat$gene_a != '' & dat$gene_b != '' & dat$receptor_a != dat$receptor_b, c('gene_a', 'gene_b', 'receptor_a', cluster)]
  dt.p <- dat.p[dat.p$gene_a != '' & dat.p$gene_b != '' & dat$receptor_a != dat$receptor_b, c('gene_a', 'gene_b', 'receptor_a', cluster)]
  
  dt <- as.data.frame(t(apply(dt, 1, function(x) {if (x[3] == 'False') {c(x[1], x[2], x[4])} else {c(x[2], x[1], x[4])}})))
  dt.p <- as.data.frame(t(apply(dt.p, 1, function(x) {if (x[3] == 'False') {c(x[1], x[2], x[4])} else {c(x[2], x[1], x[4])}})))
  
  max_Means <- max(as.numeric(dt[, 3]))
  
  dt <- cbind(dt, dt.p$V3)
  colnames(dt) <- c('Ligand', 'Receptor', 'Means', 'p')
  
  
  if (file.exists(cellphonedb_path.0)) {
    
    dat.0 <- read.table(file.path(cellphonedb_path.0, 'means.txt'), header = T, sep = '\t', check.names = F)
    
    dt.0 <- dat.0[dat.0$gene_a != '' & dat.0$gene_b != '' & dat.0$receptor_a != dat.0$receptor_b, c('gene_a', 'gene_b', 'receptor_a', cluster)]
    dt.0 <- as.data.frame(t(apply(dt.0, 1, function(x) {if (x[3] == 'False') {c(x[1], x[2], x[4])} else {c(x[2], x[1], x[4])}})))
    
    max_Means <- max(as.numeric(c(dt[, 3], dt.0[, 3])))
    
    
    miss_dat <- setdiff(union(paste(dt[, 1], dt[, 2], sep = '|'), paste(dt.0[, 1], dt.0[, 2], sep = '|')), paste(dt[, 1], dt[, 2], sep = '|'))
    tmp <- cbind(t(as.data.frame(strsplit(miss_dat, '|', fixed = T))), 0.0, 1.0)
    
    tmp <- as.data.frame(tmp)
    colnames(tmp) <- c('Ligand', 'Receptor', 'Means', 'p')
    
    dt <- rbind(dt, tmp)
    
  }
  
  
  dt$Means <- as.numeric(dt$Means) / (max_Means + 0.000001)
  dt$p <- as.numeric(dt$p)
  
  dt <- dt[order(dt$Ligand, dt$Receptor),]
  

  fig <- plot_ly(data = dt,
                 x = ~Ligand,
                 y = ~Receptor,
                 color = ~Means,
                 colors = 'Reds',
                 type = 'scatter', mode = 'markers',
                 marker = list(size = ~(-log10((p + 0.000001) / max(p + 0.000001)) * 3.5),
                               line = list(width = 0)),
                 hoverinfo = 'text',
                 hovertext = ~paste('</br> Group: ', if (G_dir == 'g1') {'Group 1'} else {'Group 2'},
                                    '</br> Mean: ', sprintf('%.4f', Means),
                                    '</br> P-value: ', sprintf('%.4f', p),
                                    '</br> Ligand: ', sprintf('%s', Ligand),
                                    '</br> Receptor: ', sprintf('%s', Receptor)))

  fig <- fig %>% layout(title = list(text = if (G_dir == 'g1') {'Group 1'} else {'Group 2'})) %>% colorbar(limits = c(0, 1))
  
  
  return(fig)
  
}




core.inter_communication.plt.statistics.bubble.2 <- function(dbpath, data.id, G_dir, pair, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(pair)) {return(NULL)}
  
  if (is.null(data.id)) {return(NULL)}
  

  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  
  cellphonedb_path <- file.path(getwd(), dir_path, 'cellphonedb', G_dir)
  cellphonedb_path.0 <- if (G_dir == 'g1') {
    
    file.path(getwd(), dir_path, 'cellphonedb', 'g2')
    
  } else {
    
    file.path(getwd(), dir_path, 'cellphonedb', 'g1')
    
  }
  
  if (!file.exists(file.path(cellphonedb_path, 'means.txt'))) {return(NULL)}
  if (!file.exists(file.path(cellphonedb_path, 'pvalues.txt'))) {return(NULL)}
  
  
  dat <- read.table(file.path(cellphonedb_path, 'means.txt'), header = T, sep = '\t', check.names = F)
  dat.p <- read.table(file.path(cellphonedb_path, 'pvalues.txt'), header = T, sep = '\t', check.names = F)
  
  
  pair <- strsplit(pair, ' -- ')
  
  pair.1 <- pair[[1]][1]
  pair.2 <- pair[[1]][2]
  
  
  dt <- data.frame()
  dt.p <- data.frame()
  
  
  if ((pair.1 %in% dat$gene_a) & (pair.2 %in% dat$gene_b)) {
    
    dt <- t(dat[dat$gene_a == pair.1 & dat$gene_b == pair.2, 12:ncol(dat)])
    dt <- cbind(t(as.data.frame(strsplit(rownames(dt), '|', fixed = T))), dt)
    
    dt.p <- t(dat.p[dat.p$gene_a == pair.1 & dat.p$gene_b == pair.2, 12:ncol(dat.p)])
    dt.p <- cbind(t(as.data.frame(strsplit(rownames(dt.p), '|', fixed = T))), dt.p)
    
  } else {
    
    dt <- rep(0, ncol(dat) - 12 + 1)
    names(dt) <- colnames(dat)[12:ncol(dat)]
    dt <- as.data.frame(dt)
    dt <- cbind(t(as.data.frame(strsplit(rownames(dt), '|', fixed = T))), dt)
    
    dt.p <- rep(1, ncol(dat.p) - 12 + 1)
    names(dt.p) <- colnames(dat.p)[12:ncol(dat.p)]
    dt.p <- as.data.frame(dt.p)
    dt.p <- cbind(t(as.data.frame(strsplit(rownames(dt.p), '|', fixed = T))), dt.p)
    
  }
  
  max_Means <- max(as.numeric(dt[, 3]))
  
  dt <- as.data.frame(cbind(dt, dt.p[, 3]))
  colnames(dt) <- c('Cluster_with_Ligand', 'Cluster_with_Receptor', 'Means', 'p')
  
  
  if (file.exists(cellphonedb_path.0)) {
    
    dat.0 <- read.table(file.path(cellphonedb_path.0, 'means.txt'), header = T, sep = '\t', check.names = F)
    
    dt.0 <- data.frame()
    
    if ((pair.1 %in% dat.0$gene_a) & (pair.2 %in% dat.0$gene_b)) {
      
      dt.0 <- t(dat.0[dat.0$gene_a == pair.1 & dat.0$gene_b == pair.2, 12:ncol(dat.0)])
      dt.0 <- cbind(t(as.data.frame(strsplit(rownames(dt.0), '|', fixed = T))), dt.0)
      
    } else {
      
      dt.0 <- rep(0, ncol(dat.0) - 12 + 1)
      names(dt.0) <- colnames(dat.0)[12:ncol(dat.0)]
      dt.0 <- as.data.frame(dt.0)
      dt.0 <- cbind(t(as.data.frame(strsplit(rownames(dt.0), '|', fixed = T))), dt.0)
      
    }
    
    max_Means <- max(as.numeric(c(dt[, 3], dt.0[, 3])))
    
  }
  
  
  dt$Means <- as.numeric(dt$Means) / (max_Means + 0.000001)
  dt$p <- as.numeric(dt$p)
  
  
  fig <- plot_ly(data = dt,
                 x = ~Cluster_with_Ligand,
                 y = ~Cluster_with_Receptor,
                 color = ~Means,
                 colors = 'Reds',
                 type = 'scatter', mode = 'markers',
                 marker = list(size = ~(-log10((p + 0.000001) / max(p + 0.000001)) * 3.5),
                               line = list(width = 0)),
                 hoverinfo = 'text',
                 hovertext = ~paste('</br> Group: ', if (G_dir == 'g1') {'Group 1'} else {'Group 2'},
                                    '</br> Mean: ', sprintf('%.4f', Means),
                                    '</br> P-value: ', sprintf('%.4f', p),
                                    '</br> Cluster with Ligand: ', sprintf('%s', Cluster_with_Ligand),
                                    '</br> Cluster with Receptor: ', sprintf('%s', Cluster_with_Receptor)))

  fig <- fig %>% layout(title = list(text = if (G_dir == 'g1') {'Group 1'} else {'Group 2'})) %>% colorbar(limits = c(0, 1))
  
  
  return(fig)
  
}