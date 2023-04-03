#### IMPORT FUNC ####
source('mod/core/inter_communication/ctl/attribution.R')
source('mod/core/inter_communication/ctl/cell_clustering.R')
source('mod/core/inter_communication/ctl/action.R')
source('mod/core/inter_communication/ctl/cell_subcluster_listing.R')
source('mod/core/inter_communication/ctl/comm_pair_listing.R')


source('mod/core/inter_communication/act/exec_cellphonedb.R')


source('mod/core/inter_communication/plt/correlation.R')
source('mod/core/inter_communication/plt/statistics.R')
####




#### SET UI ####
core.inter_communication.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    fluidRow(
      column(6, uiOutput('inter_communication_ctl_exec_attr_1'), align = 'left'),
      column(6, uiOutput('inter_communication_ctl_exec_attr_2'), align = 'right')
    ),
    
    uiOutput('inter_communication_ctl_exec_1'),
    
    hr(),
    
    fluidRow(
      column(6, uiOutput('inter_communication_ctl_1'), align = 'left'),
      column(6, uiOutput('inter_communication_ctl_2'), align = 'right')
    ),
    
    hr(),
    
    uiOutput('inter_communication_ctl_3')
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('Cell-cell Communication',
               br(), plotlyOutput('inter_communication_plt_1a'),
               hr(), plotlyOutput('inter_communication_plt_1b')),
      tabPanel('Ligand-receptor Pair',
               br(), plotlyOutput('inter_communication_plt_2a'),
               hr(), plotlyOutput('inter_communication_plt_2b'))
    ),
    
    hr(), tabsetPanel(
      tabPanel('Interaction Strength (Group 1)', br(), plotlyOutput('inter_communication_plt_3')),
      tabPanel('Interaction Strength (Group 2)', br(), plotlyOutput('inter_communication_plt_4'))
    )
  )
)
####




#### SERVER ####
core.inter_communication <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$inter_communication_ctl_exec_attr_1 <- renderUI(
    core.inter_communication.ctl.attr_chooser('inter_communication_ctl_exec_attr_1', 'Annotated',
                                              c('Yes', 'No'), 'Yes',
                                              DATA.ID())
  )
  
  observeEvent(input$inter_communication_ctl_exec_attr_1, {
    
    output$inter_communication_ctl_exec_attr_2 <- renderUI(
      core.inter_communication.ctl.cell_clustering('inter_communication_ctl_exec_attr_2', 'Anntation Type',
                                                   input$inter_communication_ctl_exec_attr_1,
                                                   DATA.ID())
    )
    
  })
  
  output$inter_communication_ctl_exec_1 <- renderUI(
    core.inter_communication.ctl.action('inter_communication_ctl_exec_1', 'Exec CellphoneDB', 'play',
                                         DATA.ID())
  )
  
  observeEvent(c(T, input$inter_communication_ctl_exec_1), {
    
    output$inter_communication_ctl_1 <- renderUI(
      core.inter_communication.ctl.cell_subcluster_listing('inter_communication_ctl_1',
                                                            'Cell Type A (Ligand)',
                                                            DBPATH(), DATA.ID(),
                                                            DATA.ID())
    )
    
    output$inter_communication_ctl_2 <- renderUI(
      core.inter_communication.ctl.cell_subcluster_listing('inter_communication_ctl_2',
                                                            'Cell Type B (Receptor)',
                                                            DBPATH(), DATA.ID(),
                                                            DATA.ID())
    )
    
    output$inter_communication_ctl_3 <- renderUI(
      core.inter_communication.ctl.comm_pair_listing('inter_communication_ctl_3', 
                                                      'Ligand-receptor Pair',
                                                      DBPATH(), DATA.ID(),
                                                      DATA.ID())
    )
    
  })
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$inter_communication_ctl_exec_1, {
    
    core.inter_communication.act.exec_cellphonedb(DBPATH(), DATA.ID(), DATA(),
                                                  input$inter_communication_ctl_exec_attr_2)
    
  })
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$inter_communication_ctl_exec_1), {
    
    output$inter_communication_plt_1a <- renderPlotly(
      core.inter_communication.plt.statistics.bubble.1(DBPATH(), DATA.ID(), 'g1',
                                                       input$inter_communication_ctl_1,
                                                       input$inter_communication_ctl_2,
                                                       DATA.ID())
    )
    
    output$inter_communication_plt_1b <- renderPlotly(
      core.inter_communication.plt.statistics.bubble.1(DBPATH(), DATA.ID(), 'g2',
                                                       input$inter_communication_ctl_1,
                                                       input$inter_communication_ctl_2,
                                                       DATA.ID())
    )
    
    output$inter_communication_plt_2a <- renderPlotly(
      core.inter_communication.plt.statistics.bubble.2(DBPATH(), DATA.ID(), 'g1',
                                                       input$inter_communication_ctl_3,
                                                       DATA.ID())
    )
    
    output$inter_communication_plt_2b <- renderPlotly(
      core.inter_communication.plt.statistics.bubble.2(DBPATH(), DATA.ID(), 'g2',
                                                       input$inter_communication_ctl_3,
                                                       DATA.ID())
    )
    
    observeEvent(c(input$inter_communication_ctl_1,
                   input$inter_communication_ctl_2), {
                     
      output$inter_communication_plt_3 <- renderPlotly(
        core.inter_communication.plt.correlation(DBPATH(), DATA.ID(), 'g1',
                                                 DATA.ID())
      )
      
      output$inter_communication_plt_4 <- renderPlotly(
        core.inter_communication.plt.correlation(DBPATH(), DATA.ID(), 'g2',
                                                 DATA.ID())
      )
      
    })
    
  })
  
}