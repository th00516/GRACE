core.data_upload.ctl.integration.selection <- function(id, label, dbpath, proj.id, disp) {
  
  if (is.null(disp)) {return(NULL)}
  if (is.null(dbpath)) {return(NULL)}
  
  
  con <- DBI::dbConnect(RSQLite::SQLite(), dbpath)
  
  if ('data_records' %in% DBI::dbListTables(con)) {
    
    dt <- DBI::dbGetQuery(con, paste0('SELECT DATA_ID FROM data_records WHERE PROJ_ID == "', proj.id, '"'))
    
  }
  
  DBI::dbDisconnect(con)
  
  
  choices <- if (nrow(dt) > 0) {choices <- dt$DATA_ID} else {NULL}
  
  widget <- selectizeInput(inputId = id, label = label, multiple = T,
                           choices = NULL, selected = NULL)
  updateSelectizeInput(inputId = id, server = T, choices = choices, selected = NULL)

  
  return(widget)
  
}




core.data_upload.ctl.integration.action <- function(id, label, icon_name, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- actionButton(inputId = id, label = label, icon = icon(icon_name))
  
  
  return(widget)
  
}