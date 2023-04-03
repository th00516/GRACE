#### IMPORT FUNC ####
source('mod/core/ddrtree_analysis/ctl/action.R')
source('mod/core/ddrtree_analysis/ctl/attribution.R')
source('mod/core/ddrtree_analysis/ctl/cell_clustering.R')


source('mod/core/ddrtree_analysis/act/exec_monocle.R')


source('mod/core/ddrtree_analysis/tab/feature_listing.R')
source('mod/core/ddrtree_analysis/tab/cluster_listing.R')


source('mod/core/ddrtree_analysis/plt/cluster.R')
source('mod/core/ddrtree_analysis/plt/cluster_heatmap.R')
source('mod/core/ddrtree_analysis/plt/statistics.R')
####




#### SET UI ####
core.ddrtree_analysis.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    uiOutput('ddrtree_analysis_ctl_exec_1'),
    
    hr(),
    
    fluidRow(
      column(6, uiOutput('ddrtree_analysis_ctl_1'), align = 'left'),
      column(6, uiOutput('ddrtree_analysis_ctl_2'), align = 'right')
    ),
    
    hr(),
    
    uiOutput('ddrtree_analysis_ctl_3'),
    
    hr(),
    
    DTOutput('ddrtree_analysis_tab_1'),
    
    hr(),
    
    DTOutput('ddrtree_analysis_tab_2')
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('Cluster', br(), plotlyOutput('ddrtree_analysis_plt_1')),
      tabPanel('State', br(), plotlyOutput('ddrtree_analysis_plt_2')),
      tabPanel('Pseudotime', br(), plotlyOutput('ddrtree_analysis_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('ddrtree_analysis_plt_4')
  )
)
####




#### SERVER ####
core.ddrtree_analysis <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$ddrtree_analysis_ctl_exec_1 <- renderUI(
    core.ddrtree_analysis.ctl.action('ddrtree_analysis_ctl_exec_1', 'Exec Monocle2', 'play',
                                     GRP.ID())
  )
  
  output$ddrtree_analysis_ctl_1 <- renderUI(
    core.ddrtree_analysis.ctl.attr_chooser('ddrtree_analysis_ctl_1', 'Annotated',
                                           c('Yes', 'No'), 'Yes',
                                           GRP.ID())
  )
  
  observeEvent(input$ddrtree_analysis_ctl_1, {
    
    output$ddrtree_analysis_ctl_2 <- renderUI(
      core.ddrtree_analysis.ctl.cell_clustering('ddrtree_analysis_ctl_2', 'Annotation Type',
                                                input$ddrtree_analysis_ctl_1,
                                                GRP.ID())
    )
    
  })
  
  output$ddrtree_analysis_ctl_3 <- renderUI(
    core.ddrtree_analysis.ctl.attr_chooser('ddrtree_analysis_ctl_3', 'Separated by Group',
                                           c('Yes', 'No'), 'No',
                                           GRP.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$ddrtree_analysis_ctl_exec_1, {
    
    core.ddrtree_analysis.act.exec_monocle(DBPATH(), GRP.ID(), GRP())
    
    assign('GRP', reactive(
      core.defined_subcluster.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID(), GRP.ID())
    ), envir = .GlobalEnv)
    
  })
  
  
  
  
  ## TABLE ##
  output$ddrtree_analysis_tab_1 <- renderDT(
    core.ddrtree_analysis.tab.feature_listing(GRP(),
                                              GRP.ID())
  )
  
  observeEvent(c(input$ddrtree_analysis_ctl_2), {
    
    output$ddrtree_analysis_tab_2 <- renderDT(
      core.ddrtree_analysis.tab.cluster_listing(GRP(),
                                                input$ddrtree_analysis_ctl_2,
                                                GRP.ID())
    )
    
  })
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$ddrtree_analysis_ctl_exec_1), {
    
    output$ddrtree_analysis_plt_1 <- renderPlotly(
      core.ddrtree_analysis.plt.cluster(GRP(),
                                        input$ddrtree_analysis_ctl_2,
                                        'ddrtree',
                                        input$ddrtree_analysis_tab_1_rows_selected,
                                        input$ddrtree_analysis_ctl_3,
                                        GRP.ID())
    )
    
    output$ddrtree_analysis_plt_2 <- renderPlotly(
      core.ddrtree_analysis.plt.cluster(GRP(),
                                        'State',
                                        'ddrtree',
                                        input$ddrtree_analysis_tab_1_rows_selected,
                                        input$ddrtree_analysis_ctl_3,
                                        GRP.ID())
    )
    
    output$ddrtree_analysis_plt_3 <- renderPlotly(
      core.ddrtree_analysis.plt.cluster_heatmap(GRP(),
                                                input$ddrtree_analysis_ctl_2,
                                                'Pseudotime',
                                                'ddrtree',
                                                GRP.ID())
    )
    
    output$ddrtree_analysis_plt_4 <- renderPlotly(
      core.ddrtree_analysis.plt.statistics.exp_dist(GRP(),
                                                    input$ddrtree_analysis_ctl_2,
                                                    input$ddrtree_analysis_tab_1_rows_selected,
                                                    input$ddrtree_analysis_ctl_3,
                                                    GRP.ID())
    )
    
  })
  
}