#!/bin/sh
#Valeria Flores

#Remove duplicate reads using CD-HIT-Auxtools
cd-hit-dup -i ../../data/trimmed/mouse1_trimmed.fastq -o ../../data/trimmed/mouse1_unique.fastq
