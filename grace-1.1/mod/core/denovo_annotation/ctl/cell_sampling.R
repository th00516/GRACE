core.denovo_annotation.ctl.cell_sampling <- function(id, label, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  choices = c('~1%' = 0.01, 
              '~5%' = 0.05, 
              '~10%' = 0.1, 
              '~30%' = 0.3, 
              '~60%' = 0.6,
              '~90%' = 0.9,
              'All Cells' = 1.0)
  
  selected = 0.1
  
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  return(widget)
  
}