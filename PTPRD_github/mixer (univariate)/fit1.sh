#!/bin/bash

#Make Filepaths
BFILE="/path/to/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim"
LD_FILE="/path/to/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld"
OUT_DIR="/path/to/output_dir/fit1/"
TRAIT_FILE="/path/to/trait.txt"
EXTRACT_DIR="/path/to/snp_output"
REP="${SLURM_ARRAY_TASK_ID}"

#Run mixer

apptainer exec /path/to/mixer.sif python3 /tools/mixer/precimed/mixer.py fit1 \
   --trait1-file ${TRAIT_FILE} \
   --bim-file ${BFILE} \
   --ld-file ${LD_FILE} \
   --out ${OUT_DIR}/trait.fit.rep${REP} \
   --extract ${EXTRACT_DIR}/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep${REP}.snps \
   --thread 1

echo "Fit test rep ${SLURM_ARRAY_TASK_ID} processing completed."
