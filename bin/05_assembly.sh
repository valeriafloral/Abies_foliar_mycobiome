#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#03/04/2021

#Before running this script make sure to create a folder for each sample
#Assembly with metaSPADEs
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do spades.py --rna --12 ../data/filter/nonhost/${f}_p_filtered.fastq --s1 ../data/filter/nonhost/${f}_R1_filtered.fastq --s2 ../data/filter/nonhost/${f}_R2_filtered.fastq -t 4 -k 21,33,55,77,99,111,127 -o ../data/assembly/${f}_assembly;
done
