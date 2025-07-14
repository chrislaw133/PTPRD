#!/bin/bash

#SBATCH --account=lackgrp
#SBATCH --job-name="Genomic_Structural_Equation_Modeling"
#SBATCH --partition=small
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01-00:00:00
#SBATCH --output="SLURM-Genomic_Structural_Equation_Modeling-%j.o"
#SBATCH --error="SLURM-Genomic_Structural_Equation_Modeling-%j.e"
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=lawrcm22@wfu.edu

module load apps/r/4.3.3

Rscript - <<EOF
.libPaths(c("/deac/bio/lackGrp/lawrcm22/R/", .libPaths()))

require(GenomicSEM)
library(data.table)
library(devtools)

ld <- "/deac/bio/lackGrp/lawrcm22/GenomeSEM/eur_w_ld_chr/"
wld <- "/deac/bio/lackGrp/lawrcm22/GenomeSEM/eur_w_ld_chr/"
traits <- c("/deac/bio/lackGrp/lawrcm22/TWAS/munged_sumstats/ADHD.sumstats.gz", "/deac/bio/lackGrp/lawrcm22/TWAS/munged_sumstats/BPD.sumstats.gz", "/deac/bio/lackGrp/lawrcm22/TWAS/munged_sumstats/MDD.sumstats.gz" )
sample.prev <- c(0.20708, 0.07055, 0.20608)
population.prev <- c(0.028, 0.018, 0.064)
trait.names<-c("ADHD", "BPD", "MDD")
gfactor_LDSCoutput <- ldsc(traits, sample.prev, population.prev, ld, wld,trait.names=trait.names)

##optional command to save the ldsc output in case you want to use it in a later R session. 
save(gfactor_LDSCoutput, file="/deac/bio/lackGrp/lawrcm22/TWAS/munged_sumstats/gfactor_LDSC.RData")