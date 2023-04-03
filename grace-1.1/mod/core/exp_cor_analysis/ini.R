#### IMPORT FUNC ####
source('mod/core/exp_cor_analysis/ctl/attribution.R')
source('mod/core/exp_cor_analysis/ctl/cell_clustering.R')
source('mod/core/exp_cor_analysis/ctl/feature_listing.R')


source('mod/core/exp_cor_analysis/plt/correlation.R')
source('mod/core/exp_cor_analysis/plt/statistics.R')
####




#### SET UI ####
core.exp_cor_analysis.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    fluidRow(
      column(6, uiOutput('exp_cor_analysis_ctl_1'), align = 'left'),
      column(6, uiOutput('exp_cor_analysis_ctl_2'), align = 'right')
    ),
    
    hr(),
    
    uiOutput('exp_cor_analysis_ctl_3')
  ),
  
  mainPanel(width = 7,
    br(),
    
    plotlyOutput('exp_cor_analysis_plt_1'),
    
    hr(),
    
    plotlyOutput('exp_cor_analysis_plt_2')
  )
)
####




#### SERVER ####
core.exp_cor_analysis <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$exp_cor_analysis_ctl_1 <- renderUI(
    core.exp_cor_analysis.ctl.attr_chooser('exp_cor_analysis_ctl_1', 'Annotated',
                                           c('Yes', 'No'), 'Yes',
                                           DATA.ID())
  )
  
  observeEvent(input$exp_cor_analysis_ctl_1, {
    
    output$exp_cor_analysis_ctl_2 <- renderUI(
      core.exp_cor_analysis.ctl.cell_clustering('exp_cor_analysis_ctl_2',
                                                'Annotation Type',
                                                input$exp_cor_analysis_ctl_1,
                                                DATA.ID())
    )
    
  })
  
  output$exp_cor_analysis_ctl_3 <- renderUI(
    core.exp_cor_analysis.ctl.feature_listing(DATA(),
                                              'exp_cor_analysis_ctl_3', 
                                              'Select Two or More Genes',
                                              DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
  observeEvent(c(T,
                 input$denovo_annotation_ctl_5,
                 input$ref_based_annotation_ctl_2,
                 input$manual_annotation_ctl_3), {
    
    output$exp_cor_analysis_plt_1 <- renderPlotly(
      core.exp_cor_analysis.plt.statistics.exp_bub(DATA(), 
                                                   input$exp_cor_analysis_ctl_2, 
                                                   input$exp_cor_analysis_ctl_3,
                                                   DATA.ID())
    )
    
  })
  
  output$exp_cor_analysis_plt_2 <- renderPlotly(
    core.exp_cor_analysis.plt.correlation(DATA(),
                                          input$exp_cor_analysis_ctl_3,
                                          DATA.ID())
  )
  
}