#### IMPORT FUNC ####
source('mod/core/data_upload/ctl/action.R')
source('mod/core/data_upload/ctl/file_importing.R')
source('mod/core/data_upload/ctl/attribution.R')
source('mod/core/data_upload/ctl/integration.R')


source('mod/core/data_upload/act/init_record.R')
source('mod/core/data_upload/act/remove_record.R')
source('mod/core/data_upload/act/generate_empty_proj.R')
source('mod/core/data_upload/act/import_data.R')
source('mod/core/data_upload/act/get_present_id.R')
#### modify for nextflow ####
# source('mod/core/data_upload/act/generate_sc_data.R')
# source('mod/core/data_upload/act/integrate_data.R')
########
source('mod/core/data_upload/act/get_data.R')


source('mod/core/data_upload/tab/records.R')
####




#### SET UI ####
core.data_upload.UI <- sidebarLayout(
  sidebarPanel(width = 5,
    core.data_upload.ctl.attr_input('data_upload_ctl_proj_attr_1', 'Project Name', 'Required', T),
    
    fluidRow(
      column(6, core.data_upload.ctl.action('data_upload_ctl_proj_1', 'Add Proj.', 'folder-plus', T), align = 'left'),
      column(6, core.data_upload.ctl.action('data_upload_ctl_proj_2', 'Del Proj.', 'trash-alt', T),   align = 'right')
    ),
    
    hr(),
    
    uiOutput('data_upload_ctl_data_1'),
    uiOutput('data_upload_ctl_data_attr_1'),
    fluidRow(
      column(6, uiOutput('data_upload_ctl_data_attr_2'), align = 'left'),
      column(6, uiOutput('data_upload_ctl_data_attr_3'), align = 'right')
    ),
    # uiOutput('data_upload_ctl_data_attr_4'),
    # uiOutput('data_upload_ctl_data_attr_5'),
    # uiOutput('data_upload_ctl_data_attr_6'),
    uiOutput('data_upload_ctl_data_attr_7'),
    
    fluidRow(
      column(6, uiOutput('data_upload_ctl_data_2'), align = 'left'),
      column(6, uiOutput('data_upload_ctl_data_3'), align = 'right')
    ),
    
    hr(),
    
    fluidRow(
      column(8, uiOutput('data_upload_ctl_data_4'), align = 'lift'),
      column(4, uiOutput('data_upload_ctl_data_inMethod'), align = 'right')
    ),
    uiOutput('data_upload_ctl_data_5')
  ),
  
  mainPanel(width = 7,
    br(), DTOutput('data_upload_tab_proj_1'),
    
    hr(),
    
    br(), tabsetPanel(
      tabPanel('Data Information', br(), DTOutput('data_upload_tab_data_1'),
                                   br(), uiOutput('data_upload_ctl_data_downloadSlot')),
      tabPanel('Detail', br(), DTOutput('data_upload_tab_data_2'))
    )
  )
)
####




