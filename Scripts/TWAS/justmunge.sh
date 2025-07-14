#!/bin/bash



#SBATCH --account=lackgrp

#SBATCH --job-name="Genomic_Structural_Equation_Modeling"

#SBATCH --partition=small

#SBATCH --nodes=1

#SBATCH --ntasks-per-node=1

#SBATCH --cpus-per-task=2

#SBATCH --mem=16G

#SBATCH --time=01-00:00:00

#SBATCH --output="SLURM-Genomic_Structural_Equation_Modeling-%j.o"

#SBATCH --error="SLURM-Genomic_Structural_Equation_Modeling-%j.e"

#SBATCH --mail-type=BEGIN,END,FAIL

#SBATCH --mail-user=lawrcm22@wfu.edu



WORKDIR="/deac/bio/lackGrp/lawrcm22/"



module load apps/r/4.3.3




mkdir -p /deac/bio/lackGrp/lawrcm22/R



Rscript - <<EOF

.libPaths(c("/deac/bio/lackGrp/lawrcm22/R/", .libPaths()))

library(data.table)

library(devtools)

require(GenomicSEM)



munge(c("/deac/bio/lackGrp/lawrcm22/TWAS/sumstats/MDD.txt", "/deac/bio/lackGrp/lawrcm22/TWAS/sumstats/ADHD.txt", "/deac/bio/lackGrp/lawrcm22/TWAS/sumstats/BPD.txt"),hm3 = "$WORKDIR/GenomeSEM/snpslist/w_hm3.snplist", trait.names = c("MDD", "ADHD", "BPD"), info.filter = 0.9, maf.filter = 0.01)
