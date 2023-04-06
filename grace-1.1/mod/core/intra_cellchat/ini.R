#### IMPORT FUNC ####
source('mod/core/intra_cellchat/ctl/attribution.R')
source('mod/core/intra_cellchat/ctl/cell_clustering.R')
source('mod/core/intra_cellchat/ctl/action.R')


source('mod/core/intra_cellchat/act/exec_cellchat.R')
source('mod/core/intra_cellchat/act/pick_pathways.R')


source('mod/core/intra_cellchat/plt/cellchat_plot.R')
####




#### SET UI ####
core.intra_cellchat.UI <- sidebarLayout(
  sidebarPanel(width = 5,
               
               fluidRow(
                 column(6, uiOutput('intra_cellchat_ctl_exec_attr_1'), align = 'left'),
                 column(6, uiOutput('intra_cellchat_ctl_exec_attr_2'), align = 'right')
               ),
               
               fluidRow(
                 column(6, uiOutput('intra_cellchat_ctl_attr_species'), align = 'left'),
                 column(6, uiOutput('intra_cellchat_ctl_attr_dbtype'),  align = 'right')
               ),
               
               uiOutput('intra_cellchat_ctl_exec_1'),
               
               hr(),
               
               uiOutput('intra_cellchat_tab_pathway')
    
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('Bubble',    br(), plotOutput('intra_cellchat_plt_1a', height = '600px'),
                            hr(), plotOutput('intra_cellchat_plt_1b', height = '600px')),
      tabPanel('Aggregate', br(), plotOutput('intra_cellchat_plt_2a', height = '600px'),
                            hr(), plotOutput('intra_cellchat_plt_2b', height = '600px')),
      tabPanel('Heatmap',   br(), plotOutput('intra_cellchat_plt_3a', height = '600px'),
                            hr(), plotOutput('intra_cellchat_plt_3b', height = '600px')),
      tabPanel('Gene Exp.', br(), plotOutput('intra_cellchat_plt_4a', height = '600px'),
                            hr(), plotOutput('intra_cellchat_plt_4b', height = '600px'))
    )
  )
)
####




#### SERVER ####
core.intra_cellchat <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$intra_cellchat_ctl_exec_attr_1 <- renderUI(
    core.intra_cellchat.ctl.attr_chooser('intra_cellchat_ctl_exec_attr_1', 'Annotated',
                                         c('Yes', 'No'), 'Yes',
                                         GRP.ID())
  )
  
  observeEvent(input$intra_cellchat_ctl_exec_attr_1, {
    
    output$intra_cellchat_ctl_exec_attr_2 <- renderUI(
      core.intra_cellchat.ctl.cell_clustering('intra_cellchat_ctl_exec_attr_2', 'Anntation Type',
                                              input$intra_cellchat_ctl_exec_attr_1,
                                              GRP.ID())
    )
    
  })
  
  output$intra_cellchat_ctl_attr_species <- renderUI(
    core.intra_cellchat.ctl.attr_picker('intra_cellchat_ctl_attr_species', 'Species',
                                        'species',
                                        GRP.ID())
  )
  
  output$intra_cellchat_ctl_attr_dbtype <- renderUI(
    core.intra_cellchat.ctl.attr_picker('intra_cellchat_ctl_attr_dbtype', 'DB Type',
                                        'db_type',
                                        GRP.ID())
  )
  
  output$intra_cellchat_ctl_exec_1 <- renderUI(
    core.intra_cellchat.ctl.action('intra_cellchat_ctl_exec_1', 'Exec CellChat', 'play',
                                   GRP.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$intra_cellchat_ctl_exec_1, {
    
    core.intra_cellchat.act.exec_cellchat(DBPATH(), GRP.ID(), GRP(),
                                          input$intra_cellchat_ctl_exec_attr_2,
                                          list(input$intra_cellchat_ctl_attr_species,
                                               input$intra_cellchat_ctl_attr_dbtype))
    
  })
  
  
  
  ## TABLE ##
  candidate_pathways <- eventReactive(c(T, input$intra_cellchat_ctl_exec_1), {
    
    core.intra_cellchat.act.pick_pathways(DBPATH(), GRP.ID(), GRP.ID())
    
  })
  
  output$intra_cellchat_tab_pathway <- renderUI(
    core.intra_cellchat.ctl.attr_picker.mutable('intra_cellchat_tab_pathway', 'Actived Pathway',
                                                candidate_pathways(),
                                                GRP.ID())
  )
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$intra_cellchat_ctl_exec_1), {
    
    output$intra_cellchat_plt_1a <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g1', input$intra_cellchat_tab_pathway, 'bubble',
                              GRP.ID())
    )
    
    output$intra_cellchat_plt_1b <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g2', input$intra_cellchat_tab_pathway, 'bubble',
                              GRP.ID())
    )
    
    
    output$intra_cellchat_plt_2a <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g1', input$intra_cellchat_tab_pathway, 'aggregate',
                              GRP.ID())
    )
    
    output$intra_cellchat_plt_2b <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g2', input$intra_cellchat_tab_pathway, 'aggregate',
                              GRP.ID())
    )
    
    
    output$intra_cellchat_plt_3a <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g1', input$intra_cellchat_tab_pathway, 'heatmap',
                              GRP.ID())
    )
    
    output$intra_cellchat_plt_3b <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g2', input$intra_cellchat_tab_pathway, 'heatmap',
                              GRP.ID())
    )
    
    
    output$intra_cellchat_plt_4a <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g1', input$intra_cellchat_tab_pathway, 'exp',
                              GRP.ID())
    )
    
    output$intra_cellchat_plt_4b <- renderPlot(
      core.intra_cellchat.plt(DBPATH(), GRP.ID(), 'g2', input$intra_cellchat_tab_pathway, 'exp',
                              GRP.ID())
    )
  })
  
}