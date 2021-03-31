#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#31/01/2021
#Assign taxonomy to reads using Kraken2

#Use concatenated files
#Create a file for tolerant and damaged sequences

touch ../data/filter/bulk/tolerant.fastq
touch ../data/filter/bulk/damaged.fastq

#Concatenate tolerant
for tolerant in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR17_S195;
do cat ../data/filter/bulk/${tolerant}_paired_bulk.fastq ../data/filter/bulk/${tolerant}_R1_unpaired_bulk.fastq ../data/filter/bulk/${tolerant}_R2_unpaired_bulk.fastq > ../data/filter/bulk/tolerant.fastq;
done

#Concatenate damaged
for damaged in DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR18_S196;
do cat ../data/filter/bulk/${damaged}_paired_bulk.fastq ../data/filter/bulk/${damaged}_R1_unpaired_bulk.fastq ../data/filter/bulk/${damaged}_R2_unpaired_bulk.fastq > ../data/filter/bulk/damaged.fastq;
done

#Make the classification
for i in tolerant damaged;
do krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/filter/bulk/${i}.fastq --threads 12 --report-file ../data/reports/kraken${i}.tsv;
done
