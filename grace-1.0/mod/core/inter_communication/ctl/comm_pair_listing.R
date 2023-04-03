core.inter_communication.ctl.comm_pair_listing <- function(id, label, dbpath, data.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  
  cellphonedb_path.1 <- file.path(getwd(), dir_path, 'cellphonedb', 'g1')
  cellphonedb_path.2 <- file.path(getwd(), dir_path, 'cellphonedb', 'g2')

  choices.1 <- if (file.exists(file.path(cellphonedb_path.1, 'means.txt'))) {
    
    dat <- read.table(file.path(cellphonedb_path.1, 'means.txt'), header = T, sep = '\t', check.names = F)
    
    dat <- dat[dat$gene_a != '' & dat$gene_b != '' & dat$receptor_a != dat$receptor_b, c('gene_a', 'gene_b',  'receptor_a')]
    value <- paste(dat$gene_a, dat$gene_b, sep = ' -- ')
    
    dat <- as.data.frame(t(apply(dat, 1, function(x) { if (x[3] == 'False') {c(x[1], x[2])} else (c(x[2], x[1]))})))
    pair <- paste(dat$V1, dat$V2, sep = ' -- ')
    
    choices <- data.frame(pair = pair, value = value)
    
    choices
    
  } else {NULL}
  
  choices.2 <- if (file.exists(file.path(cellphonedb_path.2, 'means.txt'))) {
    
    dat <- read.table(file.path(cellphonedb_path.2, 'means.txt'), header = T, sep = '\t', check.names = F)
    
    dat <- dat[dat$gene_a != '' & dat$gene_b != '' & dat$receptor_a != dat$receptor_b, c('gene_a', 'gene_b',  'receptor_a')]
    value <- paste(dat$gene_a, dat$gene_b, sep = ' -- ')
    
    dat <- as.data.frame(t(apply(dat, 1, function(x) {if (x[3] == 'False') {c(x[1], x[2])} else {c(x[2], x[1])}})))
    pair <- paste(dat$V1, dat$V2, sep = ' -- ')
    
    choices <- data.frame(pair = pair, value = value)
    
    choices
    
  } else {NULL}
  
  choices <- NULL
  
  if (!is.null(choices.1)) {
    
    tmp <- unique(rbind(choices.1, choices.2))
    tmp <- tmp[order(tmp$pair),]
    
    choices <- tmp[, 'value']
    names(choices) <- tmp[, 'pair']
    
  }
  
  selected <- NULL
  
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  widget
  
}