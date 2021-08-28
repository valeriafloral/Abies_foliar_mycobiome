#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#11/06/2021
#Assign taxonomy to contigs using Kraken2

#Assign taxonomy to reads using Krakenuniq for paired, r1. r2 and concatenated files
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kraken2 --db ../../programas/kraken2_db/fungi ../data/assembly/${f}_assembly/transcripts.fasta --threads 12 --report ../data/reports/kraken2/${f}_k2_contigs.report --output ../data/reports/kraken2/${f}_k2_contigs.kraken;
done

