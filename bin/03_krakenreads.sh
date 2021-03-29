#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#31/01/2021
#Assign taxonomy to reads using Kraken2

#Use concatenated files
#Make the classification
for i in tolerant damaged;
do krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/filter/bulk/${i}.fastq --threads 12 --report-file ../data/reports/kraken${i}.tsv;
done
