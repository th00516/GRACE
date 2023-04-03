#### IMPORT FUNC ####
source('mod/core/manual_annotation/ctl/action.R')
source('mod/core/manual_annotation/ctl/attribution.R')
source('mod/core/manual_annotation/ctl/cell_clustering.R')


source('mod/core/manual_annotation/act/reset_annotation.R')
source('mod/core/manual_annotation/act/manually_annotate.R')
source('mod/core/manual_annotation/act/write_annotation.R')
source('mod/core/manual_annotation/act/select_group.R')


source('mod/core/manual_annotation/tab/cluster_annotation_listing.R')
source('mod/core/manual_annotation/tab/cluster_listing.R')


source('mod/core/manual_annotation/plt/cluster.R')
source('mod/core/manual_annotation/plt/statistics.R')
####




#### SET UI ####
core.manual_annotation.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    fluidRow(
      column(6, uiOutput('manual_annotation_ctl_1'), align = 'left'),
      column(6, uiOutput('manual_annotation_ctl_2'), align = 'right')
    ),
    
    DTOutput('manual_annotation_tab_1'),
    
    br(),
    
    uiOutput('manual_annotation_ctl_3'),
    
    hr(),
    
    DTOutput('manual_annotation_tab_2'),
    
    br(),
    
    uiOutput('manual_annotation_ctl_4'),
    uiOutput('manual_annotation_ctl_5')
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('PCA', br(), plotlyOutput('manual_annotation_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('manual_annotation_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('manual_annotation_plt_3'))
    ),
    
    hr(),
    
    plotlyOutput('manual_annotation_plt_4')
  )
)
####




#### SERVER ####
core.manual_annotation <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$manual_annotation_ctl_1 <- renderUI(
    core.manual_annotation.ctl.attr_chooser('manual_annotation_ctl_1', 'Annotated',
                                            c('Yes', 'No'), 'Yes',
                                            DATA.ID())
  )
  
  observeEvent(input$manual_annotation_ctl_1, {
    
    output$manual_annotation_ctl_2 <- renderUI(
      core.manual_annotation.ctl.cell_clustering('manual_annotation_ctl_2', 'Annotation Type',
                                                 input$manual_annotation_ctl_1,
                                                 DATA.ID())
    )
    
  })
  
  output$manual_annotation_ctl_3 <- renderUI(
    core.manual_annotation.ctl.action('manual_annotation_ctl_3',
                                      'Exec Renaming',
                                      'file-signature',
                                      DATA.ID())
  )
  
  output$manual_annotation_ctl_4 <- renderUI(
    core.manual_annotation.ctl.attr_picker('manual_annotation_ctl_4',
                                           'Ref. of Cell Annotation for Subclustering',
                                           c('Human Primary Cell Atlas', 'Mouse RNAseq'),
                                           'Human Primary Cell Atlas',
                                           DATA.ID())
  )
  
  output$manual_annotation_ctl_5 <- renderUI(
    core.manual_annotation.ctl.action('manual_annotation_ctl_5',
                                      'EXEC',
                                      'microscope',
                                      DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observe(assign('current_manual_annotation',
                 core.manual_annotation.act.reset_annotation(DATA(), input$manual_annotation_ctl_2),
                 envir = .GlobalEnv))
  
  observe(assign('current_manual_annotation',
                 core.manual_annotation.act.manually_annotate(current_manual_annotation,
                                                              input$manual_annotation_tab_1_cell_edit),
                 envir = .GlobalEnv))
  
  observeEvent(input$manual_annotation_ctl_3, {
    
    core.manual_annotation.act.write_annotation(DBPATH(), DATA.ID(), DATA(),
                                                input$manual_annotation_ctl_2,
                                                current_manual_annotation)
    
    assign('DATA', reactive(
      core.data_upload.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID())
    ), envir = .GlobalEnv)
    
    observe(assign('current_manual_annotation',
                   core.manual_annotation.act.reset_annotation(DATA(), input$manual_annotation_ctl_2),
                   envir = .GlobalEnv))
    
  })
  
  observeEvent(input$manual_annotation_ctl_5, {
    
    core.manual_annotation.act.select_group(DBPATH(), PROJ.ID(), DATA.ID(), DATA(), 
                                            'clusters.ann.manual', 
                                            input$manual_annotation_tab_2_rows_selected,
                                            input$manual_annotation_ctl_4)
    
  })
  
  
  
  
  ## TABLE ##
  observeEvent(c(T, input$manual_annotation_ctl_3), {
    
    output$manual_annotation_tab_1 <- renderDT(
      core.manual_annotation.tab.cluster_annotation_listing(DATA(),
                                                            input$manual_annotation_ctl_2,
                                                            DATA.ID())
    )
    
    output$manual_annotation_tab_2 <- renderDT(
      core.manual_annotation.tab.cluster_listing(DATA(),
                                                 'clusters.ann.manual',
                                                 DATA.ID())
    )
    
  })
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$manual_annotation_ctl_3), {
    
    output$manual_annotation_plt_1 <- renderPlotly(
      core.manual_annotation.plt.cluster(DATA(), DATA_SMP(),
                                         'clusters.ann.manual',
                                         input$manual_annotation_tab_2_rows_selected,
                                         'pca',
                                         DATA.ID())
    )
    
    output$manual_annotation_plt_2 <- renderPlotly(
      core.manual_annotation.plt.cluster(DATA(), DATA_SMP(),
                                         'clusters.ann.manual',
                                         input$manual_annotation_tab_2_rows_selected,
                                         'tsne',
                                         DATA.ID())
    )
    
    output$manual_annotation_plt_3 <- renderPlotly(
      core.manual_annotation.plt.cluster(DATA(), DATA_SMP(),
                                         'clusters.ann.manual',
                                         input$manual_annotation_tab_2_rows_selected,
                                         'umap',
                                         DATA.ID())
    )
    
    output$manual_annotation_plt_4 <- renderPlotly(
      core.manual_annotation.plt.statistics.cell_number(DATA(),
                                                        'clusters.ann.manual',
                                                        DATA.ID())
    )
    
  })
  
}