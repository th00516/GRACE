#### IMPORT FUNC ####
source('mod/core/data_filtering/ctl/cell_filtering.R')
source('mod/core/data_filtering/ctl/action.R')
source('mod/core/data_filtering/ctl/attribution.R')


source('mod/core/data_filtering/act/pick_cell.R')
source('mod/core/data_filtering/act/refine_data.R')


source('mod/core/data_filtering/tab/cell_counting.R')


source('mod/core/data_filtering/plt/cell_feature_umi.R')
source('mod/core/data_filtering/plt/pcs.R')
####




#### SET UI ####
core.data_filtering.UI <- sidebarLayout(
  sidebarPanel(
    uiOutput('data_filtering_ctl_attr_1'),
    uiOutput('data_filtering_ctl_attr_2'),
    uiOutput('data_filtering_ctl_attr_3'),
    uiOutput('data_filtering_ctl_attr_4'),
    uiOutput('data_filtering_ctl_attr_5'),
    
    hr(),
    
    uiOutput('data_filtering_ctl_attr_6'),
    # uiOutput('data_filtering_ctl_attr_7'),
    
    br(),
    
    plotlyOutput('data_filtering_plt_attr_1'),
    
    br(),
    
    uiOutput('data_filtering_ctl_attr_8'),
    uiOutput('data_filtering_ctl_attr_9'),
    uiOutput('data_filtering_ctl_attr_10'),
    uiOutput('data_filtering_ctl_attr_11'),
    
    hr(),
    
    DTOutput('data_filtering_tab_1'),
    
    br(),
    
    uiOutput('data_filtering_ctl_1')
  ),
  
  mainPanel(
    fluidRow(
      column(6, plotlyOutput('data_filtering_plt_1')),
      column(6, plotlyOutput('data_filtering_plt_2'))
    ),
    
    hr(),
    
    fluidRow(
      column(6, plotlyOutput('data_filtering_plt_3')),
      column(6, plotlyOutput('data_filtering_plt_4'))
    ),
    
    hr(),
    
    plotlyOutput('data_filtering_plt_5'),
    
    hr(),
    
    fluidRow(
      column(6, plotlyOutput('data_filtering_plt_6')), 
      column(6, plotlyOutput('data_filtering_plt_7'))
    )
  )
)
####




