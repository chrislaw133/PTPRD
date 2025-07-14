import scanpy as sc
from scipy import io

adata = sc.read_h5ad('/path/to/RNA.E.MATRIX.h5ad') 

with open('/path/to/RNA.E.MATRIX.barcodes.tsv', 'w') as f:
    for item in adata.obs_names:
        f.write(item + '\n')
        
print('Barcodes file processing complete')

with open('/path/to/RNA.E.MATRIX.features.tsv', 'w') as f:
    for item in ['\t'.join([x,x,'Gene Expression']) for x in adata.var_names]:
        f.write(item + '\n')

print('Features file processing complete!')
        
io.mmwrite('/path/to/output_dir/matrix', adata.X.T)
print('.mtx file processing complete!')
