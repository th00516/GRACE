core.defined_subcluster.ctl.action <- function(id, label, icon_name, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- actionButton(inputId = id, label = label, icon = icon(icon_name))
  
  
  widget
  
}




core.defined_subcluster.ctl.downloadSlot <- function(id, disp) {
  
  if (is.null(disp)) return(NULL)
  
  
  widget <- downloadButton(outputId = id,
                           label = 'Data Download',
                           icon = icon('download'))
  
  
  return(widget)
  
}