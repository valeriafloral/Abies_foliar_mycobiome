#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#12/01/2021
#Quality analysis and Trimming with FastQC, multiQC and Trimmomatic

#Trimmed data quality with fastQC
for f in ../../data/filter/outputs/*.fastq.gz;
do fastqc $f --outdir=../data/reports/trimmed;
done

#Group the quality analysis with MultiQC
multiqc ../data/reports/trimmed -o ../data/reports/trimmed
