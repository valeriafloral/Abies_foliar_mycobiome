#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#27/01/2021
#Assign taxonomy to reads using Kaiju
###Not tested yet

#Database building
#Create a directory in which the database will be host
mkdir ../../programas/kaiju/kaijudb
cd ../../programas/kaiju/kaijudb #See options to specify the output directory

#Make database
kaiju-makedb -s nr_euk

#Run kaijudb
for i in `ls ../data/filter/outputs/bulk | grep ".fastq" | sed "s/_paired_bulk.fastq//"| sed "s/_R1_unpaired.fq.gz//" | sed "s/_R2_unpaired.fq.gz//" | uniq`;
do kaiju ../../programas/kaiju/kaijudb/nodes.dmp -f ../../programas/kaiju/kaijudb/kaiju_db_nr_euk.fmi -i ../data/filter/outputs/bulk/${i}_paired_bulk.fastq -z 4 -o ../data/reports/kaiju/${i}_paired_classification.tsv;
kaiju ../../programas/kaiju/kaijudb/nodes.dmp -f ../../programas/kaiju/kaijudb/kaiju_db_nr_euk.fmi -i ../data/filter/outputs/bulk/${i}_R1_unpaired.fq.gz -z 4 -o ../data/reports/kaiju/${i}_R1_unpaired_classification.tsv;
kaiju ../../programas/kaiju/kaijudb/nodes.dmp -f ../../programas/kaiju/kaijudb/kaiju_db_nr_euk.fmi -i ../data/filter/outputs/bulk/${i}_R2_unpaired.fq.gz -z 4 -o ../data/reports/kaiju/${i}_R2_unpaired_classification.tsv;
done

# Concatenate the input
for i in `ls ../data/reports/kaiju/ | grep ".tsv" | sed "s/_paired_classification.tsv//"| sed "s/_R1_unpaired_classification.tsv//" | sed "s/_R2_unpaired_//" | uniq`;
cat ${i}__paired_classification.tsv ${i}_R1_unpaired_classification.tsv ${i}_R2_unpaired_classification.tsv;
done
