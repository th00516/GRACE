#### SET HELP ####
intra_type_communication.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Intra-type Communication'), br(),
           
           p(style = 'word-break:break-word',
             '
             Intra-type cell-cell communication gives fine-tune new insight into the coordination of diverse biological processes, 
             such as tissue ecosystem, and immune response of microenvironment mediated by ligand-receptor complexes. 
             GRACE implements CellPhoneDB to infer the intra-type cell-cell communication networks cross many cell subtypes. 
             The detailed information about statistical instructions is similar with upstream pipeline ', tags$b('"Inter-Type Communication"'), '.
             '
           ),
           
           hr(),
           
           tags$ul(
             tags$li(tags$b('CellphoneDB'), br(),
               tags$ol(
                 p(style = 'word-break:break-word',
                   '
                   Operational method is the same as it in CellphoneDB model of Inter-type Communication
                   '
                 )
               )
             ),
             
             br(), br(),
             
             tags$li(tags$b('CellCall'), br(),
               tags$ol(
                 p(style = 'word-break:break-word',
                   '
                   Operational method is the same as it in CellCall model of Inter-type Communication
                   '
                 )
               ),
             ),
             
             br(), br(),
             
             tags$li(tags$b('CellChat'), br(),
               tags$ol(
                 p(style = 'word-break:break-word',
                   '
                   Operational method is the same as it in CellChat model of Inter-type Communication
                   '
                 )
               ),
             ),
           )
    )
  )
)
########