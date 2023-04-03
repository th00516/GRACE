core.intra_communication.ctl.cell_subcluster_listing <- function(id, label, dbpath, grp.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  con <- dbConnect(RSQLite::SQLite(), dbpath)
  
  path <- dbGetQuery(
    con, paste0('SELECT DATAPATH FROM grp_records WHERE GRP_ID == "', grp.id, '"')
  )
  
  dbDisconnect(con)
  
  
  dir_path <- paste0(substr(path$DATAPATH, start = 1, stop = nchar(path$DATAPATH) -  5), '.running')
  
  cellphonedb_path <- file.path(getwd(), dir_path, 'cellphonedb', 'g1')
  
  if (!file.exists(file.path(cellphonedb_path, 'meta.txt'))) {return(NULL)}
  
  
  dat <- read.table(file.path(cellphonedb_path, 'meta.txt'))
  
  
  choices <- unique(dat$V2)
  choices <- sort(choices)
  
  selected <- NULL
  
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  widget
  
}