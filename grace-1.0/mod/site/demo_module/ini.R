#### IMPORT FUNC ####
source('mod/site/demo_module/ctl/action.R')
source('mod/site/demo_module/ctl/attribution.R')


source('mod/site/demo_module/act/function.R')


source('mod/site/demo_module/tab/table.R')


source('mod/site/demo_module/plt/plot.R')
####




#### SET UI ####
site.demo_module.UI <- sidebarLayout(
  sidebarPanel(
    uiOutput('demo_module_ctl_1'),
    uiOutput('demo_module_ctl_2'),
    uiOutput('demo_module_ctl_3')
  ),
  
  mainPanel(
    plotlyOutput('demo_module_plt_1')
  )
)
####




#### SERVER ####
site.demo_module <- function(input, output) {
  
  ## INITIALIZE UI ##
  output$demo_module_ctl_1 <- renderUI(
    site.demo_module.ctl.action('demo_module_ctl_1', 'Widget 1',
                                'dna')
  )
  
  output$demo_module_ctl_2 <- renderUI(
    site.demo_module.ctl.attr_1('demo_module_ctl_2', 'Widget 2',
                                c('A', 'B'), 'A')
  )
  
  output$demo_module_ctl_3 <- renderUI(
    site.demo_module.ctl.attr_2('demo_module_ctl_3', 'Widget 3',
                                c('A', 'B'), 'A')
  )
  
  
  
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$demo_module_ctl_1, {
    
    site.demo_module.act.function(DBPATH(), DATA.ID(), DATA())
    
  })
  
  
  
  
  ## TABLE ##
  output$demo_module_tab_1 <- renderDT(
    site.demo_module.tab.table()
  )
  
  
  
  ## PLOT ##
  output$demo_module_plt_1 <- renderPlotly(
    site.demo_module.plt.plot()
  )
}