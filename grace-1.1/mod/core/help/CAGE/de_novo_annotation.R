#### SET HELP ####
de_novo_annotation.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Reference-based Annotation'), br(),
           
           p(style = 'word-break:break-word',
             '
             After cell filtering, GRACE can compute spearman’s rank correlations between the test cells and all types of the cells in the training set with the given label (using SingleR default reference), 
             based on the expression profiles of the genes. 
             The label with the highest score is used as the prediction for that cell. 
             When users start ', tags$b('"Reference-based Annotation"'), ', each cluster is defined as the highly potential types of cells, 
             according to the selected reference.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image1_01.png'), br(), br(),
             
             tags$li(tags$b('Resolution:'), br(),
                     'Users first needs to select the suitable resolution through this menu. 
                     Here, GRACE provides 4 score: 0.2, 0.5, 0.8 and 1.2.'), br(),
             tags$li(tags$b('Annotation using Customized Reference:'), br(),
                     'GRACE also supports cell annotation using customized references. Users first select ', tags$b('"Yes"'), ' under ', tags$b('"Annotation Using Customized Ref."'), ', 
                     and then upload customized reference. (Note: References can be customily made following the format of SingleR reference.)'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image1_02.png'), br(), br(),
             
             tags$li(tags$b('Annotated:'), br(),
                     'Usually, the default parameter is ', tags$b('"Yes"'), '. If users select ', tags$b('"No"'), ' parameter, the following ', tags$b('"Annotation Type"'), 
                     ' will be changed to display the numeric value of resolution.'), br(),
             tags$li(tags$b('Annotation Type:'), br(),
                     'Selecting a proper type of reference for cell annotation. 
                     Two options: ', tags$b('"SingleR Main-label"'), ' and ', tags$b('"SingleR Fine-label"'), ' are defined as the same as SingleR parameter.'), br(),
             tags$li(tags$b('Cell ratio:'), br(),
                     'Excessive number of cells in the cluster graph will cause greater display pressure. 
                     Users can select the appropriate ratio through ', tags$b('"Cell Ratio"'), ' to sample different types of cells in equal proportions.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image1_03.png'), br(), br(),
             
             tags$li(tags$b('Cell Type Table:'), br(),
                     'A table displays all cell types available for subsequent analysis; users can select one or multiple types for further analysis, such as "Subclustering Analysis"'), br(),
             tags$li(tags$b('Ref. of Cell Annotation for Subclustering:'), br(),
                     'This function supports users to select a cell-type reference for further cell annotation using SingleR.'), br(),
             tags$li(tags$b('EXEC:'), br(),
                     'Fetch cells from selected cluster.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image1_04.png'), br(), br(),
             
             tags$li(tags$b('Cell clustering and plot visualization:'), br(),
                     'Users can see the annotated cell types and the cell number in the left table. GRACE provides three visualized plots, including PCA, tSNE, and UMAP.'), br(),
             ####
           )
    )
  )
)
########