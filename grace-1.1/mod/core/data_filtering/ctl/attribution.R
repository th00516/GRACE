core.data_filtering.ctl.attr_chooser <- function(id, label, choices, selected, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- radioGroupButtons(inputId = id, label = label, choices = choices, selected = selected, size = 'sm')
  
  
  return(widget)
  
}




core.data_filtering.ctl.attr_picker <- function(id, label, type, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  if (type == 'classifier')
    widget <- pickerInput(inputId = id, label = label, choices = c('LinearSVC',
                                                                   'ExtraTreesClassifier'))
  
  
  return(widget)
  
}




core.data_filtering.ctl.attr_input <- function(id, label, value, disp) {
  
  if (is.null(disp)) (return(NULL))
  
  
  widget <- textInput(inputId = id, label = label, value = value)
  
  
  widget
  
}