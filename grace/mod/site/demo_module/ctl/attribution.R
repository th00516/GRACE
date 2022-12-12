site.demo_module.ctl.attr_1 <- function(id, label, choices, selected) {
  
  widget <- radioGroupButtons(inputId = id, label = label,
                              choices = choices, selected = selected,
                              size = 'sm')
  
  
  return(widget)
  
}




site.demo_module.ctl.attr_2 <- function(id, label, choices, selected) {
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  return(widget)
  
}