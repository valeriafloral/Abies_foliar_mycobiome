#!/bin/sh

#Valeria Flores
#FastQC

#Raw data fastQC analysis
for f in ../../data/raw/*.fastq.gz;
do fastqc --outdir=../metadata/reports/fastqc;
done

#Trimming with Trimmomatic-0.39
for f in $ DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR17_S195 DPVR18_S196;
do trimmomatic PE -threads 4 -phred33 ../data/raw/${f}_L007_R1_001.fastq.gz ../data/raw/${f}_L007_R2_001.fastq.gz ../data/filter/outputs/${f}_L007_R1_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R1_001_unpaired.fq.gz ../data/filter/outputs/${f}_L007_R2_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R2_001_unpaired.fq.gz;
ILLUMINACLIP:../data/filter/adapters/TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:10:28 LEADING:28 TRAILING:28 MINLEN:50 HEADCROP:13;
done

#Trimmed data quality with fastQC
for f in ../../data/filter/outputs/*.fastq.gz;
do fastqc --outdir=../metadata/fastqc;
done
