#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#25/01/2020
#Quality analysis and Trimming with FastQC, multiQC and Trimmomatic



#R1_paired trimmed data quality with fastQC
for f in ../data/filter/outputs/*R1_001_paired.fq.gz;
do fastqc $f --outdir=../data/reports/trimmed/R1_paired;
done

#R2_paired trimmed data quality with fastQC
for f in ../data/filter/outputs/*R2_001_paired.fq.gz;
do fastqc $f --outdir=../data/reports/trimmed/R2_paired;
done

#R1_unpaired trimmed data quality with fastQC
for f in ../data/filter/outputs/*R1_001_unpaired.fq.gz;
do fastqc $f --outdir=../data/reports/trimmed/R1_unpaired;
done

#R2_unpaired trimmed data quality with fastQC
for f in ../data/filter/outputs/*R2_001_unpaired.fq.gz;
do fastqc $f --outdir=../data/reports/trimmed/R2_unpaired;
done
