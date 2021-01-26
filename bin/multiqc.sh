#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#25/01/2021
#Group the paired and unpaired quality analysis with multiqc

#Group the R1_paired quality analysis with MultiQC
multiqc ../data/reports/trimmed/R1_paired -o ../data/reports/trimmed/R1_paired

#Group the R2_paired quality analysis with MultiQC
multiqc ../data/reports/trimmed/R2_paired -o ../data/reports/trimmed/R2_paired

#Group the R1_unpaired quality analysis with MultiQC
multiqc ../data/reports/trimmed/R1_unpaired -o ../data/reports/trimmed/R1_unpaired

#Group the R2_unpaired quality analysis with MultiQC
multiqc ../data/reports/trimmed/R2_unpaired -o ../data/reports/trimmed/R2_unpaired


