#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#23/04/2021

#Make directory for every sample Assembly
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do mkdir ../data/reports/assembly/${f}_assembly;
done

#Assembly with metaSPADEs
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do spades.py --rna -1 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq -2 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq -s1 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq -s2 ../data/filter/outputs/${f}_R2_unpaired_bulk.fastq -t 4 -k 21,33,55,77,99,111,127 -o ../data/reports/assembly/${f}_assembly;
done

#Count contigs
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do grep -c '>' ../data/reports/assembly/${f}_assembly > ../data/reports/assembly/contigs.txt;
done
