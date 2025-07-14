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

BASE=/deac/bio/lackGrp/lawrcm22/TWAS/univ_combined_TWAS/
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /deac/bio/lackGrp/lawrcm22/TWAS/GE_weights/regions.txt)
REGION="${BASE}${NAME}"
export REGION
export NAME

Rscript - << 'EOF'
.libPaths(c("/deac/bio/lackGrp/lawrcm22/R/", .libPaths()))

require(GenomicSEM)
library(data.table)
library(devtools)

region <- Sys.getenv("REGION")
name <- Sys.getenv("NAME")


files <- list(
  paste0(region, ".ADHD.allchr.dat"),
  paste0(region, ".BPD.allchr.dat"),
  paste0(region, ".MDD.allchr.dat")
)
trait.names=c("ADHD", "BPD", "MDD")
N=c(128213.795046, 220416.305497, 1309348.46886)
binary=c(F, F, F)
gfactor_genes <- read_fusion(files=files,trait.names=trait.names,N=N,binary=binary)

load("/deac/bio/lackGrp/lawrcm22/TWAS/munged_sumstats/gfactor_LDSC.RData")


gfactor_TSEM <- commonfactorGWAS(covstruc=gfactor_LDSCoutput, SNPs=gfactor_genes, parallel=TRUE, cores=2, TWAS=TRUE, estimation='DWLS')

outfile <- paste0("/deac/bio/lackGrp/lawrcm22/TWAS/results/", name, "_TSEM_results.txt")
fwrite(gfactor_TSEM, outfile, quote=FALSE, sep="\t")
EOF
