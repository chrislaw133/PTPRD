#!/bin/bash

BASE=/path/to/univ_TWAS_allchr/
NAME=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /path/to/regions.txt)
REGION="${BASE}${NAME}"
export REGION
export NAME

Rscript - << 'EOF'
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
gfactor_genes <- read_fusion(files=files, trait.names=trait.names, N=N, binary=binary)

load("/path/to/gfactor_LDSC.RData")


gfactor_TSEM <- commonfactorGWAS(covstruc=gfactor_LDSCoutput, SNPs=gfactor_genes, parallel=TRUE, cores=2, TWAS=TRUE, estimation='DWLS')

outfile <- paste0("/path/to/results_dir/", name, "_TSEM_results.txt")
fwrite(gfactor_TSEM, outfile, quote=FALSE, sep="\t")
EOF
