#!/bin/sh

#Valeria Flores
#Assembly with metaSPADEs
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do spades.py --rna --meta --12 ../data/filter/outputs/${f}_paired_bulk.fastq --s1 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq --s2 ../data/filter/outputs/${f}_R2_unpaired_bulk.fastq -k 21,33,55,77,99,111,127 -o ../data/assembly/${f}_assembly;
done

#Count contigs
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do grep -c '>' ${f}_assembly/contigs.fasta
done

#move contigs to reports or save contigs directly in reports (?) ../data/reports/Assembly/
