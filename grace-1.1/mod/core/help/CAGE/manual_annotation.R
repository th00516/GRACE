#### SET HELP ####
manual_annotation.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Manual Annotation'), br(),
           
           p(style = 'word-break:break-word',
             '
             If users want to change the annotation, ', tags$b('"Manual Annotation"'), ' function allows users to change the name of selected clusters, 
             then fill the new name in the right slot of ', tags$b('"New.Cluster.Name"'), '. After that, users click on ', tags$b('"Change Annotation"'), ' button.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image3_01.png'), br(), br(),
             
             tags$li(tags$b('Annotated:'), br(),
                     'Usually, the default parameter is ', tags$b('"Yes"'), '. If users select ', tags$b('"No"'), ' parameter, the following ', tags$b('"Annotation Type"'), 
                     ' will be changed to display the numeric value of resolution.'), br(),
             tags$li(tags$b('Annotation Type:'), br(),
                     'Selecting a proper type of reference for cell annotation. 
                     Two options: ', tags$b('"SingleR Main-label"'), ' and ', tags$b('"SingleR Fine-label"'), ' are defined as the same as SingleR parameter.'), br(),
             tags$li(tags$b('Manual Renaming of Cell Types:'), br(),
                     'This feature is used to manually correct existing cell types or clusters by performing one-to-one renaming.'), br(),
             tags$li(tags$b('Exec Renaming:'), br(),
                     'Perform the renaming function, and write to the data, and refresh the tables and plots.'), br(),
             ####
           )
    )
  )
)
########