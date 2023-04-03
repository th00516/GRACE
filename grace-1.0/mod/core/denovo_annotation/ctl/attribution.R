core.denovo_annotation.ctl.attr_chooser <- function(id, label, choices, selected, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- radioGroupButtons(inputId = id, label = label, choices = choices, selected = selected, size = 'sm')
  
  
  return(widget)
  
}




core.denovo_annotation.ctl.attr_picker <- function(id, label, choices, selected, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  return(widget)
  
}