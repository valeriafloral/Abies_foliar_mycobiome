for i in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`; do echo "bwa mem -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa $i ${i%1_001_paired.fq.gz}2_001_paired.fq.gz > ${i%R1.fastq}_paired.sam | bwa mem -aM -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${i}_L007_R?_001_unpaired.fq.gz > ../data/filter/outputs/${i}_R?_unpaired.sam"; done




for i in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do echo "hola$i" ../data/filter/outputs/${i}_paired.sam > ../data/filter/outputs/${i}_paired.bam;
echo "adiós$i" ../data/filter/outputs/${i}_unpaired.sam > ../data/filter/outputs/${i}_unpaired.bam;
done



#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 4

# Valeria Flores
#12/01/2020
#Remove Abies balsamea reads with BWA

#Make index
bwa index -a bwtsw ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
samtools faidx ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
makeblastdb -in ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa -dbtype nucl

#Perform alignments for paired and unpaired reads with BWA
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do bwa mem -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${f}_L007_R1_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R2_001_paired.fq.gz > ../data/filter/outputs/${f}_paired.sam;
bwa mem -aM -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${f}_L007_R1_001_unpaired.fq.gz > ../data/filter/outputs/${f}_R1_unpaired.sam;
bwa mem -aM -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${f}_L007_R2_001_unpaired.fq.gz > ../data/filter/outputs/${f}_R2_unpaired.sam;
done

#Convert .sam to .bam using samtools
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools view -bS ../data/filter/outputs/${f}_paired.sam > ../data/filter/outputs/${f}_paired.bam;
samtools view -bS ../data/filter/outputs/${f}_R1_unpaired.sam > ../data/filter/outputs/${f}_R1_unpaired.bam;
samtools view -bS ../data/filter/outputs/${f}_R2_unpaired.sam > ../data/filter/outputs/${f}_R2_unpaired.bam;
done

#Generate fastq outputs for all reads that did not map to the host reference genome (-f 4)
#This is the datatset that is going to be used
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_paired_bulk.fastq ../data/filter/outputs/${f}_paired.bam;
samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq ../data/filter/outputs/${f}_R1_unpaired.bam;
samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_R2_unpaired_bulk.fastq ../data/filter/outputs/${f}_R2_unpaired.bam;
done

#Statistics
for f in `ls ../data/filter/outputs/ | grep ".fq.gz" | sed "s/_paired.fq.gz//"| sed "s/_unpaired.fq.gz//" | uniq`;
do samtools flagstat ../data/filter/outputs/${f}_paired.bam > ../data/reports/mapping/${f}_hostmap_paired.txt;
samtools flagstat ../data/filter/outputs/${f}_R1_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R1_unpaired.txt;
samtools flagstat ../data/filter/outputs/${f}_R2_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R2_unpaired.txt;
done
