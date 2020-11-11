#!/bin/sh

#Valeria Flores
#Remove abundant rRNA sequences using infernal

#This is for running infernal, but I did not use it because I have precomputed files
#Convert fastq to fasta
vsearch --fastq_filter ../../data/trimmed/mouse1_mouse_bwa.fastq --fastaout ../../data/trimmed/mouse1_mouse.fasta

#Use infernal to
cmsearch -o ../../data/qual/mouse1_rRNA.log --tblout ../../data/qual/mouse1_rRNA.infernalout --anytrunc --rfam -E 0.001 Rfam.cm ../../data/trimmed/mouse1_mouse_blat.fasta

#From this output file it is necessary to use a python script to filter out the rRNA reads:
python ../python_scripts/2_Infernal_Filter.py ../../data/trimmed/mouse1_mouse_bwa.fastq ../../data/qual/mouse1_rRNA.infernalout ../../data/qual/mouse1_unique_mRNA.fastq ../../data/qual/mouse1_unique_rRNA.fastq
