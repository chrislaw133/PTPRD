#!/bin/bash

#VCF should only contain SNPs in loci of interest
./plink2 --vcf /path/to/1000G_genotype/vcf \
        --r-unphased square zs \
        --threads 1 \
        --out /path/to/output_dir
