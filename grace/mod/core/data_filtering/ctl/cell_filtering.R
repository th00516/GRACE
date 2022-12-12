core.data_filtering.ctl.abnormal_cell_filtering <- function(id, label, D, P_type, step, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  min = min(D$var[[P_type]]) %/% step * step
  max = (max(D$var[[P_type]]) + step) %/% step * step
  
  choices <- seq(min, max, step)
  selected <- c(min, max)
  
  
  widget <- sliderTextInput(inputId = id, label = label,
                            choices = choices, selected = selected,
                            grid = T)
  
  
  return(widget)
  
}




core.data_filtering.ctl.inactive_cell_filtering <- function(id, label, D, P_type, step, switch, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  min <- min(D$var[[P_type]]) %/% step * step
  max <- (max(D$var[[P_type]]) + step) %/% step * step
  
  choices <- seq(min, max, step)
  selected <- if (switch == T) {c(min, max)} else {max}
  
  
  widget <- sliderTextInput(inputId = id, label = label,
                            choices = choices, selected = selected,
                            grid = T)
  
  
  return(widget)
  
}