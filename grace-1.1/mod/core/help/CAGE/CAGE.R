#### SET HELP ####
CAGE.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Cell Annotation & Gene Expression'), br(),
           
           p(style = 'word-break:break-word',
             '
             ', tags$b('"Cell Annotation & Gene Expression"'), ' page is divided into 6 functional sections, 
             including ', tags$b('"Reference-based Annotation"'), ', ', tags$b('"Atlas-based Annotation"'), ', ', tags$b('"Manual Annotation"'), ', ', 
             tags$b('"Expression Analysis"'), ', ', tags$b('"Expression Correlation"'), ', and ', tags$b('"Cell Cycle"'), '. 
             Here, GRACE provides three ways to annotate data. “Reference-based Annotation” provides general and fine-tune cell references for Homo sapiens and Mus musculus. Besides, 
             ', tags$b('"Reference-based Annotation"'), ' allows users to upload their customized references. 
             ', tags$b('"Atlas-based Annotation"'), ' represents supervised mapping to users’ customized reference. 
             GRACE implemented weighted-nearest neighbor (WNN) to support this function. 
             WNN represents an attractive alternative to unsupervised analysis, 
             enabling users to rapidly map their own datasets onto the annotated single-cell atlas. 
             Many tissues and cell-types can be freely available online, and users can directly download them as GRACE reference. 
             ', tags$b('"Manual Annotation"'), ' also allows users to manually change cell type on the visualized plots. 
             GRACE supports users to investigate multiple gene expression and correlation (See ', tags$b('"Expression Analysis"'), ', 
             and ', tags$b('"Expression Correlation"'), ' in detail). ', tags$b('"Cell Cycle"'), ' represents the prediction of cell cycle state for each cell.
             '
           )
    )
  )
)
########