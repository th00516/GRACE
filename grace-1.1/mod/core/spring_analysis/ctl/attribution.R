core.spring_analysis.ctl.attr_input <- function(id, label, value, disp) {
  
  if (is.null(disp)) (return(NULL))
  
  
  widget <- textInput(inputId = id, label = label, value = value)
  
  
  widget
  
}