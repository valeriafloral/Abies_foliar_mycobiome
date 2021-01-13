#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#12/01/2020
#Quality analysis and Trimming with FastQC, multiQC and Trimmomatic


#Raw data fastQC analysis
for f in ../data/RAW/DP*.fastq.gz;
do fastqc $f --outdir=../data/reports/raw;
done


#Group the quality analysis with MultiQC
multiqc ../data/reports/fastqc/raw


