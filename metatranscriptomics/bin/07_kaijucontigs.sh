#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#31/05/2021
#Assign taxonomy to assembled contigs using kaiju

#Run kaiju _paired_classification
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kaiju -t ../../programas/kaiju_db/nodes.dmp -f ../../programas/kaiju_db/fungi/kaiju_db_fungi.fmi -i ../data/assembly/${f}_assembly/transcripts.fasta -z 4 -o ../data/reports/kaiju/${f}_contigs_kaiju.out;
done

#Kaiju2table
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kaiju2table -t ../../programas/kaiju_db/nodes.dmp -n ../../programas/kaiju_db/names.dmp -r species -o ../data/reports/kaiju/${f}_contigs_kaiju.tsv ../data/reports/kaiju/${f}_contigs_kaiju.out -l superkingdom,phylum,class,order,family,genus,species;
done
