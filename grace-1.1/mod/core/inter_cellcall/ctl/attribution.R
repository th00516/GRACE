core.inter_cellcall.ctl.attr_chooser <- function(id, label, choices, selected, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- radioGroupButtons(inputId = id, label = label, choices = choices, selected = selected, size = 'sm')
  
  
  return(widget)
  
}




core.inter_cellcall.ctl.attr_input <- function(id, label, value, disp) {
  
  if (is.null(disp)) (return(NULL))
  
  
  widget <- textInput(inputId = id, label = label, value = value)
  
  
  widget
  
}




core.inter_cellcall.ctl.attr_picker <- function(id, label, type, disp) {
  
  if (is.null(disp)) return(NULL)
  
  
  if (type == 'species')
    widget <- pickerInput(inputId = id, label = label, choices = c('Homo sapiens', 'Mus musculus'))
  
  
  return(widget)
  
}