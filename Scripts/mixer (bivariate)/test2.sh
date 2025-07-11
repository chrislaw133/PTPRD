#!/bin/bash

#Make Filepaths
BFILE="/path/to/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim"
LD_FILE="/path/to/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld"
OUT_DIR="/path/to/test"
TRAIT1_FILE="/path/to/trait1.txt"
TRAIT2_FILE="/path/to/trait2.txt"
PARAMS="/path/to/params/"
REP="${SLURM_ARRAY_TASK_ID}"

#Run mixer

apptainer exec /path/to/mixer.sif python3 /tools/mixer/precimed/mixer.py test2 \
   --trait1-file ${TRAIT1_FILE} \
   --trait2-file ${TRAIT2_FILE} \
   --load-params-file ${PARAMS}/trait1.trait2.fit.rep${REP}.json \
   --bim-file ${BFILE} \
   --ld-file ${LD_FILE} \
   --out ${OUT_DIR}/trait1.trait2.test.rep${REP} \
   --thread 1

echo "Test rep ${SLURM_ARRAY_TASK_ID} processing completed."
