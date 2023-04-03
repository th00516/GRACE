core.intra_cellcall.plt.plot.bubble <- function(dbpath, grp.id, G_dir, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  pathway_path <- file.path(getwd(), dir_path, 'cellcall', G_dir, 'pathway.list.rds')
  
  if (!file.exists(pathway_path)) return(NULL)
  
  
  cellcallObj <- readRDS(pathway_path)
  
  myPub.df <- getForBubble(cellcallObj, cella_cellb = names(cellcallObj))
  
  
  if (G_dir == 'g1') title <- 'Group 1'
  if (G_dir == 'g2') title <- 'Group 2'
  
  
  fig <- plotBubble(myPub.df) + ggtitle(title)
  
  
  return(fig)
  
}




core.intra_cellcall.plt.plot.circle <- function(dbpath, grp.id, G_dir, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  cellcall_path <- file.path(getwd(), dir_path, 'cellcall', G_dir, 'cellcallObj.rds')
  
  if (!file.exists(cellcall_path)) return(NULL)
  
  
  cellcallObj <- readRDS(cellcall_path)
  
  
  color <- colorRampPalette(ggsci::pal_npg()(10))(length(unique(cellcallObj@meta.data$celltype)))
  cell_color <- data.frame(color = color, row.names = unique(cellcallObj@meta.data$celltype))
  
  
  if (G_dir == 'g1') title <- 'Group 1'
  if (G_dir == 'g2') title <- 'Group 2'
  
  
  fig <- ViewInterCircos(object = cellcallObj, cellColor = cell_color,
                         lrColor = c('#F16B6F', '#84B1ED'),
                         arr.type = 'big.arrow', arr.length = 0.04,
                         trackhight1 = 0.05, slot = 'expr_l_r_log2_scale',
                         linkcolor.from.sender = T,
                         linkcolor = NULL, gap.degree = 2,
                         trackhight2 = 0.032, track.margin2 = c(0.01, 0.12), DIY = F)
  
  
  return(fig)
  
}