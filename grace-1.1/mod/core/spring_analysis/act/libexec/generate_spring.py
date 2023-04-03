import sys
from pandas import read_table, read_csv
from preprocessing_python import *


print 'Loading expression matrix'
E         = np.load('E.npy')
gene_list = read_csv('gene_list', sep='\t', header=None)[0].to_list()
metadata  = read_csv('metadata', index_col=0)

min_nCount   = int(sys.argv[1])
min_gene_exp = float(sys.argv[2])
fano_factor  = int(sys.argv[3])
PCA_dim      = int(sys.argv[4])
k            = int(sys.argv[5])
coarse_grain = int(sys.argv[6])


print 'Filtering cells'
E, cell_filter = filter_cells(E, min_nCount)


print 'Row-normalizing'
E = row_normalize(E)


print 'Filtering genes'
E, gene_filter = filter_genes(E, min_gene_exp, fano_factor)


print 'Zscoring and PCA'
Epca = get_PCA(Zscore(E), PCA_dim)


print 'Getting distance matrix'
D = get_distance_matrix(Epca)


gene_list = np.asarray(gene_list)[gene_filter].tolist()


cell_groupings = {'main':         metadata.loc[cell_filter]['clusters.ann.SingleR.main'].to_list()   if 'clusters.ann.SingleR.main'   in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0],
                  'fine':         metadata.loc[cell_filter]['clusters.ann.SingleR.fine'].to_list()   if 'clusters.ann.SingleR.fine'   in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0],
                  'manual':       metadata.loc[cell_filter]['clusters.ann.SingleR.manual'].to_list() if 'clusters.ann.SingleR.manual' in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0],
                  'clusters 0.2': metadata.loc[cell_filter]['clusters.0.2'].to_list()                if 'clusters.0.2'                in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0],
                  'clusters 0.5': metadata.loc[cell_filter]['clusters.0.5'].to_list()                if 'clusters.0.5'                in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0],
                  'clusters 0.8': metadata.loc[cell_filter]['clusters.0.8'].to_list()                if 'clusters.0.8'                in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0],
                  'clusters 1.2': metadata.loc[cell_filter]['clusters.1.2'].to_list()                if 'clusters.1.2'                in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0],
                  'state':        metadata.loc[cell_filter]['State'].to_list()                       if 'State'                       in metadata.loc[cell_filter] else ['unknown'] * metadata.loc[cell_filter].shape[0]}
                      
                  
if 'Pseudotime' in metadata:
    custom_colors = {'monocle2-time': metadata.loc[cell_filter]['Pseudotime'].to_list()}
                     
else:
    custom_colors = {'monocle2-time': [1] * metadata.loc[cell_filter].shape[0]}


print 'Saving SPRING plot'
save_spring_dir(E, D, k, gene_list, '.', cell_groupings=cell_groupings, custom_colors=custom_colors, coarse_grain_X=coarse_grain)
