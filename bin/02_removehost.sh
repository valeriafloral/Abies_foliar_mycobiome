#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#12/01/2020
#Remove Abies balsamea reads with BWA

#Make index
bwa index -a bwtsw ../data/filter/reference/GGJG01.1.fasta
samtools faidx ../data/filter/reference/GGJG01.1.fasta
makeblastdb -in ../data/filter/reference/GGJG01.1.fasta -dbtype nucl

#Perform alignments for paired reads with BWA
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do bwa mem -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/outputs/${f}_L007_R1_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R2_001_paired.fq.gz > ../data/filter/outputs/${f}_paired.sam;
done

#Convert .sam to .bam using samtools
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools view -bS ../data/filter/outputs/${f}_paired.sam > ../data/filter/outputs/${f}_paired.bam;
done

#Generate fastq outputs for all reads that did not map to the host reference genome (-f 4)
#This is the datatset that is going to be used
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_paired_bulk.fastq ../data/filter/outputs/${f}_paired.bam;
done

#Statistics
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools flagstat ../data/filter/outputs/${f}_paired.bam > ../data/reports/mapping/${f}_hostmap_paired.txt;
done

###################### UNPAIRED DATA ######################
#Each unpaired dataset must be separately mapped


#Perform alignments for R1 with BWA
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do bwa mem -aM -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/outputs/${f}_L007_R1_001_unpaired.fq.gz > ../data/filter/outputs/${f}_R1_unpaired.sam;
done

#Perform alignments for R2 with BWA
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do bwa mem -aM -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/outputs/${f}_L007_R2_001_unpaired.fq.gz > ../data/filter/outputs/${f}_R2_unpaired.sam;
done

#Convert R1.sam to R1.bam using samtools
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools view -bS ../data/filter/outputs/${f}_R1_unpaired.sam > ../data/filter/outputs/${f}_R1_unpaired.bam;
done

#Convert R2.sam to R2.bam using samtools
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools view -bS ../data/filter/outputs/${f}_R2_unpaired.sam > ../data/filter/outputs/${f}_R2_unpaired.bam;
done

#Generate fastq outputs for all unpaired R1 reads that did not map to the host reference genome (-f 4)
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq ../data/filter/outputs/${f}_R1_unpaired.bam;
done

#Generate fastq outputs for all unpaired R2 reads that did not map to the host reference genome (-f 4)
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_R2_unpaired_bulk.fastq ../data/filter/outputs/${f}_R2_unpaired.bam;
done

#R1_unpaired Statistics
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools flagstat ../data/filter/outputs/${f}_R1_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R1_unpaired.txt;
done

#R2_unpaired Statistics
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools flagstat ../data/filter/outputs/${f}_R2_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R2_unpaired.txt;
done
