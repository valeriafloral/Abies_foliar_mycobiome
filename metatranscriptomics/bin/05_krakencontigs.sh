#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#Updated: 30/08/2021
#Assign taxonomy to assembled contigs using Kraken2-Bracken

#Assign taxonomy to contigs using Kraken2
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kraken2 --db fungi --fasta-input ../data/assembly/${f}_assembly/transcripts.fasta --threads 12 --report ../data/reports/kraken2/${f}_k2_contigs.report --output ../data/reports/kraken2/${f}_k2_contigs.kraken;
done

#Estimate abundance with Bracken
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_contigs.report -o ../data/reports/kraken2/${f}_k2_contigs.bracken -r 100 -l S -t 1;
done

#Make a mpa report style to easier export it to R
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_contigs_bracken_species.report -o ../data/reports/kraken2/${f}_k2_contigs_bracken.txt --no-intermediate-ranks --read_count --display-header;
done

#Combine
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do combine_mpa.py -i ../data/reports/kraken2/${f}_k2_contigs_bracken.txt -o ../data/reports/kraken2/combined_sp_k2_contigs.txt;
done
