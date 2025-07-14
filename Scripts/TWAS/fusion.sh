#!/bin/bash

#SBATCH --account=lackgrp
#SBATCH --job-name="Genomic_Structural_Equation_Modeling"
#SBATCH --partition=small
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-13
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01-00:00:00
#SBATCH --output="SLURM-Genomic_Structural_Equation_Modeling-%j.o"
#SBATCH --error="SLURM-Genomic_Structural_Equation_Modeling-%j.e"
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=lawrcm22@wfu.edu

module load apps/r/4.3.3

#ls -d */ | sed 's:/$::' > regions.txt

cd /deac/bio/lackGrp/lawrcm22/TWAS

REGION=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /deac/bio/lackGrp/lawrcm22/TWAS/GE_weights/regions.txt)
OUTDIR=/deac/bio/lackGrp/lawrcm22/TWAS/univ_TWAS
WEIGHTS=/deac/bio/lackGrp/lawrcm22/TWAS/GE_weights/${REGION}.pos
WEIGHTS_DIR=/deac/bio/lackGrp/lawrcm22/TWAS/GE_weights
REF_LD_BASE=/deac/bio/lackGrp/lawrcm22/TWAS/LDREF/1000G.EUR.


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