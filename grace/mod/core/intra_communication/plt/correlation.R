core.intra_communication.plt.correlation <- function(dbpath, grp.id, G_dir, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  
  cellphonedb_path <- file.path(getwd(), dir_path, 'cellphonedb', G_dir)
  
  if (!file.exists(file.path(cellphonedb_path, 'count_network.txt'))) {return(NULL)}
  
  
  dt <- read.table(file.path(cellphonedb_path, 'count_network.txt'), header = T)
  
  dt <- tidyr::spread(dt, 'TARGET', 'count')
  rownames(dt) <- dt$SOURCE
  dt <- dt[, -1]
  
  
  fig <- plot_ly(x = colnames(dt), y = rownames(dt),
                 z = as.matrix(dt / max(dt)),
                 zmin = 0, zmax = 1,
                 type = 'heatmap',
                 xgap = 1, ygap = 1,
                 hoverinfo = 'z')
  
  
  fig
  
}