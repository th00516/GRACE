core.data_filtering.act.select_gene_using_model <- function(obj, classifier, group) {
  
  if (is.null(group)) return(NULL)
  
  
  if (nrow(group) == 0) return(NULL)
  
  
  X <- obj@assays$RNA@data
  y <- read.table(group)
  
  if (ncol(g) == 2) y <- y$V2
  
  
  if (classifier == 'LinearSVC') {
    
    sks  <- import('sklearn.svm')
    
    clf <- sks$LinearSVC(C = 0.01, penalty = 'l1', dual = F)$fit(X, y)
    
  }
  
  if (classifier == 'ExtraTreesClassifier') {
    
    ske  <- import('sklearn.ensemble')
    
    clf <- ske$ExtraTreesClassifier(n_estimators = 50)$fit(X, y)
    
  }
  
  
  skf <- import('sklearn.feature_selection')
  
  model          <- skf$SelectFromModel(clf, prefit = T)
  selected_genes <- model$get_feature_names_out(input_features = rownames(obj))
  
  
  return(selected_genes)
  
}