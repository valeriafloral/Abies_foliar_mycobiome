#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#12/01/2021
#Quality analysis and Trimming with FastQC, multiQC and Trimmomatic

##1: Quality raw data analysis

#Raw data fastQC analysis
for f in ../data/RAW/DP*.fastq.gz;
do fastqc $f --outdir=../data/reports/raw;
done

#Group the quality analysis with MultiQC
multiqc ../data/reports/fastqc/raw -o ../data/reports/fastqc/raw

##2: Remove low quality sequences and pair reads

#Trimming with Trimmomatic-0.39
for f in `ls ../data/RAW/ | grep '^D.*z$' | sed "s/_L007_R1_001.fastq.gz//"| sed "s/_L007_R2_001.fastq.gz//" | uniq`;
do trimmomatic PE -threads 4 -phred33 \
../data/RAW/${f}_L007_R1_001.fastq.gz ../data/RAW/${f}_L007_R2_001.fastq.gz \
../data/filter/trimmed/${f}_L007_R1_001_paired.fq.gz ../data/filter/trimmed/${f}_L007_R1_001_unpaired.fq.gz \
../data/filter/trimmed/${f}_L007_R2_001_paired.fq.gz ../data/filter/trimmed/${f}_L007_R2_001_unpaired.fq.gz \
ILLUMINACLIP:../data/filter/adapters/TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:10:28 LEADING:28 TRAILING:28 MINLEN:50 HEADCROP:13;
done > ../data/reports/Trimmomatic.txt

##3: Quality trimmed data analysis

#Trimmed data fastQC analysis
for f in `ls ../data/filter/trimmed | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do fastqc ../data/filter/trimmed/${f}_L007_R1_001_paired.fq.gz --outdir=../data/reports/trimmed/R1_paired;
fastqc ../data/filter/trimmed/${f}_L007_R2_001_paired.fq.gz --outdir=../data/reports/trimmed/R1_paired;
fastqc ../data/filter/trimmed/${f}_L007_R1_001_unpaired.fq.gz --outdir=../data/reports/trimmed/R1_unpaired;
fastqc ../data/filter/trimmed/${f}_L007_R2_001_unpaired.fq.gz --outdir=../data/reports/trimmed/R2_unpaired;
done


#Group the trimmed quality analysis with MultiQC
for f in R1_paired R2_paired R1_unpaired R2_unpaired;
do multiqc ../data/reports/trimmed/R1_paired -o ../data/reports/trimmed/${f}_paired;
done
