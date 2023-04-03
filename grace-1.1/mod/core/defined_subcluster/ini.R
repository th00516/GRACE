#### IMPORT FUNC ####
source('mod/core/defined_subcluster/ctl/action.R')
source('mod/core/defined_subcluster/ctl/attribution.R')
source('mod/core/defined_subcluster/ctl/cell_clustering.R')


source('mod/core/defined_subcluster/act/import_data.R')
source('mod/core/defined_subcluster/act/remove_record.R')
source('mod/core/defined_subcluster/act/get_present_id.R')
source('mod/core/defined_subcluster/act/get_data.R')


source('mod/core/defined_subcluster/tab/records.R')
source('mod/core/defined_subcluster/tab/cluster_listing.R')
source('mod/core/defined_subcluster/tab/feature_listing.R')


source('mod/core/defined_subcluster/plt/cluster.R')
source('mod/core/defined_subcluster/plt/statistics.R')
####




#### SET UI ####
core.defined_subcluster.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    uiOutput('defined_subcluster_ctl_1'),
    
    hr(),
    
    fluidRow(
      column(6, uiOutput('defined_subcluster_ctl_2'), align = 'left'),
      column(6, uiOutput('defined_subcluster_ctl_3'), align = 'right')
    ),
    
    hr(),
    
    uiOutput('defined_subcluster_ctl_4'),
    
    hr(),
    
    DTOutput('defined_subcluster_tab_2'),
    
    hr(),
    
    DTOutput('defined_subcluster_tab_3')
  ),
  
  mainPanel(width = 7,
    br(), DTOutput('defined_subcluster_tab_1'),
    br(), uiOutput('defined_subcluster_ctl_data_downloadSlot'),
    
    hr(),
    
    br(), tabsetPanel(
      tabPanel('PCA',  br(), plotlyOutput('defined_subcluster_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('defined_subcluster_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('defined_subcluster_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('defined_subcluster_plt_4')
  )
)
####




#### SERVER ####
core.defined_subcluster <- function(input, output) {
  
  ## INITIALIZE DATA ##
  assign('GRP.ID', reactive(
    core.defined_subcluster.act.get_present_grp_id(DBPATH(), PROJ.ID(), DATA.ID(), input$defined_subcluster_tab_1_rows_selected)
  ), envir = .GlobalEnv)
  
  ####
  
  assign('GRP', reactive(
    core.defined_subcluster.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID(), GRP.ID())
  ), envir = .GlobalEnv)
  
  observe(GRP())
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$defined_subcluster_ctl_1 <- renderUI(
    core.defined_subcluster.ctl.action('defined_subcluster_ctl_1',
                                       'Remove Selected Subcluster',
                                       'trash-alt',
                                       DATA.ID())
  )
  
  output$defined_subcluster_ctl_2 <- renderUI(
    core.defined_subcluster.ctl.attr_chooser('defined_subcluster_ctl_2', 'Annotated',
                                             c('Yes', 'No'), 'Yes',
                                             GRP.ID())
  )
  
  observeEvent(input$defined_subcluster_ctl_2, {
    
    output$defined_subcluster_ctl_3 <- renderUI(
      core.defined_subcluster.ctl.cell_clustering('defined_subcluster_ctl_3', 'Annotation Type',
                                                  input$defined_subcluster_ctl_2,
                                                  GRP.ID())
    )
    
  })
  
  output$defined_subcluster_ctl_4 <- renderUI(
    core.defined_subcluster.ctl.attr_chooser('defined_subcluster_ctl_4', 'Separated by Group',
                                             c('Yes', 'No'), 'No',
                                             GRP.ID())
  )
  
  output$defined_subcluster_ctl_data_downloadSlot <- renderUI(
    core.defined_subcluster.ctl.downloadSlot('defined_subcluster_ctl_data_download', GRP.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$defined_subcluster_ctl_1, {
    
    core.defined_subcluster.act.remove_grp(DBPATH(),
                                           PROJ.ID(), DATA.ID(), GRP.ID())
    
  })
  
  observeEvent(GRP.ID(), {
    
    output$defined_subcluster_ctl_data_download <- core.defined_subcluster.act.get_data(PROJ.ID(), DATA.ID(), GRP.ID())
    
  })
  
  
  
  
  ## TABLE ##
  observeEvent(c(input$defined_subcluster_ctl_1,
                 input$denovo_annotation_ctl_10,
                 input$ref_based_annotation_ctl_4,
                 input$manual_annotation_ctl_5), {
                   
    output$defined_subcluster_tab_1 <- renderDT(
      core.defined_subcluster.tab.grp_records(DBPATH(), DATA.ID(),
                                              DATA.ID())
    )

  })
  
  output$defined_subcluster_tab_2 <- renderDT(
    core.defined_subcluster.tab.feature_listing(GRP(),
                                                GRP.ID())
  )
  
  output$defined_subcluster_tab_3 <- renderDT(
    core.defined_subcluster.tab.cluster_listing(GRP(),
                                                input$defined_subcluster_ctl_3,
                                                GRP.ID())
  )
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$defined_subcluster_tab_1_rows_selected), {
    
    output$defined_subcluster_plt_1 <- renderPlotly(
      core.defined_subcluster.plt.cluster(GRP(),
                                          input$defined_subcluster_ctl_3,
                                          'pca',
                                          input$defined_subcluster_tab_2_rows_selected,
                                          input$defined_subcluster_ctl_4,
                                          GRP.ID())
    )
    
    output$defined_subcluster_plt_2 <- renderPlotly(
      core.defined_subcluster.plt.cluster(GRP(),
                                          input$defined_subcluster_ctl_3,
                                          'tsne',
                                          input$defined_subcluster_tab_2_rows_selected,
                                          input$defined_subcluster_ctl_4,
                                          GRP.ID())
    )
    
    output$defined_subcluster_plt_3 <- renderPlotly(
      core.defined_subcluster.plt.cluster(GRP(),
                                          input$defined_subcluster_ctl_3,
                                          'umap',
                                          input$defined_subcluster_tab_2_rows_selected,
                                          input$defined_subcluster_ctl_4,
                                          GRP.ID())
    )
      
    output$defined_subcluster_plt_4 <- renderPlotly(
      core.defined_subcluster.plt.statistics.exp_dist(GRP(), 
                                                      input$defined_subcluster_ctl_3,
                                                      input$defined_subcluster_tab_2_rows_selected,
                                                      input$defined_subcluster_ctl_4,
                                                      GRP.ID())
    )
    
  })
  
}