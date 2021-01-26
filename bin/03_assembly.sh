#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#12/01/2020
#Assembly with metaSPADEs
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do spades.py --rna --meta --12 ../data/filter/outputs/${f}_paired_bulk.fastq --s1 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq --s2 ../data/filter/outputs/${f}_R2_unpaired_bulk.fastq -k 21,33,55,77,99,111,127 -o ../data/assembly/${f}_assembly;
done

#Count contigs
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do grep -c '>' ${f}_assembly/contigs.fasta
done

#move contigs to reports or save contigs directly in reports (?) ../data/reports/Assembly/
###Work in progess
