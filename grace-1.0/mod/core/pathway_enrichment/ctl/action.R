core.pathway_enrichment.ctl.action <- function(id, label, icon_name, disp) {
  
  if (is.null(disp)) (return(NULL))
  
  
  widget <- actionButton(inputId = id, label = label, icon = icon(icon_name))
  
  
  widget
  
}