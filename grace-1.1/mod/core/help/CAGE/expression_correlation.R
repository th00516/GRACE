#### SET HELP ####
expression_correlation.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Expression Correlation'), br(),
           
           p(style = 'word-break:break-word',
             '
             Here, Pearson correlation coefficient analysis is used to investigate the expression correlation between two selected genes or among each two-gene pairs of multiple genes. 
             Users can select more than two genes for co-expression analysis through ', tags$b('"Select Two or More Genes"'), '. The right bubble and heatmap plot indicating the correlation value of two-gene pairs.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image5_01.png'), br(), br(),
             
             tags$li(tags$b('Select Two or More Genes:'), br(),
                     'Users can select two or more genes here for co-expression analysis, and each time a gene is added, the plot on the right side will refresh.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image5_02.png'), br(), br(),
             
             tags$li(tags$b('Expression Correlation in Each Clusters:'), br(),
                     'Display the expression of selected genes in different cell types. The color depth represents mean expression, while the size of the bubble represents the expression ratio.'), br(),
             ####
           )
    )
  )
)
########