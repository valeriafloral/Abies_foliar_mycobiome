#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#23/04/2021
#Assign taxonomy to reads using Krakenuniq

#Assign taxonomy to reads using Krakenuniq and generate outputs analyse diversity and abundance
for f in `ls ../data/taxonomy | grep ".fastq" | sed "s/.fastq//" | uniq`;
do krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/taxonomy/${f}.fastq --threads 12 --hll-precision 18 --report-file ../data/reports/kraken/reads/${f}_kraken_reads.report --output ../data/reports/kraken/reads/${f}_kraken_reads.kraken;
done
