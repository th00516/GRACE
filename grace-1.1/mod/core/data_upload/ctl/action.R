core.data_upload.ctl.action <- function(id, label, icon_name, disp) {
  
  if (is.null(disp)) return(NULL)
  
  
  widget <- actionButton(inputId = id, label = label, icon = icon(icon_name))
  
  
  return(widget)
  
}




core.data_upload.ctl.downloadSlot <- function(id, disp) {
  
  if (is.null(disp)) return(NULL)
  
  
  widget <- downloadButton(outputId = id,
                           label = 'Data Download',
                           icon = icon('download'))
  
  
  return(widget)
  
}