#!/bin/bash

REP="${SLURM_ARRAY_TASK_ID}"

apptainer run /path/to/mix3r.sif make_template --bim /path/to/PLINK/chr_1000G/1000G_chr${REP} \
                        --ld /path/to/1000G_linkage_disequillibrium/1000G_chr${REP} \
                        --frq /path/to/Allele_Frequencies/1000G_chr${REP} \
                        --chr ${REP} \
                        --out /path/to/output_dir
