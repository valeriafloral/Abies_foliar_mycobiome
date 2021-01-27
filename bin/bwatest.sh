#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#26/01/2021
#Remove Abies balsamea reads with BWA

#Make index
bwa index -a bwtsw ../data/filter/reference/GGJG01.1.fasta
samtools faidx ../data/filter/reference/GGJG01.1.fasta
makeblastdb -in ../data/filter/reference/GGJG01.1.fasta -dbtype nucl

#Perform alignments for paired and unpaired reads with BWA
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do bwa mem -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/bwatest/${f}_L007_R1_001_paired.fq.gz ../data/filter/bwatest/${f}_L007_R2_001_paired.fq.gz > ../data/filter/bwatest/${f}_paired.sam;
bwa mem -aM -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/bwatest/${f}_L007_R1_001_unpaired.fq.gz > ../data/filter/bwatest/${f}_R1_unpaired.sam;
bwa mem -aM -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/bwatest/${f}_L007_R2_001_unpaired.fq.gz > ../data/filter/bwatest/${f}_R2_unpaired.sam;
done


#Convert .sam to .bam using samtools
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools view -bS ../data/filter/bwatest/${f}_paired.sam > ../data/filter/bwatest/${f}_paired.bam;
samtools view -bS ../data/filter/bwatest/${f}_R1_unpaired.sam > ../data/filter/bwatest/${f}_R1_unpaired.bam;
samtools view -bS ../data/filter/bwatest/${f}_R2_unpaired.sam > ../data/filter/bwatest/${f}_R2_unpaired.bam;
done

#Generate fastq outputs for all reads that did not map to the host reference genome (-f 4)
#This is the datatset that is going to be used
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools fastq -n -f 4 -0 ../data/filter/bwatest/${f}_paired_bulk.fastq ../data/filter/bwatest/${f}_paired.bam;
samtools fastq -n -f 4 -0 ../data/filter/bwatest/${f}_R1_unpaired_bulk.fastq ../data/filter/bwatest/${f}_R1_unpaired.bam;
samtools fastq -n -f 4 -0 ../data/filter/bwatest/${f}_R2_unpaired_bulk.fastq ../data/filter/bwatest/${f}_R2_unpaired.bam;
done

#Statistics
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools flagstat ../data/filter/bwatest/${f}_paired.bam > ../data/reports/mapping/${f}_hostmap_paired.txt;
samtools flagstat ../data/filter/bwatest/${f}_R1_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R1_unpaired.txt;
samtools flagstat ../data/filter/bwatest/${f}_R2_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R2_unpaired.txt;
done
