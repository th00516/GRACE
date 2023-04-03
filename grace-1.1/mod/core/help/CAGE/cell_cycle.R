#### SET HELP ####
cell_cycle.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Cell Cycle'), br(),
           
           p(style = 'word-break:break-word',
             '
             GRACE assigns each cell a score, based on its expression of G2/M and S phase markers, along with the predicted classification of each cell in either G2M, S or G1 phase. 
             These marker sets should be anti-correlated in their expression levels, and cells expressing neither are likely not cycling and in G1/G0 phase.
             '
           ),
           
           hr(),
           
           tags$ol(
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image6_01.png'), br(), br(),
             
             ####
             tags$li(tags$b('Cell Cycle plot:'), br(),
                     'GRACE utilizes Seurat for cell cycle state analysis and provides the following states: G1, G2M, S phase.'), br(),
             ####
           )
    )
  )
)
########