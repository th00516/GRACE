#### IMPORT FUNC ####
source('mod/core/pathway_enrichment/ctl/action.R')
source('mod/core/pathway_enrichment/ctl/attribution.R')
source('mod/core/pathway_enrichment/ctl/cell_clustering.R')


source('mod/core/pathway_enrichment/act/exec_clusterprofiler.R')


source('mod/core/pathway_enrichment/tab/pathway_listing.R')


source('mod/core/pathway_enrichment/plt/cluster_heatmap.R')
source('mod/core/pathway_enrichment/plt/statistics.R')
source('mod/core/pathway_enrichment/plt/pcs.R')
####




#### SET UI ####
core.pathway_enrichment.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    plotlyOutput('pathway_enrichment_plt_attr_1'),
    
    br(),
    
    uiOutput('pathway_enrichment_ctl_attr_1'),
    uiOutput('pathway_enrichment_ctl_exec_1'),
    
    hr(),
    
    DTOutput('pathway_enrichment_tab_1'),
    
    hr(),
    
    fluidRow(
      column(6, uiOutput('pathway_enrichment_ctl_1'), align = 'left'),
      column(6, uiOutput('pathway_enrichment_ctl_2'), align = 'right')
    )
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('PCA', br(), plotlyOutput('pathway_enrichment_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('pathway_enrichment_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('pathway_enrichment_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('pathway_enrichment_plt_4'),
    
    hr(),
    
    plotlyOutput('pathway_enrichment_plt_5')
  )
)
####




#### SERVER ####
core.pathway_enrichment <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$pathway_enrichment_ctl_1 <- renderUI(
    core.pathway_enrichment.ctl.attr_chooser('pathway_enrichment_ctl_1', 'Annotated',
                                             c('Yes', 'No'), 'Yes',
                                             GRP.ID())
  )
  
  observeEvent(input$pathway_enrichment_ctl_1, {
    
    output$pathway_enrichment_ctl_2 <- renderUI(
      core.pathway_enrichment.ctl.cell_clustering('pathway_enrichment_ctl_2', 'Annotation Type', input$pathway_enrichment_ctl_1,
                                                  GRP.ID())
    )
    
  })
  
  output$pathway_enrichment_ctl_attr_1 <- renderUI(
    core.pathway_enrichment.ctl.attr_chooser('pathway_enrichment_ctl_3', 'Set threshold for PCs',
                                             c(1, 5, 10, 15, 20), 10,
                                             GRP.ID())
  )
  
  output$pathway_enrichment_ctl_exec_1 <- renderUI(
    core.pathway_enrichment.ctl.action('pathway_enrichment_ctl_exec_1', 'Exec ClusterProfiler', 'play',
                                       GRP.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$pathway_enrichment_ctl_exec_1, {
    
    core.pathway_enrichment.act.exec_clusterprofiler(DBPATH(), GRP.ID(), GRP(), input$pathway_enrichment_ctl_3)
    
    assign('GRP', reactive(
      core.defined_subcluster.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID(), GRP.ID())
    ), envir = .GlobalEnv)
    
  })
  
  
  
  
  ## TABLE ##
  observeEvent(c(T, input$pathway_enrichment_ctl_exec_1), {
    
    output$pathway_enrichment_tab_1 <- renderDT(
      core.pathway_enrichment.tab.pathway_listing(GRP(),
                                                  GRP.ID())
    )
    
  })
  
  
  
  
  ## PLOT ##
  output$pathway_enrichment_plt_attr_1 <- renderPlotly(
    core.pathway_enrichment.plt.pcs.elbow(GRP(),
                                          GRP.ID())
  )
  
  observeEvent(c(input$ddrtree_analysis_ctl_exec_1,
                 input$pathway_enrichment_ctl_exec_1,
                 input$pathway_enrichment_ctl_2), {
    
    output$pathway_enrichment_plt_1 <- renderPlotly(
      core.pathway_enrichment.plt.cluster_heatmap(GRP(),
                                                  input$pathway_enrichment_ctl_2,
                                                  input$pathway_enrichment_tab_1_rows_selected,
                                                  'pca',
                                                  GRP.ID())
    )
    
    output$pathway_enrichment_plt_2 <- renderPlotly(
      core.pathway_enrichment.plt.cluster_heatmap(GRP(),
                                                  input$pathway_enrichment_ctl_2,
                                                  input$pathway_enrichment_tab_1_rows_selected,
                                                  'tsne',
                                                  GRP.ID())
    )
    
    output$pathway_enrichment_plt_3 <- renderPlotly(
      core.pathway_enrichment.plt.cluster_heatmap(GRP(),
                                                  input$pathway_enrichment_ctl_2,
                                                  input$pathway_enrichment_tab_1_rows_selected,
                                                  'umap',
                                                  GRP.ID())
    )
    
    output$pathway_enrichment_plt_4 <- renderPlotly(
      core.pathway_enrichment.plt.cluster_heatmap(GRP(),
                                                  input$pathway_enrichment_ctl_2,
                                                  input$pathway_enrichment_tab_1_rows_selected,
                                                  'ddrtree',
                                                  GRP.ID())
    )
    
    output$pathway_enrichment_plt_5 <- renderPlotly(
      core.pathway_enrichment.plt.statistics.bubble(GRP(),
                                                    input$pathway_enrichment_ctl_2,
                                                    GRP.ID())
    )
    
  })
  
}