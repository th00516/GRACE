#### IMPORT FUNC ####
source('mod/core/spring_analysis/ctl/action.R')
source('mod/core/spring_analysis/ctl/attribution.R')
source('mod/core/spring_analysis/ctl/force_directed_graph.R')


source('mod/core/spring_analysis/act/exec_spring.R')
####




#### SET UI ####
core.spring_analysis.UI <- fluidPage(
  br(),
  
  column(2, uiOutput('spring_analysis_ctl_1')),
  column(2, uiOutput('spring_analysis_ctl_2')),
  column(2, uiOutput('spring_analysis_ctl_3')),
  column(2, uiOutput('spring_analysis_ctl_4')),
  column(2, uiOutput('spring_analysis_ctl_5')),
  column(2, uiOutput('spring_analysis_ctl_6')),
  
  column(12, uiOutput('spring_analysis_exec')),
  
  column(12, hr(), uiOutput('spring_analysis_viewer'))
)
####




#### SERVER ####
core.spring_analysis <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$spring_analysis_ctl_1 <- renderUI(
    core.spring_analysis.ctl.attr_input('spring_analysis_ctl_1', 'Minimum UMI Counts', 1000, GRP.ID())
  )
  
  output$spring_analysis_ctl_2 <- renderUI(
    core.spring_analysis.ctl.attr_input('spring_analysis_ctl_2', 'Minimum Mean Expression', 0.1, GRP.ID())
  )
  
  output$spring_analysis_ctl_3 <- renderUI(
    core.spring_analysis.ctl.attr_input('spring_analysis_ctl_3', 'Minimum Fano Factor', 3, GRP.ID())
  )
  
  output$spring_analysis_ctl_4 <- renderUI(
    core.spring_analysis.ctl.attr_input('spring_analysis_ctl_4', 'Number of PCA Dimension', 20, GRP.ID())
  )
  
  output$spring_analysis_ctl_5 <- renderUI(
    core.spring_analysis.ctl.attr_input('spring_analysis_ctl_5', 'Number of Nearest Neighbor', 5, GRP.ID())
  )
  
  output$spring_analysis_ctl_6 <- renderUI(
    core.spring_analysis.ctl.attr_input('spring_analysis_ctl_6', 'Fold-change of Coarse-grain', 1, GRP.ID())
  )
  
  output$spring_analysis_exec <- renderUI(
    core.spring_analysis.ctl.action('spring_analysis_exec', 'Exec SPRING', 'play', GRP.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$spring_analysis_exec, {
    
    args <- c(input$spring_analysis_ctl_1,
              input$spring_analysis_ctl_2,
              input$spring_analysis_ctl_3,
              input$spring_analysis_ctl_4,
              input$spring_analysis_ctl_5,
              input$spring_analysis_ctl_6)
    
    core.spring_analysis.act.exec_spring(DBPATH(), GRP.ID(), GRP(), args)
    
  })
  
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$spring_analysis_exec), {
    
    output$spring_analysis_viewer <- renderUI(core.spring_analysis.ctl.force_directed_graph(PROJ.ID(),
                                                                                            DATA.ID(),
                                                                                            GRP.ID()))
    
  })
}