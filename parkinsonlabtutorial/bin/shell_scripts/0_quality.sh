#!/bin/sh

#Valeria Flores
#fastQC analysis, trimming and impose read quality treshold

#Raw data fastQC analysis
fastqc ../../data/raw/mouse1.fastq --outdir=../../metadata/fastqc

#Trimming with Trimmomatic-0.36
trimmomatic SE ../../data/raw/mouse1.fastq ../../data/trimmed/mouse1_trimmed.fastq ILLUMINACLIP:../../metadata/adapters/TruSeq3-SE.fa:2:30:10 LEADING:28 TRAILING:28 SLIDINGWINDOW:10:28 MINLEN:50 HEADCROP:13 >& ../../data/reports/trimming.log

#Trimmed data fastQC quality analysis
fastqc ../../data/trimmed/mouse1_trimmed.fastq --outdir=../../metadata/fastqc
