core.data_upload.ctl.file_importing <- function(id, label, accept, placeholder, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  widget <- fileInput(inputId = id, label = label,
                      multiple = F,
                      accept = accept,
                      placeholder = placeholder)
  
  
  return(widget)
  
}