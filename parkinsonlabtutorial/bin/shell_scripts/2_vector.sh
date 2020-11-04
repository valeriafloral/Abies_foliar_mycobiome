#!/bin/sh
#Valeria Flores

#Perform alignments for reads with BWA and filter out any reads that align to our database with Samtools
bwa mem ../../metadata/index/vector_contamination/UniVec_Core ../../data/trimmed/mouse1_unique.fastq > ../../data/trimmed/mouse1_univec_bwa.sam

#Convert .sam to .bam using samtools
samtools view -bS ../../data/trimmed/mouse1_univec_bwa.sam > ../../data/trimmed/mouse1_univec_bwa.bam

#Generate fastq outputs for all reads that mapped to the vector contaminant database (-F 4) and all reads that did not map to the vector contaminant database (-f 4)
samtools fastq -n -F 4 -0 ../../data/trimmed/mouse1_univec_bwa_contaminats.fastq ../../data/trimmed/mouse1_univec_bwa.bam
samtools fastq -n -f 4 -0 ../../data/trimmed/mouse1_univec_bwa.fastq ../../data/trimmed/mouse1_univec_bwa.bam

#Perform additional alignments wit BLAT to filter any remaining reads that align to vector_contamination database

#Convert from fastq to fasta to use BLAT using VSEARCH
vsearch --fastq_filter ../../data/trimmed/mouse1_univec_bwa.fastq --fastaout ../../data/trimmed/mouse1_univec_bwa.fasta

#Use BLAT to perform additional alignments for the reads against vector_contamination database
blat -noHead -minIdentity=90 -minScore=65  ../../metadata/index/vector_contamination/UniVec_Core ../../data/trimmed/mouse1_univec_bwa.fasta -fine -q=rna -t=dna -out=blast8 ../../data/trimmed/mouse1_univec.blatout

#Run a small python script to filter the reads that BLAT does not confidently align to any sequences from our vector_contamination database
##It is necessary to modify the ../python_scripts/1_BLAT_Filter.py because of error message (DON'T WORK)
../python_scripts/1_BLAT_Filter.py ../../data/trimmed/mouse1_univec_bwa.fastq ../../data/trimmed/mouse1_univec.blatout ../../data/trimmed/mouse1_univec_blat.fastq ../../data/trimmed/mouse1_univec_blat_contaminats.fastq
