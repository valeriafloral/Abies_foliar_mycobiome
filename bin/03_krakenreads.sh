#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#27/01/2021
#Assign taxonomy to reads using Kraken2

#Use concatenated files
#Make the classification
for i in tolerant damaged;
do krakenuniq --db ../../programas/kraken --fastq-input ../data/filter/outpus/${i}test.fastq --threads 12 --report-file ../data/reports/kraken${i}test.tsv > kraken${i}test.tsv;
done

###Work in progress



for i in tolerant damaged;
do echo "../data/filter/outpus/${i}test.fastq";
done
