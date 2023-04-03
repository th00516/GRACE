core.denovo_annotation.ctl.file_importing <- function(id, label, accept, placeholder, switch) {
  
  if (switch == 'No') {return(NULL)}
  
  
  widget <- fileInput(inputId = id, label = label,
                      multiple = F,
                      accept = accept,
                      placeholder = placeholder)
  
  
  return(widget)
  
}