#!/bin/bash

REGION=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /path/to/regions.txt) #A simple lookup table of the GTEx v8 brain region used in our T-SEM pipeline to store prefixes
OUTDIR=/path/to/univ_outputdir
WEIGHTS=/path/to/weights/${REGION}.pos
WEIGHTS_DIR=/path/to/weights
REF_LD_BASE=/path/to/LDREF/1000G.EUR.


for chr in {1..22}; do
    for phenotype in munged_sumstats/*; do
        file="${phenotype#munged_sumstats/}" 
        core="${file%.sumstats.gz}" 
        Rscript fusion_twas-master/FUSION.assoc_test.R \
        --sumstats $phenotype \
        --weights $WEIGHTS \
        --weights_dir $WEIGHTS_DIR \
        --ref_ld_chr ${REF_LD_BASE} \
        --chr $chr \
        --out ${OUTDIR}/${REGION}.${core}.${chr}.dat
    done
done
