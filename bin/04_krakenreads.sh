#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#Updated: 30/08/2021
#Assign taxonomy to reads using Kraken2-Bracken

#Assign taxonomy to reads using Kraken2 in concatenated files
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kraken2 --db fungi --fastq-input ../data/filter/nonhost/${f}_cat.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_cat.report  --output ../data/reports/kraken2/${f}_k2_reads_cat.kraken;
done

#Estimate abundance with Bracken
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_cat.report -o ../data/reports/kraken2/${f}_k2_reads_cat.bracken -r 100 -l S -t 1;
done

#Change bracken report to mpa report
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_cat_bracken_species.report -o ../data/reports/kraken2/${f}_k2_cat_bracken.txt --no-intermediate-ranks --read_count;
done

#Combine
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do combine_mpa.py -i ../data/reports/kraken2/${f}_k2_cat_bracken.txt -o ../data/reports/kraken2/combined_sp_k2_cat.txt;
done
