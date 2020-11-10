#!/bin/sh
#Valeria Flores

#Perform alignments for reads with BWA and filter out any reads that align to our database with Samtools
bwa mem ../../metadata/index/vector_contamination/UniVec_Core ../../data/trimmed/mouse1_unique.fastq > ../../data/trimmed/mouse1_univec_bwa.sam

#Convert .sam to .bam using samtools
samtools view -bS ../../data/trimmed/mouse1_univec_bwa.sam > ../../data/trimmed/mouse1_univec_bwa.bam

#Generate fastq outputs for all reads that mapped to the vector contaminant database (-F 4)
samtools fastq -n -F 4 -0 ../../data/trimmed/mouse1_univec_bwa_contaminats.fastq ../../data/trimmed/mouse1_univec_bwa.bam

# Generate fastq outputs for all reads that mapped to the vector contaminant database (-f 4)
samtools fastq -n -f 4 -0 ../../data/trimmed/mouse1_univec_bwa.fastq ../../data/trimmed/mouse1_univec_bwa.bam
