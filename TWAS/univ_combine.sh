#!/bin/bash

set -euo pipefail

# where your per-chr .dat files live
INDIR=/path/to/univ_TWAS

# where you want to put the combined .allchr.dat files
COMBDIR=/path/to/univ_combined_TWAS
mkdir -p "$COMBDIR"

# list of regions (one per line, matching the prefix in your filenames)
REGIONS=/path/to/regions.txt

# for each region…
while read -r REGION; do
  # find all phenotype cores by looking at the chr 1 files
  for f in "${INDIR}"/${REGION}.*.1.dat; do
    [[ -e "$f" ]] || continue

    # strip off directory + region. and .1.dat to get the phenotype core
    CORE=$(basename "$f")
    CORE=${CORE#${REGION}.}    # remove leading "<REGION>."
    CORE=${CORE%.1.dat}        # remove trailing ".1.dat"

    COMBINED=${COMBDIR}/${REGION}.${CORE}.allchr.dat
    echo "→ Combining ${REGION}.${CORE} into $(basename "$COMBINED")"

    # header from chr 1
    head -n1 "${INDIR}/${REGION}.${CORE}.1.dat" > "$COMBINED"

    # then append data rows from chr 1…22 (skip their headers)
    for chr in {1..22}; do
      DAT="${INDIR}/${REGION}.${CORE}.${chr}.dat"
      if [[ -f "$DAT" ]]; then
        tail -n +2 "$DAT" >> "$COMBINED"
      else
        echo "   WARNING: missing $DAT" >&2
      fi
    done
  done
done < "$REGIONS"
