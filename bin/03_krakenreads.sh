#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#23/04/2021
#Assign taxonomy to reads using Krakenuniq

#Assign taxonomy to reads using Krakenuniq for paired, r1. r2 and concatenated files
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/filter/nonhost/${f}_p_filtered.fastq --threads 12 --hll-precision 18 --exact --report-file ../data/reports/kraken/reads/${f}_kr_paired.report --output ../data/reports/kraken/reads/${f}_kr_paired.kraken --only-classified-output;
krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/filter/nonhost/${f}_R1_filtered.fastq --threads 12 --hll-precision 18 --exact --report-file ../data/reports/kraken/reads/${f}_kr_R1.report --output ../data/reports/kraken/reads/${f}_kr_R1.kraken --only-classified-output;
krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/filter/nonhost/${f}_R2_filtered.fastq --threads 12 --hll-precision 18 --exact --report-file ../data/reports/kraken/reads/${f}_kr_R2.report --output ../data/reports/kraken/reads/${f}_kr_R2.kraken --only-classified-output;
krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/filter/nonhost/${f}_cat.fastq --threads 12 --hll-precision 18 --exact --report-file ../data/reports/kraken/reads/${f}_kr_cat.report --output ../data/reports/kraken/reads/${f}_kr_cat.kraken --only-classified-output;
done
