#!/bin/bash
#Taller avanzado de bionformatica, posgrado en Ciencias Biológicas
#19/02/2021
#Extract reads information from a Trimmomatic report

#Filter the samples ID
less trimmomatic.txt | grep "DPVR*" | cut -d ' ' -f5 | sed "s/_L007_R1_001.fastq.gz//" | sed "s/..\/data\/RAW\///" > ids.txt

#Filter information of each sample
#sed on Mac doesn't recognize tabs as \t. You need to press [control] + [v] and then [tab] key.
less trimmomatic.txt | grep "Input Read Pairs" | cut -d ' ' -f7,12,17,20 | sed -e 's/ /    /g' > info.txt

#Merge the files
paste ids.txt info.txt > table.txt
