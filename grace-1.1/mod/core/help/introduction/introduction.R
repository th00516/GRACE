#### SET HELP ####
introduction.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Introduction'), br(),
           
           p(style = 'word-break:break-word',
             '
             GRACE is a web-based application for single-cell data analysis and visualization. 
             GRACE supports all common single-cell RNA sequencing (scRNA-seq) types, 
             and executes Data preprocessing and functional downstream processing, 
             providing interactive data visualizations to help customized analysis. 
             With GRACE, users can easily analyze single-cell data, 
             and generate publication-ready results through code-free interface. 
             Furthermore, GRACE also provides data management system and support multiple data formats frequently used in scRNA-seq analysis, 
             including tab-separated value/text (tsv/txt), comma-separated value (csv) formats directly downloaded from GEO database, 
             normal RDS format as input of Seurat package, and Hd5 format generated from 10x Cellranger package. 
             The matrix should be formatted with features (column) and barcodes (row). 
             GRACE also support both online and Docker package which can be used for a simple installation on user’s local Linux.
             '
           ),
           
           p(style = 'word-break:break-word',
             '
             GRACE is a robust software focusing on scRNA-seq data analysis with multi-dataset integration capability. 
             GRACE provides customized and cutting-edge analysis, and interactive data visualization services. 
             GRACE allows scientists, even ones with limited programming ability, 
             to quickly investigate massive amounts of scRNA-seq. To use this software more effectively, 
             please refer to the following step-by-step instructions or online video tutorial.
             '
           ),
           
           br(),
           
           img(class='img-thumbnail', src = 'help.materials/introduction/image01.png'), br(), br(),
           
    )
  )
)
########