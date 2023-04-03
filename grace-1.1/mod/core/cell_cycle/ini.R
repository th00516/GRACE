#### IMPORT FUNC ####
source('mod/core/cell_cycle/ctl/action.R')
source('mod/core/cell_cycle/ctl/attribution.R')


source('mod/core/cell_cycle/act/score_cell_cycle.R')


source('mod/core/cell_cycle/plt/cluster.R')
source('mod/core/cell_cycle/plt/statistics.R')
####




#### SET UI ####
core.cell_cycle.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    uiOutput('cell_cycle_ctl_1')
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('PCA', br(), plotlyOutput('cell_cycle_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('cell_cycle_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('cell_cycle_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('cell_cycle_plt_4')
  )
)
####




#### SERVER ####
core.cell_cycle <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$cell_cycle_ctl_1 <- renderUI(
    core.cell_cycle.ctl.action('cell_cycle_ctl_1', 'Cell Cycle Scoring', 'recycle',
                               DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$cell_cycle_ctl_1, {
    
    core.cell_cycle.act.score_cell_cycle(DBPATH(), DATA.ID(), DATA())
    
    assign('DATA', reactive(
      core.data_upload.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID())
    ), envir = .GlobalEnv)
    
  })
  
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$cell_cycle_ctl_1), {
    
    output$cell_cycle_plt_1 <- renderPlotly(
      core.cell_cycle.plt.cluster(DATA(), DATA_SMP(),
                                  'cell_cycle',
                                  'All',
                                  'pca',
                                  DATA.ID())
    )
    
    output$cell_cycle_plt_2 <- renderPlotly(
      core.cell_cycle.plt.cluster(DATA(), DATA_SMP(),
                                  'cell_cycle',
                                  'All',
                                  'tsne',
                                  DATA.ID())
    )
    
    output$cell_cycle_plt_3 <- renderPlotly(
      core.cell_cycle.plt.cluster(DATA(), DATA_SMP(),
                                  'cell_cycle',
                                  'All',
                                  'umap',
                                  DATA.ID())
    )
    
    output$cell_cycle_plt_4 <- renderPlotly(
      core.cell_cycle.plt.statistics.exp_dist(DATA(),
                                              'cell_cycle',
                                              input$cell_cycle_ctl_2,
                                              DATA.ID())
    )
    
  })
  
}