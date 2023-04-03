#### IMPORT FUNC ####
source('mod/core/ref_based_annotation/ctl/attribution.R')
source('mod/core/ref_based_annotation/ctl/mapping_ref.R')
source('mod/core/ref_based_annotation/ctl/file_importing.R')
source('mod/core/ref_based_annotation/ctl/action.R')



source('mod/core/ref_based_annotation/act/map_to_ref.R')
source('mod/core/ref_based_annotation/act/select_group.R')


source('mod/core/ref_based_annotation/tab/cluster_listing.R')


source('mod/core/ref_based_annotation/plt/cluster.R')
source('mod/core/ref_based_annotation/plt/statistics.R')
####




#### SET UI ####
core.ref_based_annotation.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    uiOutput('ref_based_annotation_ctl_1'),
    uiOutput('ref_based_annotation_ctl_cust_1'),
    uiOutput('ref_based_annotation_ctl_cust_2'),
    uiOutput('ref_based_annotation_ctl_2'),
    
    hr(),
    
    DTOutput('ref_based_annotation_tab_1'),
    
    br(),
    
    uiOutput('ref_based_annotation_ctl_3'),
    uiOutput('ref_based_annotation_ctl_4')
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('PCA', br(), plotlyOutput('ref_based_annotation_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('ref_based_annotation_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('ref_based_annotation_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('ref_based_annotation_plt_4')
  )
)
####




#### SERVER ####
core.ref_based_annotation <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$ref_based_annotation_ctl_1 <- renderUI(
    core.ref_based_annotation.ctl.mapping_ref.selection('ref_based_annotation_ctl_1', 'Choose Atlas',
                                                        DATA.ID())
  )
  
  output$ref_based_annotation_ctl_cust_1 <- renderUI(
    core.ref_based_annotation.ctl.attr_chooser('ref_based_annotation_ctl_cust_1', 'Customized Atlas Reference',
                                               c('Yes', 'No'), 'No',
                                               DATA.ID())
  )
  
  observeEvent(input$ref_based_annotation_ctl_cust_1, {
    
    output$ref_based_annotation_ctl_cust_2 <- renderUI(
      core.ref_based_annotation.ctl.file_importing('ref_based_annotation_ctl_cust_2', 
                                                   'Upload', '.rds', 
                                                   'Support RDS file',
                                                   input$ref_based_annotation_ctl_cust_1),
    )
    
  })
  
  output$ref_based_annotation_ctl_2 <- renderUI(
    core.ref_based_annotation.ctl.action('ref_based_annotation_ctl_2', 'Mapping', 'align-left',
                                         DATA.ID())
  )
  
  output$ref_based_annotation_ctl_3 <- renderUI(
    core.ref_based_annotation.ctl.attr_picker('ref_based_annotation_ctl_3',
                                              'Ref. of Cell Annotation for Subclustering',
                                              c('Human Primary Cell Atlas', 'Mouse RNAseq'),
                                              'Human Primary Cell Atlas',
                                              DATA.ID())
  )
  
  output$ref_based_annotation_ctl_4 <- renderUI(
    core.ref_based_annotation.ctl.action('ref_based_annotation_ctl_4',
                                         'EXEC',
                                         'microscope',
                                         DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$ref_based_annotation_ctl_2, {
    
    core.ref_based_annotation.act.map_to_ref(DBPATH(), DATA.ID(), DATA(),
                                             input$ref_based_annotation_ctl_1,
                                             input$ref_based_annotation_ctl_cust_1,
                                             input$ref_based_annotation_ctl_cust_2$datapath)
    
    assign('DATA', reactive(
      core.data_upload.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID())
    ), envir = .GlobalEnv)
    
  })
  
  observeEvent(input$ref_based_annotation_ctl_4, {
    
    core.ref_based_annotation.act.select_group(DBPATH(), PROJ.ID(), DATA.ID(), DATA(), 
                                               'predicted.clusters.ann', 
                                               input$ref_based_annotation_tab_1_rows_selected,
                                               input$ref_based_annotation_ctl_3)
    
  })
  
  
  
  
  ## TABLE ##
  observeEvent(c(T, input$ref_based_annotation_ctl_2), {
    
    output$ref_based_annotation_tab_1 <- renderDT(
      core.ref_based_annotation.tab.cluster_listing(DATA(),
                                                    'predicted.clusters.ann',
                                                    DATA.ID())
    )
    
  })
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$ref_based_annotation_ctl_2), {
    
    output$ref_based_annotation_plt_1 <- renderPlotly(
      core.ref_based_annotation.plt.cluster(DATA(), DATA_SMP(),
                                            'predicted.clusters.ann',
                                            input$ref_based_annotation_tab_1_rows_selected,
                                            'pca',
                                            DATA.ID())
    )
    
    output$ref_based_annotation_plt_2 <- renderPlotly(
      core.ref_based_annotation.plt.cluster(DATA(), DATA_SMP(),
                                            'predicted.clusters.ann',
                                            input$ref_based_annotation_tab_1_rows_selected,
                                            'tsne',
                                            DATA.ID())
    )
    
    output$ref_based_annotation_plt_3 <- renderPlotly(
      core.ref_based_annotation.plt.cluster(DATA(), DATA_SMP(),
                                            'predicted.clusters.ann',
                                            input$ref_based_annotation_tab_1_rows_selected,
                                            'umap',
                                            DATA.ID())
    )
    
    output$ref_based_annotation_plt_4 <- renderPlotly(
      core.ref_based_annotation.plt.statistics.cell_number(DATA(),
                                                           'predicted.clusters.ann',
                                                           DATA.ID())
    )
    
  })
  
}