import scanpy as sc
import pandas as pd

h5ad_file = '/path/to/RNA.E.MATRIX.h5ad'
csv_file = '/path/to/magmasiggenes.csv' #Format of csv is the default MAGMA output
output_file = '/path/to/output_dir/RNA.E.MATRIX_siggenes.h5ad'

adata = sc.read_h5ad(h5ad_file)
print(f'Original dataset has {adata.n_vars} genes and {adata.n_obs} cells.')

siggenes = pd.read_csv(csv_file)
gene_list = siggenes['GENE'].dropna().astype(str).str.strip().str.lower().tolist()

adata.var_names = adata.var_names.str.strip().str.lower()

matched_genes = adata.var_names.intersection(gene_list)
print(f'Found {len(matched_genes)} matching genes out of {len(gene_list)} in the dataset.')

adata = adata[:, adata.var_names.isin(gene_list)]

# Save the filtered h5ad file
adata.write_h5ad(output_file)

print(f'Filtered h5ad file saved with {adata.n_vars} genes.')
