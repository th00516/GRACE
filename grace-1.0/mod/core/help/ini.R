#### IMPORT FUNC ####
####




#### SET UI ####
core.help.UI <- fluidPage(
  tabsetPanel(
    tabPanel('Introduction',                      br(), uiOutput('help_introduction')),
    tabPanel('Data Upload',                       br(), uiOutput('help_dataUpload')),
    tabPanel('Cell Filtering',                    br(), uiOutput('help_cellFiltering')),
    tabPanel('Cell Annotation & Gene Expression', br(), uiOutput('help_CAGE')),
    tabPanel('Inter-type Communication',          br(), uiOutput('help_itComm')),
    tabPanel('Subclustering Analysis',            br(), uiOutput('help_subAna'))
  )
)
####




#### SERVER ####
core.help <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$help_introduction  <- renderUI(HTML(readLines('mod/core/help/introduction/help.html')))
  output$help_dataUpload    <- renderUI(HTML(readLines('mod/core/help/data_upload/help.html')))
  output$help_cellFiltering <- renderUI(HTML(readLines('mod/core/help/cell_filtering/help.html')))
  output$help_CAGE          <- renderUI(HTML(readLines('mod/core/help/CAGE/help.html')))
  output$help_itComm        <- renderUI(HTML(readLines('mod/core/help/itComm/help.html')))
  output$help_subAna        <- renderUI(HTML(readLines('mod/core/help/subAna/help.html')))
  
  
  
  
  ## ACTIVITY ##
  
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
}
