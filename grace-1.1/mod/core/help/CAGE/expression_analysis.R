#### SET HELP ####
expression_analysis.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Expression Analysis'), br(),
           
           p(style = 'word-break:break-word',
             '
             By reducing the dimensions of the expression matrix, the high-dimensional single cell expression data can be visualized in low dimensions. 
             We provide three dimensionality reduction methods: PCA, UMAP and t-SNE. The Plot is colored according to the relative gene expression level. 
             Users can input/search the genes they are interested in gene expression analysis. Users can select the genes to be viewed through the Gene list. 
             ', tags$b('"Ave.Exp."'), ' indicating the average amount of expression, and ', tags$b('"Exp.Ratio"'), ' representing the percentage of cells expressing this gene. By default, 
             this left table only displays 10 genes information. Users can input the Gene symbol of interest through ', tags$b('"Search"'), '. 
             Scatter plot and violin plot in right chart area for each gene expression simultaneously can be viewed.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image4_01.png'), br(), br(),
             
             tags$li(tags$b('Gene List:'), br(),
                     'Select a gene for expression exhibiting'), br(),
             tags$li(tags$b('Annotated:'), br(),
                     'Usually, the default parameter is ', tags$b('"Yes"'), '. If users select ', tags$b('"No"'), ' parameter, the following ', tags$b('"Annotation Type"'), 
                     ' will be changed to display the numeric value of resolution.'), br(),
             tags$li(tags$b('Annotation Type:'), br(),
                     'Selecting a proper type of reference for cell annotation. 
                     Two options: ', tags$b('"SingleR Main-label"'), ' and ', tags$b('"SingleR Fine-label"'), ' are defined as the same as SingleR parameter.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image4_02.png'), br(), br(),
             
             tags$li(tags$b('Gene Expression in Each Clusters:'), br(),
                     'These violin plots exhibit the expression distribution of selected gene in each cell type'), br(),
             ####
           )
    )
  )
)
########