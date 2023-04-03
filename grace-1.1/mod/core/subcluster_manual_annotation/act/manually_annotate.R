core.subcluster_manual_annotation.act.manually_annotate <- function(current_manual_annotation, new_annotated_name) {
  
  current_manual_annotation[new_annotated_name$row] <- new_annotated_name$value
  
  return(current_manual_annotation)
  
}