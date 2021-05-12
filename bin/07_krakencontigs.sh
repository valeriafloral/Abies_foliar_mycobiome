#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#11/05/2021
#Assign taxonomy to SPAdes assembled contigs using Krakenuniq

#Assign taxonomy to reads using Krakenuniq for paired, r1. r2 and concatenated files
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do krakenuniq --db ../../programas/krakenuniq_db --fasta-input ../data/assembly/${f}_assembly/transcripts.fasta --threads 12 --hll-precision 18 --exact --report-file ../data/reports/kraken/${f}_k_contigs.report --output ../data/reports/kraken/${f}_k_contigs.kraken --only-classified-output;
done
