#!/bin/sh

#Valeria Flores
#Trimming and fastQC analysis

#Raw data fastQC analysis
fastqc ../../data/raw/mouse1.fastq --outdir=../../metadata/fastqc

#Copy adapters to data folder
cp /Users/valfloral/opt/anaconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/adapters/TruSeq2-SE.fa ../../data/adapters 

#Trimming with Trimmomatic-0.36
trimmomatic SE ../../data/raw/mouse1.fastq ../../data/trimmed/mouse1_trimmed.fastq ILLUMINACLIP:../../data/adpaters/TruSeq3-SE.fa:2:30:10 LEADING:28 TRAILING:28 SLIDINGWINDOW:10:28 MINLEN:50 HEADCROP:13

#Trimmed data fastQC quality analysis
fastqc ../../data/trimmed/mouse1_trimmed.fastq --outdir=../../metadata/fastqc
