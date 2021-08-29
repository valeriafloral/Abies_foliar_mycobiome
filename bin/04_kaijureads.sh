#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#31/05/2021
#Assign taxonomy to reads using Kaiju


#Run kaiju classification
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kaiju -t ../../programas/kaiju_db/nodes.dmp -f ../../programas/kaiju_db/fungi/kaiju_db_fungi.fmi -i ../data/filter/nonhost/${f}_p_filtered.fastq -z 4 -o ../data/reports/kaiju/${f}_paired_kaiju.out;
kaiju -t ../../programas/kaiju_db/nodes.dmp -f ../../programas/kaiju_db/fungi/kaiju_db_fungi.fmi -i ../data/filter/nonhost/${f}_R1_filtered.fastq -z 4 -o ../data/reports/kaiju/${f}_R1_unpaired_kaiju.out;
kaiju -t ../../programas/kaiju_db/nodes.dmp -f ../../programas/kaiju_db/fungi/kaiju_db_fungi.fmi -i ../data/filter/nonhost/${f}_R2_filtered.fastq -z 4 -o ../data/reports/kaiju/${f}_R2_unpaired_kaiju.out;
kaiju -t ../../programas/kaiju_db/nodes.dmp -f ../../programas/kaiju_db/fungi/kaiju_db_fungi.fmi -i ../data/filter/nonhost/${f}_cat.fastq -z 4 -o ../data/reports/kaiju/${f}_kaiju_cat.out;
done


#Kaiju2table
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kaiju2table -t ../../programas/kaiju_db/nodes.dmp -n ../../programas/kaiju_db/names.dmp -r species -o ../data/reports/kaiju/${f}_paired_kaiju.tsv ../data/reports/kaiju/${f}_paired_kaiju.out -l superkingdom,phylum,class,order,family,genus,species;
kaiju2table -t ../../programas/kaiju_db/nodes.dmp -n ../../programas/kaiju_db/names.dmp -r species -o ../data/reports/kaiju/${f}_R1_kaiju.tsv ../data/reports/kaiju/${f}_R1_unpaired_kaiju.out -l superkingdom,phylum,class,order,family,genus,species;
kaiju2table -t ../../programas/kaiju_db/nodes.dmp -n ../../programas/kaiju_db/names.dmp -r species -o ../data/reports/kaiju/${f}_R2_kaiju.tsv ../data/reports/kaiju/${f}_R2_unpaired_kaiju.out -l superkingdom,phylum,class,order,family,genus,species;
kaiju2table -t ../../programas/kaiju_db/nodes.dmp -n ../../programas/kaiju_db/names.dmp -r species -o ../data/reports/kaiju/${f}_R2_kaiju.tsv ../data/reports/kaiju/${f}_kaiju_cat.out -l superkingdom,phylum,class,order,family,genus,species;
done

# Concatenate the input
for i in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do cat ../data/reports/kaiju/${i}_paired_kaiju.out ../data/reports/kaiju/${i}_R1_unpaired_kaiju.out ../data/reports/kaiju/${i}_R2_unpaired_kaiju.out > ../data/reports/kaiju/${i}_cat_kaiju.out;
cat ../data/reports/kaiju/${i}_paired_kaiju.tsv ../data/reports/kaiju/${i}_R1_kaiju.tsv ../data/reports/kaiju/${i}_R2_kaiju.tsv > ../data/reports/kaiju/${i}_cat_kaiju.tsv;
done
