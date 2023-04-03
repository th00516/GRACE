#### SET HELP ####
defined_subcluster.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Defined Subcluster'), br(),
           
           p(style = 'word-break:break-word',
             '
             GRACE allows users to select HVGs and PCs that are more relevant to internal structure, 
             improving resolution by avoiding noise from unnecessary features. 
             This step can help to potentially identify high-diverse subtypes, discovering novel mechanism. 
             ', tags$b('"Defined Subcluster"'), ' analysis is helpful to define a customized function that calls the useful algorithm to obtain a clustering from upstream analysis. 
             This function best reduces researchers work and computational time.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/subAna/image1_01.png'), br(), br(),
             
             tags$li(tags$b('Remove Selected Subcluster:'), br(),
                     'Users can click this button to cancel the selection.'), br(),
             tags$li(tags$b('Annotated & Annotated type:'), br(),
                     'This function is the same as upstream pipeline (De-novo Annotation).'), br(),
             tags$li(tags$b('Visualization by the Separated Groups:'), br(),
                     'After selecting one subcluster, pseudotime trajectory image has been separated, 
                     according to sample group, once users select ', tags$b('"Yes"'), ' on the ', tags$b('"Separated by Group"'), ' button.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/subAna/image1_02.png'), br(), br(),
             
             tags$li(tags$b('Gene List:'), br(),
                     'Select a gene for expression exhibiting in each subcluster'), br(),
             ####
           )
    )
  )
)
########