core.denovo_annotation.act.sample_cell <- function(D, C_type, sample_rate) {
  
  D <- D[, D$var$isUsed]
  
  
  if (is.null(D$var[[C_type]])) {return(NULL)}
  
  sample_num.cluster <- round(table(D$var[[C_type]]) * as.numeric(sample_rate))
  
  subset.sampled <- unlist(
    lapply(names(sample_num.cluster), function(x) {
      
      sample(D$var_names[D$var[[C_type]] %in% x], sample_num.cluster[[x]])
      
    })
  )
  
  
  return(subset.sampled)
  
}