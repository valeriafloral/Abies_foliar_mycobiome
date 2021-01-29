#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#27/01/2021
#Assign taxonomy to reads using Kraken2

#Concatenate de paired and unpaired files



kraken2 --use-names --threads 4 --db microb_nt_db --fastq-input --report evol1 --gzip-compressed --paired ../mappings/evol1.sorted.unmapped.R1.fastq.gz ../mappings/evol1.sorted.unmapped.R2.fastq.gz > evol1.kraken
krakenuniq --db microb_nt_db --fastq-input ../bowtie2_out/c22_rrna_org_unmap.fq --threads 12 --report-file REPORTFILE.tsv > READCLASSIFICATION.tsv


#Work in progress
