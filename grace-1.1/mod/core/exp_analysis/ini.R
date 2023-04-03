#### IMPORT FUNC ####
source('mod/core/exp_analysis/ctl/attribution.R')
source('mod/core/exp_analysis/ctl/cell_clustering.R')


source('mod/core/exp_analysis/tab/feature_listing.R')


source('mod/core/exp_analysis/plt/cluster_heatmap.R')
source('mod/core/exp_analysis/plt/statistics.R')
####




#### SET UI ####
core.exp_analysis.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    DTOutput('exp_analysis_tab_1'),
    
    hr(),
    
    fluidRow(
      column(6, uiOutput('exp_analysis_ctl_1'), align = 'left'),
      column(6, uiOutput('exp_analysis_ctl_2'), align = 'right')
    )
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('PCA',  br(), plotlyOutput('exp_analysis_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('exp_analysis_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('exp_analysis_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('exp_analysis_plt_4')
  )
)
####




#### SERVER ####
core.exp_analysis <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$exp_analysis_ctl_1 <- renderUI(
    core.exp_analysis.ctl.attr_chooser('exp_analysis_ctl_1', 'Annotated',
                                       c('Yes', 'No'), 'Yes',
                                       DATA.ID())
  )
  
  observeEvent(input$exp_analysis_ctl_1, {
    
    output$exp_analysis_ctl_2 <- renderUI(
      core.exp_analysis.ctl.cell_clustering('exp_analysis_ctl_2',
                                            'Annotation Type',
                                            input$exp_analysis_ctl_1,
                                            DATA.ID())
    )
    
  })
  
  
  
  
  ## ACTIVITY ##
  
  
  
  
  ## TABLE ##
  output$exp_analysis_tab_1 <- renderDT(
    core.exp_analysis.tab.feature_listing(DATA(),
                                          DATA.ID())
  )
  
  
  
  
  ## PLOT ##
  output$exp_analysis_plt_1 <- renderPlotly(
    core.exp_analysis.plt.cluster_heatmap(DATA(), DATA_SMP(),
                                          input$exp_analysis_ctl_2,
                                          input$exp_analysis_tab_1_rows_selected,
                                          'pca',
                                          DATA.ID())
  )
  
  output$exp_analysis_plt_2 <- renderPlotly(
    core.exp_analysis.plt.cluster_heatmap(DATA(), DATA_SMP(),
                                          input$exp_analysis_ctl_2,
                                          input$exp_analysis_tab_1_rows_selected,
                                          'tsne',
                                          DATA.ID())
  )
  
  output$exp_analysis_plt_3 <- renderPlotly(
    core.exp_analysis.plt.cluster_heatmap(DATA(), DATA_SMP(),
                                          input$exp_analysis_ctl_2,
                                          input$exp_analysis_tab_1_rows_selected,
                                          'umap',
                                          DATA.ID())
  )
  
  observeEvent(c(T,
                 input$denovo_annotation_ctl_5,
                 input$ref_based_annotation_ctl_2,
                 input$manual_annotation_ctl_3), {
    
    output$exp_analysis_plt_4 <- renderPlotly(
      core.exp_analysis.plt.statistics.exp_dist(DATA(), 
                                                input$exp_analysis_ctl_2,
                                                input$exp_analysis_tab_1_rows_selected,
                                                DATA.ID())
    )
  
  })
  
}