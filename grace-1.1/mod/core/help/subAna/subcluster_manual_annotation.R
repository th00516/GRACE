#### SET HELP ####
subcluster_manual_annotation.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Subcluster Manual Annotation'), br(),
           
           p(style = 'word-break:break-word',
             '
             This part is ported from Manual Annotation model of 
             Cell Annotation & Gene Expression
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/subAna/image2_01.png'), br(), br(),
             
             p(style = 'word-break:break-word',
               'Operational method is the same as it in Manual Annotation model of 
               Cell Annotation & Gene Expression'
             )
             ####
           )
    )
  )
)
########