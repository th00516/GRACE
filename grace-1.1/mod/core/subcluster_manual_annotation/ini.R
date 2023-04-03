#### IMPORT FUNC ####
source('mod/core/subcluster_manual_annotation/ctl/action.R')
source('mod/core/subcluster_manual_annotation/ctl/attribution.R')
source('mod/core/subcluster_manual_annotation/ctl/cell_clustering.R')


source('mod/core/subcluster_manual_annotation/act/reset_annotation.R')
source('mod/core/subcluster_manual_annotation/act/manually_annotate.R')
source('mod/core/subcluster_manual_annotation/act/write_annotation.R')


source('mod/core/subcluster_manual_annotation/tab/cluster_annotation_listing.R')
source('mod/core/subcluster_manual_annotation/tab/cluster_listing.R')


source('mod/core/subcluster_manual_annotation/plt/cluster.R')
source('mod/core/subcluster_manual_annotation/plt/statistics.R')
####




#### SET UI ####
core.subcluster_manual_annotation.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    fluidRow(
      column(6, uiOutput('subcluster_manual_annotation_ctl_1'), align = 'left'),
      column(6, uiOutput('subcluster_manual_annotation_ctl_2'), align = 'right')
    ),

    DTOutput('subcluster_manual_annotation_tab_1'),

    br(),

    uiOutput('subcluster_manual_annotation_ctl_3'),

    hr(),

    DTOutput('subcluster_manual_annotation_tab_2')
    
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('PCA', br(), plotlyOutput('subcluster_manual_annotation_plt_1')),
      tabPanel('tSNE', br(), plotlyOutput('subcluster_manual_annotation_plt_2')),
      tabPanel('UMAP', br(), plotlyOutput('subcluster_manual_annotation_plt_3'))
    ),

    hr(),

    plotlyOutput('subcluster_manual_annotation_plt_4')
  )
)
####




#### SERVER ####
core.subcluster_manual_annotation <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$subcluster_manual_annotation_ctl_1 <- renderUI(
    core.subcluster_manual_annotation.ctl.attr_chooser('subcluster_manual_annotation_ctl_1', 'Annotated',
                                                       c('Yes', 'No'), 'Yes',
                                                       GRP.ID())
  )

  observeEvent(input$subcluster_manual_annotation_ctl_1, {

    output$subcluster_manual_annotation_ctl_2 <- renderUI(
      core.subcluster_manual_annotation.ctl.cell_clustering('subcluster_manual_annotation_ctl_2', 'Annotation Type',
                                                            input$subcluster_manual_annotation_ctl_1,
                                                            GRP.ID())
    )

  })

  output$subcluster_manual_annotation_ctl_3 <- renderUI(
    core.subcluster_manual_annotation.ctl.action('subcluster_manual_annotation_ctl_3',
                                                 'Change Annotation',
                                                 'file-signature',
                                                 GRP.ID())
  )




  ## ACTIVITY ##
  observe(assign('current_manual_annotation',
                 core.subcluster_manual_annotation.act.reset_annotation(GRP(), input$subcluster_manual_annotation_ctl_2),
                 envir = .GlobalEnv))

  observe(assign('current_manual_annotation',
                 core.subcluster_manual_annotation.act.manually_annotate(current_manual_annotation,
                                                                         input$subcluster_manual_annotation_tab_1_cell_edit),
                 envir = .GlobalEnv))

  observeEvent(input$subcluster_manual_annotation_ctl_3, {

    core.subcluster_manual_annotation.act.write_annotation(DBPATH(), GRP.ID(), GRP(),
                                                           input$subcluster_manual_annotation_ctl_2,
                                                           current_manual_annotation)

    assign('GRP', reactive(
      core.defined_subcluster.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID(), GRP.ID())
    ), envir = .GlobalEnv)

    observe(assign('current_manual_annotation',
                   core.subcluster_manual_annotation.act.reset_annotation(GRP(), input$subcluster_manual_annotation_ctl_2),
                   envir = .GlobalEnv))

  })
  
  
  
  
  ## TABLE ##
  observeEvent(c(T, input$subcluster_manual_annotation_ctl_3), {

    output$subcluster_manual_annotation_tab_1 <- renderDT(
      core.subcluster_manual_annotation.tab.cluster_annotation_listing(GRP(),
                                                                       input$subcluster_manual_annotation_ctl_2,
                                                                       GRP.ID())
    )

    output$subcluster_manual_annotation_tab_2 <- renderDT(
      core.subcluster_manual_annotation.tab.cluster_listing(GRP(),
                                                            'clusters.ann.manual',
                                                            GRP.ID())
    )

  })




  ## PLOT ##
  observeEvent(c(T, input$subcluster_manual_annotation_ctl_3), {

    output$subcluster_manual_annotation_plt_1 <- renderPlotly(
      core.subcluster_manual_annotation.plt.cluster(GRP(),
                                                    'clusters.ann.manual',
                                                    input$subcluster_manual_annotation_tab_2_rows_selected,
                                                    'pca',
                                                    GRP.ID())
    )

    output$subcluster_manual_annotation_plt_2 <- renderPlotly(
      core.subcluster_manual_annotation.plt.cluster(GRP(),
                                                    'clusters.ann.manual',
                                                    input$subcluster_manual_annotation_tab_2_rows_selected,
                                                    'tsne',
                                                    GRP.ID())
    )

    output$subcluster_manual_annotation_plt_3 <- renderPlotly(
      core.subcluster_manual_annotation.plt.cluster(GRP(),
                                                    'clusters.ann.manual',
                                                    input$subcluster_manual_annotation_tab_2_rows_selected,
                                                    'umap',
                                                    GRP.ID())
    )

    output$subcluster_manual_annotation_plt_4 <- renderPlotly(
      core.subcluster_manual_annotation.plt.statistics.cell_number(GRP(),
                                                                   'clusters.ann.manual',
                                                                   GRP.ID())
    )

  })
  
}