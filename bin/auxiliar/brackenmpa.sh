#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#11/06/2021
#Determine species abundance for Kraken2 classification ussing Bracken

#Run bracken for every type of reads
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_R1.report -o ../data/reports/kraken2/${f}_k2_reads_R1.bracken -r 100 -l S -t 1;
bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_R2.report -o ../data/reports/kraken2/${f}_k2_reads_R2.bracken -r 100 -l S -t 1;
bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_cat.report -o ../data/reports/kraken2/${f}_k2_reads_cat.bracken -r 100 -l S -t 1;
bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_reads_paired.report -o ../data/reports/kraken2/${f}_k2_reads_paired.bracken -r 100 -l S -t 1;
done


#Change bracken report to mpa report
#Change bracken report to mpa report
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_R1_bracken_species.report -o ../data/reports/kraken2/${f}_k2_R1_bracken.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_R2_bracken_species.report -o ../data/reports/kraken2/${f}_k2_R2_bracken.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_paired_bracken_species.report -o ../data/reports/kraken2/${f}_k2_paired_bracken.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_cat_bracken_species.report -o ../data/reports/kraken2/${f}_k2_cat_bracken.txt --no-intermediate-ranks --read_count --display-header;
done

#Estimate abundance with bracken
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/${f}_k2_contigs.report -o ../data/reports/kraken2/${f}_k2_contigs.bracken -r 100 -l S -t 1;
done

#Make a mpa report style to easier export it to R
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_contigs_bracken_species.report -o ../data/reports/kraken2/${f}_k2_contigs_bracken.txt --no-intermediate-ranks --read_count;
done
