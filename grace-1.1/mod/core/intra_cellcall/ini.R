#### IMPORT FUNC ####
source('mod/core/intra_cellcall/ctl/attribution.R')
source('mod/core/intra_cellcall/ctl/cell_clustering.R')
source('mod/core/intra_cellcall/ctl/action.R')


source('mod/core/intra_cellcall/act/exec_cellcall.R')


source('mod/core/intra_cellcall/plt/cellcall_plot.R')
####




#### SET UI ####
core.intra_cellcall.UI <- sidebarLayout(
  sidebarPanel(width = 5,
               
               fluidRow(
                 column(6, uiOutput('intra_cellcall_ctl_exec_attr_1'), align = 'left'),
                 column(6, uiOutput('intra_cellcall_ctl_exec_attr_2'), align = 'right')
               ),
               
               fluidRow(
                 column(6, uiOutput('intra_cellcall_ctl_attr_species'), align = 'left'),
                 column(6, uiOutput('intra_cellcall_ctl_attr_padjust'), align = 'right')
               ),
               
               uiOutput('intra_cellcall_ctl_exec_1')
    
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('Bubble', br(), plotOutput('intra_cellcall_plt_1a', height = '600px'),
                         hr(), plotOutput('intra_cellcall_plt_1b', height = '600px')),
      tabPanel('Circle', br(), plotOutput('intra_cellcall_plt_2a', height = '600px'),
                         hr(), plotOutput('intra_cellcall_plt_2b', height = '600px'))
    )
  )
)
####




#### SERVER ####
core.intra_cellcall <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$intra_cellcall_ctl_exec_attr_1 <- renderUI(
    core.intra_cellcall.ctl.attr_chooser('intra_cellcall_ctl_exec_attr_1', 'Annotated',
                                          c('Yes', 'No'), 'Yes',
                                          GRP.ID())
  )
  
  observeEvent(input$intra_cellcall_ctl_exec_attr_1, {
    
    output$intra_cellcall_ctl_exec_attr_2 <- renderUI(
      core.intra_cellcall.ctl.cell_clustering('intra_cellcall_ctl_exec_attr_2', 'Anntation Type',
                                               input$intra_cellcall_ctl_exec_attr_1,
                                               GRP.ID())
    )
    
  })
  
  output$intra_cellcall_ctl_attr_species <- renderUI(
    core.intra_cellcall.ctl.attr_picker('intra_cellcall_ctl_attr_species', 'Species',
                                        'species',
                                        GRP.ID())
  )
  
  output$intra_cellcall_ctl_attr_padjust <- renderUI(
    core.intra_cellcall.ctl.attr_input('intra_cellcall_ctl_attr_padjust', 'Adjust p-value',
                                       0.05,
                                       GRP.ID())
  )
  
  output$intra_cellcall_ctl_exec_1 <- renderUI(
    core.intra_cellcall.ctl.action('intra_cellcall_ctl_exec_1', 'Exec CellCall', 'play',
                                   GRP.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$intra_cellcall_ctl_exec_1, {
    
    core.intra_cellcall.act.exec_cellcall(DBPATH(), GRP.ID(), GRP(),
                                          input$intra_cellcall_ctl_exec_attr_2,
                                          list(input$intra_cellcall_ctl_attr_species,
                                               input$intra_cellcall_ctl_attr_padjust))
    
  })
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$intra_cellcall_ctl_exec_1), {
    
    output$intra_cellcall_plt_1a <- renderPlot(
      core.intra_cellcall.plt.plot.bubble(DBPATH(), GRP.ID(), 'g1',
                                          GRP.ID())
    )
    
    output$intra_cellcall_plt_1b <- renderPlot(
      core.intra_cellcall.plt.plot.bubble(DBPATH(), GRP.ID(), 'g2',
                                          GRP.ID())
    )
    
    ##
    
    output$intra_cellcall_plt_2a <- renderPlot(
      core.intra_cellcall.plt.plot.circle(DBPATH(), GRP.ID(), 'g1',
                                          GRP.ID())
    )
    
    output$intra_cellcall_plt_2b <- renderPlot(
      core.intra_cellcall.plt.plot.circle(DBPATH(), GRP.ID(), 'g2',
                                          GRP.ID())
    )
    
    ##
    
    output$intra_cellcall_plt_3a <- renderPlot(
      core.intra_cellcall.plt.plot.sankey(DBPATH(), GRP.ID(), 'g1',
                                          GRP.ID())
    )
    
    output$intra_cellcall_plt_3b <- renderPlot(
      core.intra_cellcall.plt.plot.sankey(DBPATH(), GRP.ID(), 'g2',
                                          GRP.ID())
    )
    
  })
  
}