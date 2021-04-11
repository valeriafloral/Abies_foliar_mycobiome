#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#01/04/2021
#Assign taxonomy to reads using Krakenuniq

#Make a tsv report for every sample
for f in `ls ../data/taxonomy | grep ".fastq" | sed "s/.fastq//" | uniq`;
do krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/taxonomy/${i}.fastq --threads 12 --hll-precision 18 --report-file ../data/reports/kraken/${i}_kraken.tsv;
done