#### SERVER ####
core.data_filtering <- function(input, output) {
  
  ## INITIALIZE UI ##
  observeEvent(c(T, input$data_filtering_ctl_1), {
    
    output$data_filtering_ctl_attr_1 <- renderUI(
      core.data_filtering.ctl.abnormal_cell_filtering('data_filtering_ctl_attr_1', 'UMI Count',
                                                      DATA(), 'nCount', 100,
                                                      DATA.ID())
    )
    
    output$data_filtering_ctl_attr_2 <- renderUI(
      core.data_filtering.ctl.abnormal_cell_filtering('data_filtering_ctl_attr_2', 'Gene Count',
                                                      DATA(), 'nFeature', 100,
                                                      DATA.ID())
    )
    
    output$data_filtering_ctl_attr_3 <- renderUI(
      core.data_filtering.ctl.inactive_cell_filtering('data_filtering_ctl_attr_3', 'MT-genes (%)',
                                                      DATA(), 'pFeature.mt', 1, F,
                                                      DATA.ID())
    )
    
    output$data_filtering_ctl_attr_4 <- renderUI(
      core.data_filtering.ctl.inactive_cell_filtering('data_filtering_ctl_attr_4', 'ACTB Activity',
                                                      DATA(), 'eActivity.actb', 0.1, T,
                                                      DATA.ID())
    )
    
  })
  
  output$data_filtering_ctl_attr_5 <- renderUI(
    core.data_filtering.ctl.attr_chooser('data_filtering_ctl_attr_5', 'Doublet Removal',
                                         c('Yes', 'No'), 'No',
                                         DATA.ID())
  )
  
  output$data_filtering_ctl_attr_6 <- renderUI(
    core.data_filtering.ctl.attr_chooser('data_filtering_ctl_attr_6', 'Select Gene Set for PCA', 
                                         c('HVGs', 'All Genes'), 'HVGs',
                                         DATA.ID())
  )
  
  # output$data_filtering_ctl_attr_7 <- renderUI(
  #   core.data_filtering.ctl.attr_chooser('data_filtering_ctl_attr_7', 'Ignore PC1',
  #                                        c('Yes', 'No'), 'No',
  #                                        DATA.ID())
  # )
  
  output$data_filtering_ctl_attr_8 <- renderUI(
    core.data_filtering.ctl.attr_chooser('data_filtering_ctl_attr_8', 'Top PCs',
                                         c(5, 10, 15, 20, 30, 40, 50), 20,
                                         DATA.ID())
  )
  
  output$data_filtering_ctl_attr_9 <- renderUI(
    core.data_filtering.ctl.attr_chooser('data_filtering_ctl_attr_9', 'min.dist in RunUMAP',
                                         c(0.8, 0.5, 0.3, 0.1, 0.07, 0.04, 0.01), 0.1,
                                         DATA.ID())
  )
  
  output$data_filtering_ctl_attr_10 <- renderUI(
    core.data_filtering.ctl.attr_chooser('data_filtering_ctl_attr_10', 'k.param of kNN',
                                         c(5, 10, 20, 50, 80, 100), 20,
                                         DATA.ID())
  )
  
  output$data_filtering_ctl_attr_11 <- renderUI(
    core.data_filtering.ctl.attr_chooser('data_filtering_ctl_attr_11', 'Cluster Algorithms', 
                                         c('Lou.' = 1, 'Lou.re' = 2, 'SLM' = 3, 'Lei' = 4), 2,
                                         DATA.ID())
  )
  
  output$data_filtering_ctl_1 <- renderUI(
    core.data_filtering.ctl.action('data_filtering_ctl_1', 'EXEC', 'play',
                                   DATA.ID())
  )
  
  
  
  
  ## INITIALIZE DATA ##
  observeEvent(c(input$data_filtering_ctl_attr_1,
                 input$data_filtering_ctl_attr_2,
                 input$data_filtering_ctl_attr_3,
                 input$data_filtering_ctl_attr_4,
                 input$data_filtering_ctl_attr_5), {
                   
    core.data_filtering.act.pick_cell(DATA(),
                                      input$data_filtering_ctl_attr_1,
                                      input$data_filtering_ctl_attr_2,
                                      input$data_filtering_ctl_attr_3,
                                      input$data_filtering_ctl_attr_4,
                                      input$data_filtering_ctl_attr_5)
                   
  })
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$data_filtering_ctl_1, {
    
    attr <- list(input$data_filtering_ctl_attr_6,
                 # input$data_filtering_ctl_attr_7,
                 'No',
                 input$data_filtering_ctl_attr_8,
                 input$data_filtering_ctl_attr_9,
                 input$data_filtering_ctl_attr_10,
                 input$data_filtering_ctl_attr_11,
                 input$data_filtering_ctl_attr_12,
                 input$data_filtering_ctl_attr_13)
    
    core.data_filtering.act.refine_data(DBPATH(), DATA.ID(), DATA(), attr)
    
    assign('DATA', reactive(
      core.data_upload.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID())
    ), envir = .GlobalEnv)
    
  })
  
  
  
  
  ## TABLE ##
  observeEvent(c(input$data_filtering_ctl_attr_1,
                 input$data_filtering_ctl_attr_2,
                 input$data_filtering_ctl_attr_3,
                 input$data_filtering_ctl_attr_4,
                 input$data_filtering_ctl_attr_5), {
                   
    output$data_filtering_tab_1 <- renderDT(
      core.data_filtering.tab.cell_counting(DATA(),
                                            DATA.ID())
    )
        
  })
  
  
  
  ## PLOT ##
  output$data_filtering_plt_attr_1 <- renderPlotly(
    core.data_filtering.plt.pcs.elbow(DATA(),
                                      DATA.ID())
  )
  
  observeEvent(c(input$data_filtering_ctl_attr_1,
                 input$data_filtering_ctl_attr_2,
                 input$data_filtering_ctl_attr_3,
                 input$data_filtering_ctl_attr_4,
                 input$data_filtering_ctl_attr_5), {
                   
    output$data_filtering_plt_1 <- renderPlotly(
      core.data_filtering.plt.feature.vln(DATA(), 'nCount',
                                          DATA.ID())
    )
    
    output$data_filtering_plt_2 <- renderPlotly(
      core.data_filtering.plt.feature.vln(DATA(), 'nFeature',
                                          DATA.ID())
    )
    
    output$data_filtering_plt_3 <- renderPlotly(
      core.data_filtering.plt.feature.vln(DATA(), 'pFeature.mt',
                                          DATA.ID())
    )
    
    output$data_filtering_plt_4 <- renderPlotly(
      core.data_filtering.plt.feature.vln(DATA(), 'eActivity.actb',
                                          DATA.ID())
    )
     
    output$data_filtering_plt_5 <- renderPlotly(
      core.data_filtering.plt.cell_umi.drp(DATA(),
                                           DATA.ID())
    )
    
    output$data_filtering_plt_6 <- renderPlotly(
      core.data_filtering.plt.feature_umi.sct(DATA(),
                                              DATA.ID())
    )
    
    output$data_filtering_plt_7 <- renderPlotly(
      core.data_filtering.plt.feature_umi.hst(DATA(),
                                              DATA.ID())
    )
    
  })
  
}