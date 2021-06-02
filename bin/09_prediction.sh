#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#02/05/2021
#ORF prediction using prodigal


for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do prodigal -a ../data/prediction/${f}.faa -d ../data/prediction/${f}.ffn -i ../data/assembly/${f}_contigs.fasta -o ../data/prediction/${f}.gbk -p meta -s ../data/prediction/${f}_genes.gff;
done
