#### SET HELP ####
itComm.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Inter-type Communication'), br(),
           
           p(style = 'word-break:break-word',
             '
             ', tags$b('"Inter-type communication"'), ' module gives users one deep understanding of cell-cell communication. 
             This module provides a user-friendly web interface for both experts and researchers with little experience in computational biology. 
             In this method, only the interaction pairs that pass a certain threshold for expression level or number of cells expressing the specific interactors in the respective cell populations are selected for the downstream analysis. 
             ', tags$b('"Intra-type communication"'), ' module implements CellphoneDB (', a('https://pypi.org/project/CellPhoneDB/'), ') to score the interactions by calculating the product of average receptor and average ligand expression in the corresponding cell types. 
             The active interaction pairs must assess the statistical significance of each interaction score. ', tags$b('"Intra-type communication"'), ' module also supports users to investigate every known ligand-receptor pair, and quickly plot publication-ready images.
             '
           ),
           
           hr(),
           
           tags$ul(
             tags$li(tags$b('CellphoneDB'), br(),
               tags$ol(
                 ####
                 br(), br(), img(class='img-thumbnail', src = 'help.materials/itComm/image1_01.png'), br(), br(),
                 
                 tags$li(tags$b('Exec CellphoneDB:'), br(),
                         'After selecting the one of total references for cell annotation via ', tags$b('"Annotated"'), ' and ', tags$b('"Annotations Type"'), ', 
                         users can click on ', tags$b('"Exec CellphoneDB"'), ' button to invoke this module. When running has finished, bubble plot will show cell-cell interaction and ligand-receptor pairs in the chart area.'), br(),
                 tags$li(tags$b('Specify cell-cell communication:'), br(),
                         'This function infers the biologically significant cell-cell communication by assigning each interaction (signal transduction from one type of cell as secreting ligand to the other type of cell as receptor). 
                         Users must specify the cell group for ligand and receptor.'), br(),
                 tags$li(tags$b('Specify ligand-receptor pair:'), br(),
                         '', tags$b('"Communicated pair"'), ' allows users can specify one ligand-receptor to investigate this signaling transduction between each cell pair.'), br(),
                 ####
               )
             ),
             
             br(), br(),
             
             tags$li(tags$b('CellCall'), br(),
               tags$ol(
                 ####
                 br(), br(), img(class='img-thumbnail', src = 'help.materials/itComm/image2_01.png'), br(), br(),
                 
                 tags$li(tags$b('Species:'), br(),
                         'Select the species for downstream analysis. Currently, only human and mouse are supported.'), br(),
                 tags$li(tags$b('Adjust p-value:'), br(),
                         'Set the FDR threshold, default is 0.05.'), br(),
                 tags$li(tags$b('Exec CellCall:'), br(),
                         'Execute CellCall. If it\'s not the first time, it will refresh the previous results.'), br(),
                 ####
               )
             ),
             
             br(), br(),
             
             tags$li(tags$b('CellChat'), br(),
               tags$ol(
                 ####
                 br(), br(), img(class='img-thumbnail', src = 'help.materials/itComm/image3_01.png'), br(), br(),
                 
                 tags$li(tags$b('Species:'), br(),
                         'Select the species for analysis, currently only supports Human and Mouse species.'), br(),
                 tags$li(tags$b('DB Type:'), br(),
                         'Select the database version to use, and currently only Secreted Signaling is available.'), br(),
                 tags$li(tags$b('Exec CellChat:'), br(),
                         'Execute CellChat. If it\'s not the first time, it will refresh the previous results.'), br(),
                 ####
                 
                 ####
                 br(), br(), img(class='img-thumbnail', src = 'help.materials/itComm/image3_02.png'), br(), br(),
                 
                 tags$li(tags$b('Actived Pathway:'), br(),
                         'Select the Active pathway to display. The plot on the right will change accordingly.'), br(),
                 ####
               )
             )
           )
    )
  )
)
########