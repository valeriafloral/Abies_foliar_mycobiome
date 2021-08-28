#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#23/04/2021
#Assign taxonomy to reads using Kraken2

#Assign taxonomy to reads using Krakenuniq for paired, r1, r2 and concatenated files
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kraken2 --db ../../programas/kraken2_db/fungi/ ../data/filter/nonhost/${f}_p_filtered.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_paired.report --output ../data/reports/kraken2/${f}_k2_reads_paired.kraken;
kraken2 --db ../../programas/kraken2_db/fungi/ ../data/filter/nonhost/${f}_R1_filtered.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_R1.report --output ../data/reports/kraken2/${f}_k2_reads_R1.kraken;
kraken2 --db ../../programas/kraken2_db/fungi/ ../data/filter/nonhost/${f}_R2_filtered.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_R2.report --output ../data/reports/kraken2/${f}_k2_reads_R2.kraken;
kraken2 --db ../../programas/kraken2_db/fungi/ ../data/filter/nonhost/${f}_cat.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_cat.report --output ../data/reports/kraken2/${f}_k2_reads_cat.kraken;
done > ../data/reports/bracken_reads.txt
