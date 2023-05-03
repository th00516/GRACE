#### SET HELP ####
data_upload.help <- fluidPage(
  fixedRow(
    column(width = 11,
           h3('Data Upload'), br(),
           
           p(style = 'word-break:break-word',
             '
             Here, users can load personal datasets and perform data preprocessing. 
             Various data and formats can be loaded on this page. 
             GRACE supports multiple data formats frequently used in scRNA-seq analysis, 
             including tab-separated value/text (tsv/txt), 
             comma-separated value (csv) formats directly downloaded from GEO database, 
             normal RDS format as input of Seurat package, 
             and HDF5 format generated from 10x Cellranger package. 
             GRACE allows multiple samples uploading, and provide temporay project repository for users.
             '
           ),
           
           hr(),
           
           tags$ol(
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/data_upload/image01.png'), br(), br(),
             
             tags$li(tags$b('Project Name:'), br(),
                     'Enter the project name to generate the project repository.'), br(),
             tags$li(tags$b('Add Proj.:'), br(),
                     'Click this button to add the new project. After that, the newly created project is displayed on the right table.'), br(),
             tags$li(tags$b('Del Proj.:'), br(),
                     'Select at least one datasets on the right table, and click this button to delete it/them along with all the related data.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/data_upload/image02.png'), br(), br(),
             
             tags$li(tags$b('Upload:'), br(),
                     'When project has been constructed, users can click this button to upload single-cell data matrix. 
                     Select one local path to upload users’ datasets. (Note: Uploading path only supports English letters, number and character)'), br(),
             tags$li(tags$b('Sample Name:'), br(),
                     'Enter the sample name here.'), br(),
             tags$li(tags$b('Species:'), br(),
                     'Add species information of samples.'), br(),
             tags$li(tags$b('Group info.:'), br(),
                     'Define group information for each sample. Currently, GRACE only provides a subsequent two-group comparative analysis, such as a high-frequently comparative schema (negative control vs treatment).'), br(),
             tags$li(tags$b('Need Find Doublet?:'), br(),
                     'Execute DoubletFinder to predicte doublet.'), br(),
             tags$li(tags$b('Import Data:'), br(),
                     'Click here to start importing the dataset. After that, several steps have been processed with default parameters, including normalization, dimensionality reduction, cell clustering, and doublet detection.'), br(),
             tags$li(tags$b('Del Data:'), br(),
                     'After the selection of data from the right table, click here to delete all the analyzed data.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/data_upload/image03.png'), br(), br(),
             
             tags$li(tags$b('Samples for Batch Effect Removal:'), br(),
                     'Users can choose batch effect removal or merge directly without batch removal. 
                     (Reminder: Integrative analysis always requires removing batch effects between multiple datasets. 
                     If the experimental datasets are obtained from different batches, 
                     we recommend that the batch effect should be corrected before downstream analysis. 
                     GRACE implements RPCA method, ', a('https://satijalab.org/seurat/articles/integration_rpca.html'), ', to achieve this function.)'), br(),
             tags$li(tags$b('Available Methods:'), br(),
                     'Methods for selecting batch effect removal include RPCA, FastMNN, Harmony, scVI, and scANVI.'), br(),
             tags$li(tags$b('EXEC:'), br(),
                     'Click here to integrate samples from different batches. RPCA algorithm from Seurat package is already incorporated at this step.'), br(),
             ####
             
             ####
             br(), br(), img(class='img-thumbnail', src = 'help.materials/data_upload/image04.png'), br(), br(),
             
             tags$li(tags$b('Project & Data Repository Table:'), br(),
                     'Displays all of the project ID (PROJ.ID). After selecting one project, information for all of the included samples will be displayed,as following table shown.'), br(),
             tags$li(tags$b('Data Download:'), br(),
                     'Download selected data, including all of the results'), br(),
             ####
           )
    )
  )
)
########