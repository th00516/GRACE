#### IMPORT FUNC ####
source('mod/core/inter_cellchat/ctl/attribution.R')
source('mod/core/inter_cellchat/ctl/cell_clustering.R')
source('mod/core/inter_cellchat/ctl/action.R')


source('mod/core/inter_cellchat/act/exec_cellchat.R')
source('mod/core/inter_cellchat/act/pick_pathways.R')


source('mod/core/inter_cellchat/plt/cellchat_plot.R')
####




#### SET UI ####
core.inter_cellchat.UI <- sidebarLayout(
  sidebarPanel(width = 5,
               
               fluidRow(
                 column(6, uiOutput('inter_cellchat_ctl_exec_attr_1'), align = 'left'),
                 column(6, uiOutput('inter_cellchat_ctl_exec_attr_2'), align = 'right')
               ),
               
               fluidRow(
                 column(6, uiOutput('inter_cellchat_ctl_attr_species'), align = 'left'),
                 column(6, uiOutput('inter_cellchat_ctl_attr_dbtype'),  align = 'right')
               ),
               
               uiOutput('inter_cellchat_ctl_exec_1'),
               
               hr(),
               
               uiOutput('inter_cellchat_tab_pathway')
    
  ),
  
  mainPanel(width = 7,
    br(), tabsetPanel(
      tabPanel('Bubble',    br(), plotOutput('inter_cellchat_plt_1a', height = '600px'),
                            hr(), plotOutput('inter_cellchat_plt_1b', height = '600px')),
      tabPanel('Aggregate', br(), plotOutput('inter_cellchat_plt_2a', height = '600px'),
                            hr(), plotOutput('inter_cellchat_plt_2b', height = '600px')),
      tabPanel('Heatmap',   br(), plotOutput('inter_cellchat_plt_3a', height = '600px'),
                            hr(), plotOutput('inter_cellchat_plt_3b', height = '600px')),
      tabPanel('Gene Exp.', br(), plotOutput('inter_cellchat_plt_4a', height = '600px'),
                            hr(), plotOutput('inter_cellchat_plt_4b', height = '600px'))
    )
  )
)
####




#### SERVER ####
core.inter_cellchat <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$inter_cellchat_ctl_exec_attr_1 <- renderUI(
    core.inter_cellchat.ctl.attr_chooser('inter_cellchat_ctl_exec_attr_1', 'Annotated',
                                         c('Yes', 'No'), 'Yes',
                                         DATA.ID())
  )
  
  observeEvent(input$inter_cellchat_ctl_exec_attr_1, {
    
    output$inter_cellchat_ctl_exec_attr_2 <- renderUI(
      core.inter_cellchat.ctl.cell_clustering('inter_cellchat_ctl_exec_attr_2', 'Anntation Type',
                                              input$inter_cellchat_ctl_exec_attr_1,
                                              DATA.ID())
    )
    
  })
  
  output$inter_cellchat_ctl_attr_species <- renderUI(
    core.inter_cellchat.ctl.attr_picker('inter_cellchat_ctl_attr_species', 'Species',
                                        'species',
                                        DATA.ID())
  )
  
  output$inter_cellchat_ctl_attr_dbtype <- renderUI(
    core.inter_cellchat.ctl.attr_picker('inter_cellchat_ctl_attr_dbtype', 'DB Type',
                                        'db_type',
                                        DATA.ID())
  )
  
  output$inter_cellchat_ctl_exec_1 <- renderUI(
    core.inter_cellchat.ctl.action('inter_cellchat_ctl_exec_1', 'Exec CellChat', 'play',
                                   DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$inter_cellchat_ctl_exec_1, {
    
    core.inter_cellchat.act.exec_cellchat(DBPATH(), DATA.ID(), DATA(),
                                          input$inter_cellchat_ctl_exec_attr_2,
                                          list(input$inter_cellchat_ctl_attr_species,
                                               input$inter_cellchat_ctl_attr_dbtype))
    
  })
  
  
  
  ## TABLE ##
  candidate_pathways <- eventReactive(c(T, input$inter_cellchat_ctl_exec_1), {
    
    core.inter_cellchat.act.pick_pathways(DBPATH(), DATA.ID(), DATA.ID())
  
  })
  
  output$inter_cellchat_tab_pathway <- renderUI(
    core.inter_cellchat.ctl.attr_picker.mutable('inter_cellchat_tab_pathway', 'Actived Pathway',
                                                candidate_pathways(),
                                                DATA.ID())
  )
  
  
  
  
  ## PLOT ##
  observeEvent(c(T, input$inter_cellchat_ctl_exec_1), {
    
    output$inter_cellchat_plt_1a <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g1', input$inter_cellchat_tab_pathway, 'bubble',
                              DATA.ID())
    )
    
    output$inter_cellchat_plt_1b <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g2', input$inter_cellchat_tab_pathway, 'bubble',
                              DATA.ID())
    )
    
    
    output$inter_cellchat_plt_2a <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g1', input$inter_cellchat_tab_pathway, 'aggregate',
                              DATA.ID())
    )
    
    output$inter_cellchat_plt_2b <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g2', input$inter_cellchat_tab_pathway, 'aggregate',
                              DATA.ID())
    )
    
    
    output$inter_cellchat_plt_3a <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g1', input$inter_cellchat_tab_pathway, 'heatmap',
                              DATA.ID())
    )
    
    output$inter_cellchat_plt_3b <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g2', input$inter_cellchat_tab_pathway, 'heatmap',
                              DATA.ID())
    )
    
    
    output$inter_cellchat_plt_4a <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g1', input$inter_cellchat_tab_pathway, 'exp',
                              DATA.ID())
    )
    
    output$inter_cellchat_plt_4b <- renderPlot(
      core.inter_cellchat.plt(DBPATH(), DATA.ID(), 'g2', input$inter_cellchat_tab_pathway, 'exp',
                              DATA.ID())
    )
  })
  
}