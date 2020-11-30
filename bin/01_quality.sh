#!/bin/sh

#Valeria Flores
#FastQC

#Raw data fastQC analysis
for f in ../../data/raw/*.fastq.gz;
do fastqc --outdir=../metadata/reports/fastqc;
done

#Trimming with Trimmomatic-0.39
for f in $(ls *fastq.gz | sed 's/_[1-2].fastq.gz//' | sort -u);
do trimmomatic PE -threads 8 -basein ../data/raw/${f}_1.fastq.gz -baseout ../data/filter/outputs/${f}.fastq.gz ILLUMINACLIP:/../data/filter/adapters/TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:10:28 LEADING:28 TRAILING:28 MINLEN:50 HEADCROP:13;
done

#Trimmed data quality with fastQC
for f in ../../data/filter/outputs/*.fastq.gz;
do fastqc --outdir=../metadata/fastqc;
done
