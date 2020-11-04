#!/bin/sh

#Valeria Flores
#Remove Mus musculus reads

#Perform alignments for reads with BWA and filter out any reads that align to our database with Samtools (using the output from bwa, not blat)
bwa mem -t 4 ../../metadata/Mmusculus_genome/mouse_cds.fa ../../data/trimmed/mouse1_univec_bwa.fastq > ../../data/trimmed/mouse1_mouse_bwa.sam

#Convert .sam to .bam using samtools
samtools view -bS ../../data/trimmed/mouse1_mouse_bwa.sam > ../../data/trimmed/mouse1_mouse_bwa.bam

#Generate fastq outputs for all reads that mapped to the host reference genome (-F 4) and all reads that did not map to the host reference genome (-f 4)
samtools fastq -n -F 4 -0 ../../data/trimmed/mouse1_mouse_bwa_contaminats.fastq ../../data/trimmed/mouse1_mouse_bwa.bam
samtools fastq -n -f 4 -0 ../../data/trimmed/mouse1_mouse_bwa.fastq ../../data/trimmed/mouse1_mouse_bwa.bam
