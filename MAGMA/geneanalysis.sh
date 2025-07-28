#!/bin/bash

WORKDIR=""

#mkdir temp_annot # make a temporary directory to host the intermediate files
Data_File="$WORKDIR/AUX/g1000_eur"
Annot_File="$WORKDIR/AUX/annotation_file.genes.annot"
SNP_Pval_File="$WORKDIR/sumstats/snp_pval.txt"
Output_Prefix="adult_midbrain"

./magma \
 --bfile $Data_File \
 --gene-annot $Annot_File \
 --gene-model snp-wise=mean \
 --pval $SNP_Pval_File ncol=N \
 --out $WORKDIR/results/$Output_Prefix \