#### SERVER ####
core.data_upload <- function(input, output) {
  
  ## INITIALIZE DATA ##
  assign('DBPATH', reactive(file.path('dbs', 'Records.db')), envir = .GlobalEnv)
  
  observe(core.data_upload.act.init_proj_record(DBPATH()))
  observe(core.data_upload.act.init_data_record(DBPATH()))
  observe(core.data_upload.act.init_grp_record(DBPATH()))
  
  ####
  
  assign('PROJ.ID', reactive(
    core.data_upload.act.get_present_proj_id(DBPATH(), input$data_upload_tab_proj_1_rows_selected)
  ), envir = .GlobalEnv)
  
  assign('DATA.ID', reactive(
    core.data_upload.act.get_present_data_id(DBPATH(), PROJ.ID(), input$data_upload_tab_data_1_rows_selected)
  ), envir = .GlobalEnv)
  
  ####
  
  assign('DATA', reactive(
    core.data_upload.act.import_data.h5ad(DBPATH(), PROJ.ID(), DATA.ID())
  ), envir = .GlobalEnv)
  
  observe(DATA())
  
  
  
  
  ## INITIALIZE DYNAMIC UI ##
  output$data_upload_ctl_data_1 <- renderUI(
    core.data_upload.ctl.file_importing('data_upload_ctl_data_1', 'Upload', c('.h5', '.txt', '.tsv', '.csv', '.gz'), 
                                        'Support 10X HDF5, tsv or csv Matrix',
                                        PROJ.ID())
  )
  
  
  
  output$data_upload_ctl_data_attr_1 <- renderUI(
    core.data_upload.ctl.attr_input('data_upload_ctl_data_attr_1', 'Sample Name', 'Required',
                                    PROJ.ID())
  )
  
  output$data_upload_ctl_data_attr_2 <- renderUI(
    core.data_upload.ctl.attr_picker('data_upload_ctl_data_attr_2', 'Species', 'species',
                                     PROJ.ID())
  )
  
  output$data_upload_ctl_data_attr_3 <- renderUI(
    core.data_upload.ctl.attr_picker('data_upload_ctl_data_attr_3', 'Group Info.', 'groups',
                                     PROJ.ID())
  )
  
  # output$data_upload_ctl_data_attr_4 <- renderUI(
  #   core.data_upload.ctl.attr_picker('data_upload_ctl_data_attr_4', 'Library Platform', 'lib_pltf',
  #                                    PROJ.ID())
  # )
  # 
  # output$data_upload_ctl_data_attr_5 <- renderUI(
  #   core.data_upload.ctl.attr_picker('data_upload_ctl_data_attr_5', 'Library Type', 'lib_type',
  #                                    PROJ.ID())
  # )
  # 
  # output$data_upload_ctl_data_attr_6 <- renderUI(
  #   core.data_upload.ctl.attr_picker('data_upload_ctl_data_attr_6', 'Sequencing Platform', 'sep_pltf',
  #                                    PROJ.ID())
  # )
  
  output$data_upload_ctl_data_attr_7 <- renderUI(
    core.data_upload.ctl.attr_chooser('data_upload_ctl_data_attr_7', 'Need Find Doublet?',
                                      c('Yes', 'No'), 'No',
                                      PROJ.ID())
  )
  
  output$data_upload_ctl_data_2 <- renderUI(
    core.data_upload.ctl.action('data_upload_ctl_data_2', 'Import Data', 'file-import', 
                                PROJ.ID())
  )
  
  output$data_upload_ctl_data_3 <- renderUI(
    core.data_upload.ctl.action('data_upload_ctl_data_3', 'Del Data', 'trash-alt', 
                                PROJ.ID())
  )
  
  observeEvent(c(input$data_upload_ctl_data_2,
                 input$data_upload_ctl_data_3,
                 input$data_upload_ctl_data_5), {
                   
    output$data_upload_ctl_data_4 <- renderUI(
      core.data_upload.ctl.integration.selection('data_upload_ctl_data_4',
                                                 'Samples for Batch Effect Removal',
                                                 DBPATH(),
                                                 PROJ.ID(),
                                                 PROJ.ID())
    )
    
  })
  
  output$data_upload_ctl_data_inMethod <- renderUI(
    core.data_upload.ctl.attr_picker('data_upload_ctl_data_inMethod', 'Available Methods', 'inMethod',
                                     PROJ.ID())
  )
  
  output$data_upload_ctl_data_5 <- renderUI(
    core.data_upload.ctl.integration.action('data_upload_ctl_data_5',
                                            'EXEC',
                                            'puzzle-piece',
                                            PROJ.ID())
  )
  
    
  output$data_upload_ctl_data_downloadSlot <- renderUI(
    core.data_upload.ctl.downloadSlot('data_upload_ctl_data_download', DATA.ID())
  )
  
  
  
  
  ## ACTIVITY ##
  observeEvent(input$data_upload_ctl_proj_1, {
    
    core.data_upload.act.generate_empty_proj(DBPATH(), input$data_upload_ctl_proj_attr_1)
    
  })
  
  observeEvent(input$data_upload_ctl_proj_2, {
    
    core.data_upload.act.remove_proj(DBPATH(), PROJ.ID())
    
  })
  
  observeEvent(input$data_upload_ctl_data_2, {
    
    data_attr <- c(input$data_upload_ctl_data_attr_1,
                   input$data_upload_ctl_data_attr_2,
                   input$data_upload_ctl_data_attr_3,
                   '-NA-',
                   '-NA-',
                   '-NA-',
                   input$data_upload_ctl_data_attr_7)
    
    # core.data_upload.act.generate_sc_data(DBPATH(), PROJ.ID(),
    #                                       input$data_upload_ctl_data_1$datapath,
    #                                       data_attr)
    withProgress({
      
      setProgress(0.3, message = 'Running')
      
      system(paste('nextflow run mod/core/data_upload/act/nf/generate_sc_data.nf',
                   '--dbpath', DBPATH(),
                   '--proj_id', PROJ.ID(),
                   '--file_path', input$data_upload_ctl_data_1$datapath,
                   '--ctls', paste0('\"', paste(data_attr, collapse = ','), '\"')))
      
      setProgress(1.0, message = 'Finished')
      
    })
    
  })
  
  observeEvent(input$data_upload_ctl_data_3, {
    
    core.data_upload.act.remove_data(DBPATH(), PROJ.ID(), DATA.ID())
    
  })
  
  observeEvent(input$data_upload_ctl_data_5, {

    # core.data_upload.act.integrate_data(DBPATH(), PROJ.ID(), input$data_upload_ctl_data_4)
    withProgress({
      
      setProgress(0.3, message = 'Running')
      
      if (input$data_upload_ctl_data_inMethod == 'RPCA')
        system(paste('nextflow run mod/core/data_upload/act/nf/integrate_data.rpca.nf',
                     '--dbpath', DBPATH(),
                     '--proj_id', PROJ.ID(),
                     '--data_ids', paste0('\"', paste(input$data_upload_ctl_data_4, collapse = ','), '\"')))
      
      if (input$data_upload_ctl_data_inMethod == 'FastMNN')
        system(paste('nextflow run mod/core/data_upload/act/nf/integrate_data.fastmnn.nf',
                     '--dbpath', DBPATH(),
                     '--proj_id', PROJ.ID(),
                     '--data_ids', paste0('\"', paste(input$data_upload_ctl_data_4, collapse = ','), '\"')))
      
      if (input$data_upload_ctl_data_inMethod == 'Harmony')
        system(paste('nextflow run mod/core/data_upload/act/nf/integrate_data.harmony.nf',
                     '--dbpath', DBPATH(),
                     '--proj_id', PROJ.ID(),
                     '--data_ids', paste0('\"', paste(input$data_upload_ctl_data_4, collapse = ','), '\"')))
      
      if (input$data_upload_ctl_data_inMethod == 'scVI')
        system(paste('nextflow run mod/core/data_upload/act/nf/integrate_data.scvi.nf',
                     '--dbpath', DBPATH(),
                     '--proj_id', PROJ.ID(),
                     '--data_ids', paste0('\"', paste(input$data_upload_ctl_data_4, collapse = ','), '\"')))
      
      if (input$data_upload_ctl_data_inMethod == 'scANVI')
        system(paste('nextflow run mod/core/data_upload/act/nf/integrate_data.scanvi.nf',
                     '--dbpath', DBPATH(),
                     '--proj_id', PROJ.ID(),
                     '--data_ids', paste0('\"', paste(input$data_upload_ctl_data_4, collapse = ','), '\"')))
      
      setProgress(1.0, message = 'Finished')
      
    })

  })
  
  observeEvent(DATA.ID(), {
    
    output$data_upload_ctl_data_download <- core.data_upload.act.get_data(PROJ.ID(), DATA.ID())
    
  })
  
  
  ## TABLE ##
  observeEvent(c(input$data_upload_ctl_proj_1,
                 input$data_upload_ctl_proj_2), {
    
    output$data_upload_tab_proj_1 <- renderDT(
      core.data_upload.tab.proj_records(DBPATH())
    )

  })
  
  observeEvent(c(input$data_upload_ctl_data_2,
                 input$data_upload_ctl_data_3,
                 input$data_upload_ctl_data_5), {
    
    output$data_upload_tab_data_1 <- renderDT(
      core.data_upload.tab.data_records(DBPATH(),
                                        PROJ.ID(),
                                        PROJ.ID())
    )
    
  })
  
  output$data_upload_tab_data_2 <- renderDT(
    core.data_upload.tab.data_records_detail(DBPATH(), DATA.ID(),
                                             DATA.ID())
  )
  
  
  
  
  ## PLOT ##
}