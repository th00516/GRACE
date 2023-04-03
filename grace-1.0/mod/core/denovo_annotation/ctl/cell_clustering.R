core.denovo_annotation.ctl.cell_clustering <- function(id, label, switch, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  choices <- c('Resolution 0.2' = 'clusters.0.2',
               'Resolution 0.5' = 'clusters.0.5',
               'Resolution 0.8' = 'clusters.0.8',
               'Resolution 1.2' = 'clusters.1.2')
  
  selected <- 'clusters.0.5'
  
  if (switch == 'Yes') {

    choices <- c('SingleR Main-label' = 'clusters.ann.SingleR.main',
                 'SingleR Fine-label' = 'clusters.ann.SingleR.fine',
                 'Sample Group' = 'Group')
    
    selected <- 'clusters.ann.SingleR.main'

  }
  
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  return(widget)
  
}