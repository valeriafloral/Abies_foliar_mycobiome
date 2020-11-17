#!/bin/sh
#Valeria Flores

#Replace the previously removed replicate reads back into our data set
python ../python_scripts/3_Reduplicate.py ../../data/trimmed/mouse1_trimmed.fastq ../../data/qual/mouse1_unique_mRNA.fastq ../../data/trimmed/mouse1_unique.fastq.clstr ../../data/qual/mouse1_mRNA.fastq

#Check the quality
fastqc ../../data/qual/mouse1_mRNA.fastq --outdir=../../metadata/fastqc
