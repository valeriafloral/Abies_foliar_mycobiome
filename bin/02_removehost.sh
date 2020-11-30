#!/bin/sh

#Valeria Flores
#Remove Abies balsamea reads with BWA

#Make index
bwa index -a bwtsw ../../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
samtools faidx ../../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
makeblastdb -in ./../data/filter/reference/GCAT_AB-RNA-1.0.16.fa -dbtype nucl
