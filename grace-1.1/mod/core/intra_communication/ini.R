#### IMPORT FUNC ####
source('mod/core/intra_communication/ctl/attribution.R')
source('mod/core/intra_communication/ctl/cell_clustering.R')
source('mod/core/intra_communication/ctl/action.R')
source('mod/core/intra_communication/ctl/cell_subcluster_listing.R')
source('mod/core/intra_communication/ctl/comm_pair_listing.R')


source('mod/core/intra_communication/act/exec_cellphonedb.R')


source('mod/core/intra_communication/plt/correlation.R')
source('mod/core/intra_communication/plt/statistics.R')
####




#### SET UI ####
core.intra_communication.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    fluidRow(
      column(6, uiOutput('intra_communication_ctl_exec_attr_1'), align = 'left'),
      column(6, uiOutput('intra_communication_ctl_exec_attr_2'), align = 'right')
    ),
    
    uiOutput('intra_communication_ctl_exec_1'),
    
    hr(),
    
    fluidRow(
      column(6, uiOutput('intra_communication_ctl_1'), align = 'left'),
      column(6, uiOutput('intra_communication_ctl_2'), align = 'right')
    ),
    
    hr(),
    
    uiOutput('intra_communication_ctl_3')
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('Cell-cell Communication',
               br(), plotlyOutput('intra_communication_plt_1a'),
               hr(), plotlyOutput('intra_communication_plt_1b')),
      tabPanel('Ligand-receptor Pair',
               br(), plotlyOutput('intra_communication_plt_2a'),
               hr(), plotlyOutput('intra_communication_plt_2b'))
    ),
    
    hr(), tabsetPanel(
      tabPanel('Interaction Strength (Group 1)', br(), plotlyOutput('intra_communication_plt_3')),
      tabPanel('Interaction Strength (Group 2)', br(), plotlyOutput('intra_communication_plt_4'))
    )
  )
)
####




#### SERVER ####
core.intra_communication <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$intra_communication_ctl_exec_attr_1 <- renderUI(
    core.intra_communication.ctl.attr_chooser('intra_communication_ctl_exec_attr_1', 'Annotated',
                                              c('Yes', 'No'), 'Yes',
                                              GRP.ID())
  )
  
  observeEvent(input$intra_communication_ctl_exec_attr_1, {
    
    output$intra_communication_ctl_exec_attr_2 <- renderUI(
      core.intra_communication.ctl.cell_clustering('intra_communication_ctl_exec_attr_2', 'Anntation Type',
                                                   input$intra_communication_ctl_exec_attr_1,
                                                   GRP.ID())
    )
    
  })
  
  output$intra_communication_ctl_exec_1 <- renderUI(
    core.intra_communication.ctl.action('intra_communication_ctl_exec_1', 'Exec CellphoneDB', 'play',
                                        GRP.ID())
  )
  
  observeEvent(c(T, input$intra_communication_ctl_exec_1), {
    
    output$intra_communication_ctl_1 <- renderUI(
      core.intra_communication.ctl.cell_subcluster_listing('intra_communication_ctl_1',
                                                           'Cell Type A (Ligand)',
                                                           DBPATH(), GRP.ID(),
                                                           GRP.ID())
    )
    
    output$intra_communication_ctl_2 <- renderUI(
      core.intra_communication.ctl.cell_subcluster_listing('intra_communication_ctl_2',
                                                           'Cell Type B (Receptor)',
                                                           DBPATH(), GRP.ID(),
                                                           GRP.ID())
    )
    
    output$intra_communication_ctl_3 <- renderUI(
      core.intra_communication.ctl.comm_pair_listing('intra_communication_ctl_3', 
                                                     'Ligand-receptor Pair',
                                                     DBPATH(), GRP.ID(),
                                                     GRP.ID())
    )
    
  })
  
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$intra_communication_ctl_exec_1, {
    
    core.intra_communication.act.exec_cellphonedb(DBPATH(), GRP.ID(), GRP(),
                                                  input$intra_communication_ctl_exec_attr_2)
    
  })
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$intra_communication_ctl_exec_1), {
    
    output$intra_communication_plt_1a <- renderPlotly(
      core.intra_communication.plt.statistics.bubble.1(DBPATH(), GRP.ID(), 'g1',
                                                       input$intra_communication_ctl_1,
                                                       input$intra_communication_ctl_2,
                                                       GRP.ID())
    )
    
    output$intra_communication_plt_1b <- renderPlotly(
      core.intra_communication.plt.statistics.bubble.1(DBPATH(), GRP.ID(), 'g2',
                                                       input$intra_communication_ctl_1,
                                                       input$intra_communication_ctl_2,
                                                       GRP.ID())
    )
    
    output$intra_communication_plt_2a <- renderPlotly(
      core.intra_communication.plt.statistics.bubble.2(DBPATH(), GRP.ID(), 'g1',
                                                       input$intra_communication_ctl_3,
                                                       GRP.ID())
    )
    
    output$intra_communication_plt_2b <- renderPlotly(
      core.intra_communication.plt.statistics.bubble.2(DBPATH(), GRP.ID(), 'g2',
                                                       input$intra_communication_ctl_3,
                                                       GRP.ID())
    )
    
    observeEvent(c(input$intra_communication_ctl_1,
                   input$intra_communication_ctl_2), {
                     
      output$intra_communication_plt_3 <- renderPlotly(
        core.intra_communication.plt.correlation(DBPATH(), GRP.ID(), 'g1',
                                                 GRP.ID())
      )
      
      output$intra_communication_plt_4 <- renderPlotly(
        core.intra_communication.plt.correlation(DBPATH(), GRP.ID(), 'g2',
                                                 GRP.ID())
      )
      
    })
    
  })
  
}