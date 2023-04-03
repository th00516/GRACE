#### IMPORT FUNC ####
source('mod/core/inter_cellcall/ctl/attribution.R')
source('mod/core/inter_cellcall/ctl/cell_clustering.R')
source('mod/core/inter_cellcall/ctl/action.R')


source('mod/core/inter_cellcall/act/exec_cellcall.R')


source('mod/core/inter_cellcall/plt/cellcall_plot.R')
####




#### SET UI ####
core.inter_cellcall.UI <- sidebarLayout(
  sidebarPanel(width = 5,
               
               fluidRow(
                 column(6, uiOutput('inter_cellcall_ctl_exec_attr_1'), align = 'left'),
                 column(6, uiOutput('inter_cellcall_ctl_exec_attr_2'), align = 'right')
               ),
               
               fluidRow(
                 column(6, uiOutput('inter_cellcall_ctl_attr_species'), align = 'left'),
                 column(6, uiOutput('inter_cellcall_ctl_attr_padjust'), align = 'right')
               ),
               
               uiOutput('inter_cellcall_ctl_exec_1')
    
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('Bubble', br(), plotOutput('inter_cellcall_plt_1a', height = '600px'),
                         hr(), plotOutput('inter_cellcall_plt_1b', height = '600px')),
      tabPanel('Circle', br(), plotOutput('inter_cellcall_plt_2a', height = '600px'),
                         hr(), plotOutput('inter_cellcall_plt_2b', height = '600px'))
    )
  )
)
####




#### SERVER ####
core.inter_cellcall <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$inter_cellcall_ctl_exec_attr_1 <- renderUI(
    core.inter_cellcall.ctl.attr_chooser('inter_cellcall_ctl_exec_attr_1', 'Annotated',
                                          c('Yes', 'No'), 'Yes',
                                          DATA.ID())
  )
  
  observeEvent(input$inter_cellcall_ctl_exec_attr_1, {
    
    output$inter_cellcall_ctl_exec_attr_2 <- renderUI(
      core.inter_cellcall.ctl.cell_clustering('inter_cellcall_ctl_exec_attr_2', 'Anntation Type',
                                               input$inter_cellcall_ctl_exec_attr_1,
                                               DATA.ID())
    )
    
  })
  
  output$inter_cellcall_ctl_attr_species <- renderUI(
    core.inter_cellcall.ctl.attr_picker('inter_cellcall_ctl_attr_species', 'Species',
                                        'species',
                                        DATA.ID())
  )
  
  output$inter_cellcall_ctl_attr_padjust <- renderUI(
    core.inter_cellcall.ctl.attr_input('inter_cellcall_ctl_attr_padjust', 'Adjust p-value',
                                       0.05,
                                       DATA.ID())
  )
  
  output$inter_cellcall_ctl_exec_1 <- renderUI(
    core.inter_cellcall.ctl.action('inter_cellcall_ctl_exec_1', 'Exec CellCall', 'play',
                                   DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$inter_cellcall_ctl_exec_1, {
    
    core.inter_cellcall.act.exec_cellcall(DBPATH(), DATA.ID(), DATA(),
                                          input$inter_cellcall_ctl_exec_attr_2,
                                          list(input$inter_cellcall_ctl_attr_species,
                                               input$inter_cellcall_ctl_attr_padjust))
    
  })
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$inter_cellcall_ctl_exec_1), {
    
    output$inter_cellcall_plt_1a <- renderPlot(
      core.inter_cellcall.plt.plot.bubble(DBPATH(), DATA.ID(), 'g1',
                                          DATA.ID())
    )
    
    output$inter_cellcall_plt_1b <- renderPlot(
      core.inter_cellcall.plt.plot.bubble(DBPATH(), DATA.ID(), 'g2',
                                          DATA.ID())
    )
    
    ##
    
    output$inter_cellcall_plt_2a <- renderPlot(
      core.inter_cellcall.plt.plot.circle(DBPATH(), DATA.ID(), 'g1',
                                          DATA.ID())
    )
    
    output$inter_cellcall_plt_2b <- renderPlot(
      core.inter_cellcall.plt.plot.circle(DBPATH(), DATA.ID(), 'g2',
                                          DATA.ID())
    )
    
    ##
    
    output$inter_cellcall_plt_3a <- renderPlot(
      core.inter_cellcall.plt.plot.sankey(DBPATH(), DATA.ID(), 'g1',
                                          DATA.ID())
    )
    
    output$inter_cellcall_plt_3b <- renderPlot(
      core.inter_cellcall.plt.plot.sankey(DBPATH(), DATA.ID(), 'g2',
                                          DATA.ID())
    )
    
  })
  
}