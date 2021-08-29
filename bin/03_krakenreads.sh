#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#23/04/2021
#Assign taxonomy to reads using Kraken2

#Assign taxonomy to reads using Kraken2 for paired, r1. r2 and concatenated files
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kraken2 --db fungi --fastq-input ../data/filter/nonhost/${f}_p_filtered.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_paired.report --output ../data/reports/kraken2/${f}_k2_reads_paired.kraken;
kraken2 --db fungi --fastq-input ../data/filter/nonhost/${f}_R1_filtered.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_R1.report --output ../data/reports/kraken2/${f}_k2_reads_R1.kraken;
kraken2 --db fungi --fastq-input ../data/filter/nonhost/${f}_R2_filtered.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_R2.report  --output ../data/reports/kraken2/${f}_k2_reads_R2.kraken;
kraken2 --db fungi --fastq-input ../data/filter/nonhost/${f}_cat.fastq --threads 12 --report ../data/reports/kraken2/${f}_k2_reads_cat.report  --output ../data/reports/kraken2/${f}_k2_reads_cat.kraken;
done

#Estimate abundance with bracken
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_paired.report -o ../data/reports/kraken2/${f}_k2_reads_paired.bracken -r 100 -l S -t 1;
bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_R1.report -o ../data/reports/kraken2/${f}_k2_reads_R1.bracken -r 100 -l S -t 1;
bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_R2.report -o ../data/reports/kraken2/${f}_k2_reads_R2.bracken  -r 100 -l S -t 1;
bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_cat.report -o ../data/reports/kraken2/${f}_k2_reads_cat.bracken -r 100 -l S -t 1;
done

#Change bracken report to mpa report
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_R1_bracken_species.report -o ../data/reports/kraken2/${f}_k2_R1_bracken.txt --no-intermediate-ranks --read_count;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_R2_bracken_species.report -o ../data/reports/kraken2/${f}_k2_R2_bracken.txt --no-intermediate-ranks --read_count;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_paired_bracken_species.report -o ../data/reports/kraken2/${f}_k2_paired_bracken.txt --no-intermediate-ranks --read_count;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_cat_bracken_species.report -o ../data/reports/kraken2/${f}_k2_cat_bracken.txt --no-intermediate-ranks --read_count;
done

#Combine
combine_mpa.py -i ../data/reports/kraken2/*_k2_contigs_bracken.txt -o ../data/reports/kraken2/combined_sp_contigs_bracken.txt
