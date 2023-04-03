core.spring_analysis.ctl.force_directed_graph <- function(proj_id, data_id, grp_id) {
  
  if (is.null(proj_id)) return(NULL)
  if (is.null(data_id)) return(NULL)
  if (is.null(grp_id)) return(NULL)

  
  inline_page = tags$iframe(src = file.path('http://localhost:8000/springViewer.html?datasets/',
                                            proj_id,
                                            paste0(data_id, '.', grp_id, '.running/spring')),
                            style = 'height:700px;width:100%')
  
  
  return(inline_page)
  
}
