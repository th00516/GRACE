core.cell_cycle.ctl.attr_picker <- function(id, label, choices, selected, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  return(widget)
  
}