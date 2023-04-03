#### SET HELP ####
atlas_based_annotation.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Atlas-based Annotation'), br(),
           
           p(style = 'word-break:break-word',
             '
             Many atlas-references already be built in GRACE, such as ', tags$b('"Human PMBC 10k"'), ' human bone marrow, ', tags$b('"human kidney"'), ' and ', tags$b('"mouse motor cortex"'), ' datasets. 
             Furthermore, GRACE also supports customized atlas for annotation. Users can upload one annotated single-cell dataset (supporting scRNAseq dataset, or multimodal dataset) as reference through ', tags$b('"Upload"'), ' slot. 
             Then, click ', tags$b('"Mapping"'), ' to map the uploaded dataset onto the reference atlas. (Note: The format of customized atlas reference must be RDS format.)
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/CAGE/image2_01.png'), br(), br(),
             
             tags$li(tags$b('Choose Atlas:'), br(),
                     'Select an Atlas to use for clustering and annotation mapping. 
                     Currently, GRACE includes the following datasets for analysis: 
                     Human PBMC 10k, Human Bone Marrow, Human Kidney, and Mouse Motor Cortex.'), br(),
             tags$li(tags$b('Customized Atlas Reference:'), br(),
                     'This feature supports users to upload their own datasets in Seurat Object RDS format.'), br(),
             tags$li(tags$b('Mapping:'), br(),
                     'Exec atlas-based mapping'), br(),
             ####
           )
    )
  )
)
########