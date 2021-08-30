#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#27/04/2021
#Concatenate reads to use it with Kraken2
#Concatenate paired, R1 and R2 unpaired for each sample

for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| uniq`;
do cat ../data/filter/nonhost/${f}_p_filtered.fastq ../data/filter/nonhost/${f}_R1_filtered.fastq ../data/filter/nonhost/${f}_R2_filtered.fastq > ../data/filter/nonhost/${f}_cat.fastq;
done
