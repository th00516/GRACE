core.manual_annotation.act.reset_annotation <- function(D, C_type) {
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(C_type)) {
    
    return(NULL)
    
  } else {
    
    return(levels(D$var[[C_type]]))
    
  }
  
}