#!/bin/bash


# Loop over chromosomes 1 to 22
for chr in {1..22}; do
echo "Running mix3r_int_weights for chromosome $chr..."

apptainer run --nv /path/to/mix3r.sif mix3r_int_weights --config /path/to/config_chr${chr}.json

echo "Chromosome $chr complete."
done
