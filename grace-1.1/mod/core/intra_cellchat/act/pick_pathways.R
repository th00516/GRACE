core.intra_cellchat.act.pick_pathways <- function(dbpath, grp.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  pathway <- file.path(getwd(), dir_path, 'cellchat', 'g1', 'cellchatObj.rds')
  
  if (!file.exists(pathway)) return(NULL)
  
  
  obj <- readRDS(pathway)
  
  actived_pathway_list <- obj@netP$pathways
  
  
  return(actived_pathway_list)
  
}