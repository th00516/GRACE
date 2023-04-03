core.inter_cellchat.act.pick_pathways <- function(dbpath, data.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM data_records WHERE DATA_ID == "', data.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  pathway <- file.path(getwd(), dir_path, 'cellchat', 'g1', 'cellchatObj.rds')
  
  if (!file.exists(pathway)) return(NULL)
  
  
  obj <- readRDS(pathway)
  
  actived_pathway_list <- obj@netP$pathways
  
  
  return(actived_pathway_list)
  
}