core.ref_based_annotation.ctl.mapping_ref.selection <- function(id, label, disp) {
  
  if (is.null(disp)) {return(NULL)}
  
  
  choices <- c('Human PBMC 10k' = 'mod/core/ref_based_annotation/dbs/human_pbmc10k.rds',
               'Human Bone Marrow' = 'mod/core/ref_based_annotation/dbs/human_bone_marrow.rds',
               'Human Kidney' = 'mod/core/ref_based_annotation/dbs/human_kidney.rds',
               'Mouse Motor Cortex' = 'mod/core/ref_based_annotation/dbs/mouse_motor_cortex.rds')
  
  selected <- NULL
  
  
  widget <- pickerInput(inputId = id, label = label, multiple = F, 
                        choices = choices, selected = selected)
  
  
  widget
  
}