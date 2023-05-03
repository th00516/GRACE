#### SET HELP ####
general_interface_structure.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('General Interface Structure'), br(),
           
           p(style = 'word-break:break-word',
             '
             As shown in the figure below, the user inferface includes three areas: 
             ', tags$b('toolbar'), ' on the top, the major ', tags$b('working area'), ' in the left side. 
             and ', tags$b('plot & visualization area'), ' in the right side. 
             The working area mainly includes parameter sub-area and control-panel, 
             which can be used for submitting parameters and selecting pipelines for data process. 
             In plot visualization area, there is dynamic plot and static plot, 
             which is synchronously displayed. 
             Interactive visualization also supports displaying a context or information depending on the object under the mouse cursor.
             '
           ),
           
           br(),
           
           img(class='img-thumbnail', src = 'help.materials/introduction/image02.png'), br(), br(),
    )
  )
)
########