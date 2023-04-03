#### IMPORT FUNC ####
library(shiny)
library(shinyWidgets)
library(plotly)
library(ggplot2)
library(DT)
library(DBI)
# library(knitr)

library(Seurat)
library(DoubletFinder)
library(SingleR)
library(monocle)
library(clusterProfiler)
library(cellcall)
library(CellChat)

library(reticulate)


source('mod/core/data_upload/ini.R')
source('mod/core/data_filtering/ini.R')
source('mod/core/denovo_annotation/ini.R')
source('mod/core/ref_based_annotation/ini.R')
source('mod/core/manual_annotation/ini.R')
source('mod/core/cell_cycle/ini.R')
source('mod/core/exp_analysis/ini.R')
source('mod/core/exp_cor_analysis/ini.R')
source('mod/core/inter_communication/ini.R')
source('mod/core/inter_cellcall/ini.R')
source('mod/core/inter_cellchat/ini.R')
source('mod/core/defined_subcluster/ini.R')
source('mod/core/subcluster_manual_annotation/ini.R')
source('mod/core/ddrtree_analysis/ini.R')
source('mod/core/spring_analysis/ini.R')
source('mod/core/pathway_enrichment/ini.R')
source('mod/core/intra_communication/ini.R')
source('mod/core/intra_cellcall/ini.R')
source('mod/core/intra_cellchat/ini.R')

source('mod/core/help/ini.R')


#### insert your ui set here ####

####
########




#### SET UI ####
func.UI <- tabsetPanel(
  id = 'navigation',
  
  tabPanel('Data Upload', br(), core.data_upload.UI),
  
  tabPanel('Cell Filtering', br(), core.data_filtering.UI),
  
  tabPanel('Cell Annotation & Gene Expression', br(), tabsetPanel(
    tabPanel('Reference-based Annotation', br(), core.denovo_annotation.UI),
    tabPanel('Atlas-based Annotation', br(), core.ref_based_annotation.UI),
    tabPanel('Manual Annotation', br(), core.manual_annotation.UI),
    tabPanel('Expression Analysis', br(), core.exp_analysis.UI),
    tabPanel('Expression Correlation', br(), core.exp_cor_analysis.UI),
    tabPanel('Cell Cycle', br(), core.cell_cycle.UI)
  )),
  
  tabPanel('Inter-type Communication', br(), tabsetPanel(
    tabPanel('CellphoneDB', br(), core.inter_communication.UI),
    tabPanel('CellCall',    br(), core.inter_cellcall.UI),
    tabPanel('CellChat',    br(), core.inter_cellchat.UI)
  )),
  
  tabPanel('Subclustering Analysis', br(), tabsetPanel(
    tabPanel('Defined Subcluster', br(), core.defined_subcluster.UI),
    tabPanel('Subcluster Manual Annotation', br(), core.subcluster_manual_annotation.UI),
    tabPanel('Developmental Trajectory', br(), tabsetPanel(
      tabPanel('Pseudotime Layout', br(), core.ddrtree_analysis.UI),
      tabPanel('Force-directed Layout', br(), core.spring_analysis.UI)
    )),
    tabPanel('Pathway Enrichment', br(), core.pathway_enrichment.UI),
    tabPanel('Intra-type Communication', br(), tabsetPanel(
      tabPanel('CellphoneDB', br(), core.intra_communication.UI),
      tabPanel('CellCall',    br(), core.intra_cellcall.UI),
      tabPanel('CellChat',    br(), core.intra_cellchat.UI)
    ))
  )),
  
  tabPanel('Help', br(), core.help.UI)
  
  
  #### insert your ui set here ####
  # tabPanel('Third-party Modules', tabsetPanel(
  #   tabPanel('Demo Module', site.demo_module.UI)
  # ))
  ####
)
########




#### SET DATA & FUNC ####
func <- function(input, output) {
  
  core.data_upload(input, output)
  core.data_filtering(input, output)
  core.denovo_annotation(input, output)
  core.ref_based_annotation(input, output)
  core.manual_annotation(input, output)
  core.cell_cycle(input, output)
  core.exp_analysis(input, output)
  core.exp_cor_analysis(input, output)
  core.inter_communication(input, output)
  core.inter_cellcall(input, output)
  core.inter_cellchat(input, output)
  core.defined_subcluster(input, output)
  core.subcluster_manual_annotation(input, output)
  core.ddrtree_analysis(input, output)
  core.spring_analysis(input, output)
  core.pathway_enrichment(input, output)
  core.intra_communication(input, output)
  core.intra_cellcall(input, output)
  core.intra_cellchat(input, output)
  
  core.help(input, output)
  
  
  #### insert your function here ####
  # site.demo_module(input, output)
  ####
  
}
########
