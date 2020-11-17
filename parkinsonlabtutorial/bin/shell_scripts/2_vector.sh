#!/bin/sh
#Valeria Flores

#Generate an index of these sequences for BWA an BLAT
bwa index -a bwtsw ../../metadata/index/vector_contamination/UniVec_Core
samtools faidx ../../metadata/index/vector_contamination/UniVec_Core
makeblastdb -in ../../metadata/index/vector_contamination/UniVec_Core -dbtype nucl


#Perform alignments for reads with BWA and filter out any reads that align to our database with Samtools
bwa mem ../../metadata/index/vector_contamination/UniVec_Core ../../data/trimmed/mouse1_unique.fastq > ../../data/trimmed/mouse1_univec_bwa.sam

#Convert .sam to .bam using samtools
samtools view -bS ../../data/trimmed/mouse1_univec_bwa.sam > ../../data/trimmed/mouse1_univec_bwa.bam

samtools flagstat ../../data/trimmed/mouse1_univec_bwa.bam > ../../data/reports/mouse1_univec_bwa.bam.txt


#Generate fastq outputs for all reads that mapped to the vector contaminant database (-F 4)
samtools fastq -n -F 4 -0 ../../data/trimmed/mouse1_univec_bwa_contaminats.fastq ../../data/trimmed/mouse1_univec_bwa.bam

#Generate fastq outputs for all reads that did not map to the vector contaminant database (-f 4)
samtools fastq -n -f 4 -0 ../../data/trimmed/mouse1_univec_bwa.fastq ../../data/trimmed/mouse1_univec_bwa.bam
