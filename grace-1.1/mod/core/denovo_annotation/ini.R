#### IMPORT FUNC ####
source('mod/core/denovo_annotation/ctl/attribution.R')
source('mod/core/denovo_annotation/ctl/cell_clustering.R')
source('mod/core/denovo_annotation/ctl/cell_sampling.R')
source('mod/core/denovo_annotation/ctl/file_importing.R')
source('mod/core/denovo_annotation/ctl/action.R')


source('mod/core/denovo_annotation/act/annotate_cell.R')
source('mod/core/denovo_annotation/act/sample_cell.R')
source('mod/core/denovo_annotation/act/select_group.R')


source('mod/core/denovo_annotation/tab/cluster_listing.R')


source('mod/core/denovo_annotation/plt/cluster.R')
source('mod/core/denovo_annotation/plt/statistics.R')
####




#### SET UI ####
core.denovo_annotation.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    uiOutput('denovo_annotation_ctl_1'),
    uiOutput('denovo_annotation_ctl_2'),
    uiOutput('denovo_annotation_ctl_3'),
    uiOutput('denovo_annotation_ctl_4'),
    uiOutput('denovo_annotation_ctl_5'),
    
    hr(),
    
    fluidRow(
      column(6, uiOutput('denovo_annotation_ctl_6'), align = 'left'),
      column(6, uiOutput('denovo_annotation_ctl_7'), align = 'right')
    ),
    
    uiOutput('denovo_annotation_ctl_8'),
    
    hr(),
    
    DTOutput('denovo_annotation_tab_1'),
    
    br(),
    
    uiOutput('denovo_annotation_ctl_9'),
    uiOutput('denovo_annotation_ctl_10')
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('PCA', br(), plotlyOutput('denovo_annotation_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('denovo_annotation_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('denovo_annotation_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('denovo_annotation_plt_4')
  )
)
####




#### SERVER ####
core.denovo_annotation <- function(input, output) {
  
  ## INITIALIZE DATA ##
  assign('DATA_SMP', reactive(
    core.denovo_annotation.act.sample_cell(DATA(), input$denovo_annotation_ctl_7, input$denovo_annotation_ctl_8)
  ), envir = .GlobalEnv)
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$denovo_annotation_ctl_1 <- renderUI(
    core.denovo_annotation.ctl.cell_clustering('denovo_annotation_ctl_1', 'Resolution', 'No',
                                               DATA.ID())
  )
  
  output$denovo_annotation_ctl_2 <- renderUI(
    core.denovo_annotation.ctl.attr_picker('denovo_annotation_ctl_2', 'Ref. of Cell Annotation',
                                           c('Human Primary Cell Atlas', 'Mouse RNAseq'),
                                           'Human Primary Cell Atlas',
                                           DATA.ID())
  )
  
  output$denovo_annotation_ctl_3 <- renderUI(
    core.denovo_annotation.ctl.attr_chooser('denovo_annotation_ctl_3', 'Annotation Using Customized Ref.',
                                            c('Yes', 'No'), 'No',
                                            DATA.ID())
  )
  
  observeEvent(input$denovo_annotation_ctl_3, {
    
    output$denovo_annotation_ctl_4 <- renderUI(
      core.denovo_annotation.ctl.file_importing('denovo_annotation_ctl_4', 
                                                'Upload', '.rds', 
                                                'Support RDS file',
                                                input$denovo_annotation_ctl_3),
    )
    
  })
  
  output$denovo_annotation_ctl_5 <- renderUI(
    core.denovo_annotation.ctl.action('denovo_annotation_ctl_5', 'Annotating', 'fingerprint',
                                      DATA.ID())
  )
  
  output$denovo_annotation_ctl_6 <- renderUI(
    core.denovo_annotation.ctl.attr_chooser('denovo_annotation_ctl_6', 'Annotated',
                                            c('Yes', 'No'), 'Yes',
                                            DATA.ID())
  )
  
  observeEvent(input$denovo_annotation_ctl_6, {
    
    output$denovo_annotation_ctl_7 <- renderUI(
      core.denovo_annotation.ctl.cell_clustering('denovo_annotation_ctl_7', 'Annotation Type',
                                                 input$denovo_annotation_ctl_6,
                                                 DATA.ID())
    )
    
  })
  
  output$denovo_annotation_ctl_8 <- renderUI(
    core.denovo_annotation.ctl.cell_sampling('denovo_annotation_ctl_8', 'Cell Ratio',
                                             DATA.ID())
  )
  
  output$denovo_annotation_ctl_9 <- renderUI(
    core.denovo_annotation.ctl.attr_picker('denovo_annotation_ctl_9', 'Ref. of Cell Annotation for Subclustering',
                                           c('Human Primary Cell Atlas', 'Mouse RNAseq'),
                                           'Human Primary Cell Atlas',
                                           DATA.ID())
  )
  
  output$denovo_annotation_ctl_10 <- renderUI(
    core.denovo_annotation.ctl.action('denovo_annotation_ctl_10', 
                                      'EXEC', 
                                      'microscope',
                                      DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$denovo_annotation_ctl_5, {
    
    core.denovo_annotation.act.annotate_cell(DBPATH(), DATA.ID(), DATA(),
                                             input$denovo_annotation_ctl_4$datapath,
                                             input$denovo_annotation_ctl_1,
                                             input$denovo_annotation_ctl_2)
    
    assign('DATA', reactive(
      core.data_upload.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID())
    ), envir = .GlobalEnv)
    
    assign('DATA_SMP', reactive(
      core.denovo_annotation.act.sample_cell(DATA(), input$denovo_annotation_ctl_7, input$denovo_annotation_ctl_8)
    ), envir = .GlobalEnv)
    
  })
  
  observeEvent(input$denovo_annotation_ctl_10, {
    
    core.denovo_annotation.act.select_group(DBPATH(), PROJ.ID(), DATA.ID(), DATA(), 
                                            input$denovo_annotation_ctl_7,
                                            input$denovo_annotation_tab_1_rows_selected,
                                            input$denovo_annotation_ctl_9)
    
  })
  
  
  
  
  ## TABLE ##
  observeEvent(c(T, input$denovo_annotation_ctl_5), {
    
    output$denovo_annotation_tab_1 <- renderDT(
      core.denovo_annotation.tab.cluster_listing(DATA(),
                                                 input$denovo_annotation_ctl_7,
                                                 DATA.ID())
    )
    
  })
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$denovo_annotation_ctl_5), {
    
    output$denovo_annotation_plt_1 <- renderPlotly(
      core.denovo_annotation.plt.cluster(DATA(), DATA_SMP(),
                                         input$denovo_annotation_ctl_7,
                                         input$denovo_annotation_tab_1_rows_selected,
                                         'pca',
                                         DATA.ID())
    )
    
    output$denovo_annotation_plt_2 <- renderPlotly(
      core.denovo_annotation.plt.cluster(DATA(), DATA_SMP(),
                                         input$denovo_annotation_ctl_7,
                                         input$denovo_annotation_tab_1_rows_selected,
                                         'tsne',
                                         DATA.ID())
    )
    
    output$denovo_annotation_plt_3 <- renderPlotly(
      core.denovo_annotation.plt.cluster(DATA(), DATA_SMP(),
                                         input$denovo_annotation_ctl_7,
                                         input$denovo_annotation_tab_1_rows_selected,
                                         'umap',
                                         DATA.ID())
    )
      
    output$denovo_annotation_plt_4 <- renderPlotly(
      core.denovo_annotation.plt.statistics.cell_number(DATA(), 
                                                        input$denovo_annotation_ctl_7,
                                                        DATA.ID())
    )
    
  })
  
}