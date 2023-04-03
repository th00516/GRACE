#### SET HELP ####
pathway_enrichment.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Pathway Enrichment'), br(),
           
           p(style = 'word-break:break-word',
             '
             Biological pathway analysis brings new insights for cell clustering and functional annotation from single-cell RNA sequencing (scRNA-seq) data. 
             For single-cell transcriptome analysis, pathway enrichment analysis has been widely used to cluster subtype heterogeneity and classify biological functional annotation. 
             GRACE develops ', tags$b('"Pathway Enrichment"'), ' module to depict pathways or biological processes at single-cell resolution. 
             GRACE applies the pathway enrichment scores to evaluate pathway activity for individual cell.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/subAna/image4_01.png'), br(), br(),
             
             tags$li(tags$b('Set threshold for PCs:'), br(),
                     'Set the suitable threshold of principal components (PCs) for high variant genes (HVGs) identified by upstream pipeline. 
                     Here, GRACE provide the common threshold (1, 5,10,15, 20) for selection of PCs. The Elbow plot (see the following figure) visualizes the standard deviation of each PC, 
                     which can help users to determine the suitable threshold.'), br(),
             tags$li(tags$b('Exec ClusterProfiler:'), br(),
                     'The ', tags$b('"Exec ClusterProfiler"'), ' button is used to run ', tags$b('"Pathway Enrichment"'), ' module. First, ', tags$b('"Pathway Enrichment"'), ' module performs gene-set enrichment on HVGs. 
                     The enriched pathways are displayed in the left area. Next, users can select interesting pathway to compare the activity score among each cell type or individual cell (See method for details). 
                     GRACE also implements clusterProfiler (', a('https://bioconductor.org/packages/release/bioc/html/clusterProfiler.html'), ') to visualize bubble plot.'), br(),
             ####
           )
    )
  )
)
########