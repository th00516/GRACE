#### SET HELP ####
subAna.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Subclustering Snalysis'), br(),
           
           p(style = 'word-break:break-word',
             '
             After users have completed the GRACE pipeline workflow, and identified the various cell types present in their datasets, 
             GRACE supports users to focus on investigation of one particular cell type. 
             ', tags$b('"Subclustering analysis"'), ' is a general and conceptually straightforward procedure for increasing resolution. 
             ', tags$b('"Subclustering analysis"'), ' of GRACE can separate cells according to more modest heterogeneity in the absence of distinct subpopulations. Furthermore, 
             ', tags$b('"Subclustering analysis"'), ' contains 4 modules, including ', tags$b('"Defined Subcluster"'), ', ', tags$b('"Development Trajectory"'), ', ', tags$b('"Pathway Enrichment"'), ', and ', tags$b('"Intra-type communication"'), ', 
             which comprehensively support users to depict functional subtypes. 
             ', tags$b('"Subclustering analysis"'), ' module can be applied multiple times on different types of cells without having to repeatedly copy and modify the code for each cell type.
             '
           )
    )
  )
)
########