core.intra_cellchat.plt <- function(dbpath, grp.id, G_dir, picked_pathway, plt_type, disp) {
  
  if (is.null(disp)) return(NULL)
  if (is.null(picked_pathway)) return(NULL)
  if (is.null(type)) return(NULL)
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  cellchat_path <- file.path(getwd(), dir_path, 'cellchat', G_dir, 'cellchatObj.rds')
  
  if (!file.exists(cellchat_path)) return(NULL)
  
  
  cellchatObj <- readRDS(cellchat_path)
  
  
  if (plt_type == 'bubble')
    fig <- netVisual_bubble(cellchatObj, signaling = picked_pathway)
  
  if (plt_type == 'aggregate')
    fig <- netVisual_aggregate(cellchatObj, signaling = picked_pathway)
  
  if (plt_type == 'heatmap')
    fig <- netVisual_heatmap(cellchatObj, signaling = picked_pathway)
  
  if (plt_type == 'exp')
    fig <- plotGeneExpression(cellchatObj, signaling = picked_pathway)
  
  
  return(fig)
  
}