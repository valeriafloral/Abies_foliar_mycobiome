#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#12/01/2020
#Test with trimmomatic


#Trimming with Trimmomatic-0.39
for f in `ls ../data/RAW/ | grep '^D.*z$' | sed "s/_L007_R1_001.fastq.gz//"| sed "s/_L007_R2_001.fastq.gz//" | uniq`;
do trimmomatic PE -threads 4 -phred33 \
../data/RAW/${f}_L007_R1_001.fastq.gz ../data/RAW/${f}_L007_R2_001.fastq.gz \
../data/filter/outputs/${f}_L007_R1_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R1_001_unpaired.fq.gz \
../data/filter/outputs/${f}_L007_R2_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R2_001_unpaired.fq.gz \
ILLUMINACLIP:../data/filter/adapters/TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:10:28 LEADING:28 TRAILING:28 MINLEN:50 HEADCROP:13;
done > ../../data/reports/Trimmomatic.txt

#Trimmed data fastQC analysis
for f in ../data/filter/outputs/DP*.fastq.gz;
do fastqc $f --outdir=../data/reports/trimmomatic;
done


#Group the quality analysis with MultiQC
multiqc ../data/reports/trimmomatic
