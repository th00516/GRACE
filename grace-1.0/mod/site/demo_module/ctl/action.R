site.demo_module.ctl.action <- function(id, label, icon_name) {
  
  widget <- actionButton(inputId = id, label = label, icon = icon(icon_name))
  
  
  return(widget)
  
}