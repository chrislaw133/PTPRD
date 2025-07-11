#!/bin/bash

#Make Filepaths
BFILE="/path/to/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim"
LD_FILE="/path/to/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld"
OUT_DIR="/path/to/output_dir"
TRAIT1_FILE="/path/to/trait1.txt"
TRAIT2_FILE="/path/to/trait2.txt"
EXTRACT_DIR="/path/to/snp_output"
REP="${SLURM_ARRAY_TASK_ID}"

#Run mixer

apptainer exec /path/to/mixer.sif python3 /tools/mixer/precimed/mixer.py fit2 \
   --trait1-file ${TRAIT1_FILE} \
   --trait2-file ${TRAIT2_FILE} \
   --trait1-params-file /path/to/fit1/trait1.fit.rep${REP}.json \
   --trait2-params-file /path/to/fit1/trait2.fit.rep${REP}.json \
   --bim-file ${BFILE} \
   --ld-file ${LD_FILE} \
   --out ${OUT_DIR}/trait1.trait2.rep${REP} \
   --extract ${EXTRACT_DIR}/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep${REP}.snps \
   --thread 1

echo "Fit test rep ${SLURM_ARRAY_TASK_ID} processing completed."