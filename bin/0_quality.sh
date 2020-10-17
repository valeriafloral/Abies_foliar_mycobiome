#!/bin/sh

#Valeria Flores
#FastQC

#Raw data fastQC analysis
for f in ../../data/raw/*.fastq.gz;
do fastqc --outdir=../metadata/fastqc;
done

#Trimming with Trimmomatic-0.38
for f in $(ls *fastq.gz | sed 's/_[1-2].fastq.gz//' | sort -u);
do trimmomatic PE -threads 8 -basein ${f}_1.fastq.gz -baseout ../data/trimmed/${f}.fastq.gz ILLUMINACLIP:/../metadata/adapters/TruSeq3-PE-2.fa:2:30:10 SLIDINGWINDOW:10:28 LEADING:28 TRAILING:28 MINLEN:50 HEADCROP:13;
done

#Trimmed data quality with fastQC
for f in ../../data/trimmed/*.fastq.gz;
do fastqc --outdir=../metadata/fastqc;
done
