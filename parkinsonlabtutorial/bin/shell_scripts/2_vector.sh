#!/bin/sh
#Valeria Flores

#Perform alignments for reads with BWA and filter out any reads that align to our database with Samtools

bwa mem ../../data/UniVec_Core ../../data/trimmed/mouse1_unique.fastq > ../../data/trimmed/mouse1_univec_bwa.sam
samtools view -bS ../../data/trimmed/mouse1_univec_bwa.sam > ../../data/trimmed/mouse1_univec_bwa.bam
 
