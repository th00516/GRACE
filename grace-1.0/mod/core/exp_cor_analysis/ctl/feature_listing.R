core.exp_cor_analysis.ctl.feature_listing <- function(D, id, label, disp) {
  
  if (is.null(disp)) (return(NULL))
  
  
  choices <- D$obs_names
  selected <- NULL
  
  
  widget <- selectizeInput(inputId = id, label = label, multiple = T,
                           choices = NULL, selected = NULL)
  updateSelectizeInput(inputId = id, server = T, choices = choices, selected = selected)
  
  
  widget
  
}