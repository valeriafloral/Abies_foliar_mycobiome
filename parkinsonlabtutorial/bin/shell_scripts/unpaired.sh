#!/bin/sh

#Mapping unpaired reads to the reference using BWA
#Valeria Flores

#Make index
bwa index -a bwtsw ../../metadata/Mmusculus_genome/mouse_cds.fa
samtools faidx ../../metadata/Mmusculus_genome/mouse_cds.fa
makeblastdb -in ../../metadata/Mmusculus_genome/mouse_cds.fa -dbtype nucl

#Run each unpaired data separately
#Perform alignments for R1 with BWA and filter out any reads that align to our database with Samtools (using the output from bwa, not blat)
bwa mem -aM -t 4 ../../metadata/Mmusculus_genome/mouse_cds.fa ../../data/trimmed/mouse1_univec_bwa.R1.unpaired.fastq > mouse1_univec_bwa.R1.unpaired.sam

#Perform alignments for R2 with BWA and filter out any reads that align to our database with Samtools (using the output from bwa, not blat)
bwa mem -aM -t 4 ../../metadata/Mmusculus_genome/mouse_cds.fa ../../data/trimmed/mouse1_univec_bwa.R2.unpaired.fastq > mouse1_univec_bwa.R2.unpaired.sam

#Convert R1.sam to R1.bam using samtools
samtools view -bS mouse1_univec_bwa.R1.unpaired.sam > mouse1_univec_bwa.R1.unpaired.bam

#Convert R2.sam to R2.bam using samtools
samtools view -bS mouse1_univec_bwa.R2.unpaired.sam > mouse1_univec_bwa.R2.unpaired.bam

#Generate fastq outputs for all unpaired R1 reads that did not map to the host reference genome (-f 4)
samtools fastq -n -f 4 -0 ../../data/trimmed/mouse1_mouse_bwa.R1.unpaired.fastq mouse1_univec_bwa.R1.unpaired.bam

#Generate fastq outputs for all unpaired R2 reads that did not map to the host reference genome (-f 4)
samtools fastq -n -f 4 -0 ../../data/trimmed/mouse1_mouse_bwa.R2.unpaired.fastq mouse1_univec_bwa.R2.unpaired.bam

#Statistics
samtools flagstat ../../data/trimmed/mouse1_mouse_bwa.unpaired.R1.bam > ../../data/reports/hostmap.R1.unpaired.txt

#Statistics
samtools flagstat ../../data/trimmed/mouse1_mouse_bwa.unpaired.R2.bam > ../../data/reports/hostmap.R2.unpaired.txt
