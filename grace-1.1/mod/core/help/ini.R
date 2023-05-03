#### IMPORT FUNC ####
source('mod/core/help/introduction/ini.R')
source('mod/core/help/data_upload/ini.R')
source('mod/core/help/cell_filtering/ini.R')
source('mod/core/help/CAGE/ini.R')
source('mod/core/help/itComm/ini.R')
source('mod/core/help/subAna/ini.R')
####




#### SET UI ####
core.help.UI <- fluidPage(
  tabsetPanel(
    tabPanel('Introduction', br(),
             navlistPanel(widths = c(4, 8), well = T,
                          tabPanel('Introduction', introduction.help),
                          tabPanel('General Interface Structure', general_interface_structure.help)
             )
    ),
    
    tabPanel('Data Upload', br(),
             navlistPanel(widths = c(4, 8), well = T,
                          tabPanel('Data Upload', data_upload.help),
             )
    ),
    
    tabPanel('Cell Filtering', br(),
             navlistPanel(widths = c(4, 8), well = T,
                          tabPanel('Cell Filtering', cell_filtering.help),
             )
    ),
    
    tabPanel('Cell Annotation & Gene Expression', br(),
             navlistPanel(widths = c(4, 8), well = T,
                          tabPanel('Cell Annotation & Gene Expression', CAGE.help),
                          tabPanel('Reference-based Annotation', de_novo_annotation.help),
                          tabPanel('Atlas-based Annotation', atlas_based_annotation.help),
                          tabPanel('Manual Annotation', manual_annotation.help),
                          tabPanel('Expression Analysis', expression_analysis.help),
                          tabPanel('Expression Correlation', expression_correlation.help),
                          tabPanel('Cell Cycle', cell_cycle.help)
             )
    ),
    
    tabPanel('Inter-type communication', br(),
             navlistPanel(widths = c(4, 8), well = T,
                          tabPanel('Inter-type Communication', itComm.help),
             )
    ),
    
    tabPanel('Subclustering analysis', br(),
             navlistPanel(widths = c(4, 8), well = T,
                          tabPanel('Subclustering Analysis', subAna.help),
                          tabPanel('Defined Subcluster', defined_subcluster.help),
                          tabPanel('Subcluster Manual Annotation', subcluster_manual_annotation.help),
                          tabPanel('Development Trajectory', development_trajectory.help),
                          tabPanel('Pathway Enrichment', pathway_enrichment.help),
                          tabPanel('Intra-type Communication', intra_type_communication.help),
             )
    )
  )
)
####




#### SERVER ####
core.help <- function(input, output) {
  
  ## INITIALIZE DATA ##
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  # output$help_introduction  <- renderUI(HTML(readLines('mod/core/help/introduction/help.html')))
  # output$help_dataUpload    <- renderUI(HTML(readLines('mod/core/help/data_upload/help.html')))
  # output$help_cellFiltering <- renderUI(HTML(readLines('mod/core/help/cell_filtering/help.html')))
  # output$help_CAGE          <- renderUI(HTML(readLines('mod/core/help/CAGE/help.html')))
  # output$help_itComm        <- renderUI(HTML(readLines('mod/core/help/itComm/help.html')))
  # output$help_subAna        <- renderUI(HTML(readLines('mod/core/help/subAna/help.html')))
  
  
  
  
  ## ACTIVITY ##
  
  
  
  
  ## TABLE ##
  
  
  
  
  ## PLOT ##
}
