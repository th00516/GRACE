#### SET HELP ####
development_trajectory.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Development Trajectory'), br(),
           
           p(style = 'word-break:break-word',
             '
             High advances in single-cell technology are enabling the exploration of cell fate specification at unprecedented resolution. 
             GRACE implements the current popular computational tool (', tags$b('Monocle2'), ', ', a('https://bioconductor.org/packages/release/bioc/html/monocle.html'), ') to achieve the reconstruction of lineage trajectories, 
             the quantification of cell fate bias, performing dimensionality reduction for data visualization. 
             GRACE ', tags$b('"Development Trajectory"'), ' supports users to gain the new mechanistic insights into the process of cell fate decision and lineage differentiation.
             '
           ),
           
           hr(),
           
           tags$ul(
             tags$li(tags$b('Pseudotime Layout'), br(),
                     
                     br(), h5('Trajectory analysis using Monocle2'), br(),
                     
                     tags$ol(
                       ####
                       br(), br(), img(class='img-thumbnail', src = 'help.materials/subAna/image3_1_01.png'), br(), br(),
                       
                       tags$li(tags$b('Exec Monocle2:'), br(),
                               'After users select one cell type (identified by Defined subcluster), users then click on the ', tags$b('"Exec Monocle2"'), ' button to run this module. 
                               The results are synchronously displayed in the right area (visualization area). Three types of images can support users to compare subcluster annotation, 
                               cell fate bias and lineage trajectories.'), br(),
                       tags$li(tags$b('Sperated by group:'), br(),
                               'Once users select “Yes” on the ', tags$b('"Sperated by Group"'), ' button, pseudotime trajectory has been separated according to sample group.'), br(),
                       tags$li(tags$b('View specific gene:'), br(),
                               'After selecting specific one gene from gene list on the left side of the operation area, relative gene expression can be showed across pseudotime tree.'), br(),
                       tags$li(tags$b('Gene list:'), br(),
                               'Exhibit gene expression along DDRTree'), br(),
                       ####
                     )
             ),
             
             br(), br(),
             
             tags$li(tags$b('Force-directed Layout'), br(),
                     
                     br(), h5('Trajectory analysis using SPRING'), br(),
                     
                     br(),
                     tags$ol(
                       ####
                       br(), br(), img(class='img-thumbnail', src = 'help.materials/subAna/image3_2_01.png'), br(), br(),
                       
                       tags$li(tags$b('Minimum UMI Counts:'), br(),
                               'Filter out cells with UMI counts below the threshold, which is set to 1000 by default.'), br(),
                       tags$li(tags$b('Minimum Mean Expression:'), br(),
                               'Filter out genes with mean expression below the threshold, which is set to 0.1 by default.'), br(),
                       tags$li(tags$b('Minimum Fano Factor:'), br(),
                               'Filter out genes with Fano Factor below the threshold, which is set to 3 by default.'), br(),
                       tags$li(tags$b('Number of PCA Dimension:'), br(),
                               'Set the top PCs used for building kNN, which is set to top 20 by default.'), br(),
                       tags$li(tags$b('Number of Nearest Neighbor:'), br(),
                               'Set the k value for kNN, which is set to 5 by default.'), br(),
                       tags$li(tags$b('Fold-change of Coarse-grain:'), br(),
                               'Set the fold-change of coarse-grain, which is set to 1 by default.'), br(),
                       tags$li(tags$b('Run SPRING:'), br(),
                               'Execute SPRING. If it\'s not the first time, it will refresh the previous results.'), br(),
                       ####
                     )
             )
           )
    )
  )
)
########