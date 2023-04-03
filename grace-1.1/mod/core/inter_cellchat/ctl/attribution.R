core.inter_cellchat.ctl.attr_chooser <- function(id, label, choices, selected, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- radioGroupButtons(inputId = id, label = label, choices = choices, selected = selected, size = 'sm')
  
  
  return(widget)
  
}




core.inter_cellchat.ctl.attr_picker <- function(id, label, type, disp) {
  
  if (is.null(disp)) return(NULL)
  
  
  if (type == 'species')
    widget <- pickerInput(inputId = id, label = label, choices = c('Homo sapiens', 'Mus musculus'))
  
  if (type == 'db_type')
    widget <- pickerInput(inputId = id, label = label, choices = c('Secreted Signaling'))
  
  
  return(widget)
  
}




core.inter_cellchat.ctl.attr_picker.mutable <- function(id, label, choices, disp) {
  
  if (is.null(disp)) return(NULL)
  
  
  widget <- pickerInput(inputId = id, label = label, choices = choices)
  
  
  return(widget)
  
}