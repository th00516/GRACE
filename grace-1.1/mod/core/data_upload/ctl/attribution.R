core.data_upload.ctl.attr_input <- function(id, label, placeholder, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- textInput(inputId = id, label = label, placeholder = placeholder)
  
  
  return(widget)
  
}




core.data_upload.ctl.attr_chooser <- function(id, label, choices, selected, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- radioGroupButtons(inputId = id, label = label, choices = choices, selected = selected, size = 'sm')
  
  
  return(widget)
  
}




core.data_upload.ctl.attr_picker <- function(id, label, type, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  if (type == 'species')
    widget <- pickerInput(inputId = id, label = label, choices = c('Homo sapiens', 'Mus musculus'))
  
  if (type == 'groups')
    widget <- pickerInput(inputId = id, label = label, choices = c('Group 1', 'Group 2'))
  
  if (type == 'lib_pltf')
    widget <- pickerInput(inputId = id, label = label, choices = c('10X Genomics', 'BD Biosciences'))
  
  if (type == 'lib_type')
    widget <- pickerInput(inputId = id, label = label, choices = c('scRNA'))
  
  if (type == 'sep_pltf')
    widget <- pickerInput(inputId = id, label = label, choices = c('Illumina'))
  
  if (type == 'inMethod')
    widget <- pickerInput(inputId = id, label = label, choices = c('RPCA', 'FastMNN', 'Harmony', 'scVI', 'scANVI'))
  
  
  return(widget)
  
}