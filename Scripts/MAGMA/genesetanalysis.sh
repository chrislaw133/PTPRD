#!/bin/bash

WORKDIR=""

Data_File="$WORKDIR/path/to/genes.raw"
Annot_File="$WORKDIR/AUX/C5.annot"
Output_Prefix=""

cd /deac/bio/lackGrp/lawrcm22/MAGMA/
./magma \
 --gene-results $Data_File \
 --set-annot $Annot_File \
 --out $WORKDIR/$Output_Prefix
