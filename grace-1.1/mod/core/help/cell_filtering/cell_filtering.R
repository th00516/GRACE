#### SET HELP ####
cell_filtering.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Cell Filtering'), br(),
           
           p(style = 'word-break:break-word',
             '
             ', tags$b('"Cell Filtering"'), ' is an optional function. After generation of project and data upload, 
             users can start the filtering of unusual cells. 
             Alternatively, users can skip this step and directly perform subsequent analysis on next section. 
             GRACE provides several indexes to filter cells, including UMI counts, feature counts gene counts, 
             percent of mitochondrial genes, and the expression of beta-action.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/cell_filtering/image01.png'), br(), br(),
             
             tags$li(tags$b('Filtering low-quality cells:'), br(),
                     'In this step, the filtering threshold can be set according to the total UMI count in each cell, and the number of feature counts. 
                     By sliding the buttons, users can select the suitable range for ', tags$b('"UMI Count"'), ' of each cell and the maximum value of the ,', tags$b('"Gene Count"'), ', 
                     respectively (see the following image). After setting these ranges, 
                     the violin plot of UMI counts and feature counts can be viewed on the plot and visualization area (right area).'), br(),
             tags$li(tags$b('Filter the potential dead cells:'), br(),
                     'In this step, the filtering threshold on the percent of mitochondrial genes and the expression of beta-action can be set. 
                     By sliding the buttons (see the following figure), 
                     users can select the suitable range for the percentages of mitochondrial genes in total detected genes, 
                     and the relative expression of beta-actin, which is usually highly expressed in alive cells. Similarly, 
                     the violin plot can be viewed on the right area.'), br(),
             tags$li(tags$b('Doublet Removal: (optional step)'), br(),
                     'Selecting ', tags$b('"Yes"'), ' to remove cell doublets and ', tags$b('"No"'), ' to skip the step of doublet removal.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/cell_filtering/image02.png'), br(), br(),
             
             tags$li(tags$b('Cell & Gene Count:'), br(),
                     'Statistics of used cell counts and used gene count'), br(),
             tags$li(tags$b('Preview:'), br(),
                     'Update plot & visualization area using user customized threshold'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/cell_filtering/image03.png'), br(), br(),
             
             tags$li(tags$b('Select Gene Set for PCA:'), br(),
                     'A default gene set of top 2000 highly variable genes (HVGs) is available for constructing PCA. 
                     Additionally, users can use the sklearn LinearSVC model and ExtraTreesClassifier to select genes using prior classification information. 
                     GRACE also allows users to upload a single-column gene list for constructing PCA.'), br(),
             tags$li(tags$b('Genes Removal from the List:'), br(),
                     'GRACE provides users with commonly used filter genes as selectable options, 
                     including cell-cycle genes, Ribosome genes, and both Cell cycle & Ribosome genes. 
                     Furthermore, GRACE also offers the ability for users to upload personalized sets of genes for removal.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/cell_filtering/image04.png'), br(), br(),
             
             tags$li(tags$b('Elbowplot:'), br(),
                     'The function is used to assist in selecting the most appropriate PCs for subsequent analysis. The function” Elbowplot” is the same as that in Seurat package.'), br(),
             tags$li(tags$b('Top PCs:'), br(),
                     'The user can select the top N PCs to be used for nonlinear dimensionality reduction and clustering according to the Elbow plot above.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/cell_filtering/image05.png'), br(), br(),
             
             tags$li(tags$b('min.dist in RunUMAP:'), br(),
                     'This parameter controls the cell density of the same cluster. As the value of the parameter decreases, the cells of the same cluster become closer together, and the interval between clusters will increases.'), br(),
             tags$li(tags$b('k.param of kNN:'), br(),
                     'During constructing SNN, the coordinate distances of first value of kNN are selected to calculate intercellular Jaccard distance. The default value is 20.'), br(),
             tags$li(tags$b('Cluster Algorithms:'), br(),
                     'Several algorithms of Modularity can be selected during cell clustering. Here, GRACE incorporates “FindCluster” function to perform cell clustering. The optional algorithms are as shown above.'), br(),
             tags$li(tags$b('EXEC:'), br(),
                     'After users click ', tags$b('"EXEC"'), ' button, GRACE starts the performance of data standardization, dimension reduction, and cell clustering. The results can be temporally stored at the online server.'), br(),
             ####
           )
    )
  )
)
########