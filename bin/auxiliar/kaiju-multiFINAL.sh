#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#08/06/2021
#Assign taxonomy to reads using Kaiju multi with nr_euk database.

#Kaiju-multi with reads
kaiju-multi -z 4 \
-t ../../programas/kaiju_nr/nodes.dmp \
-f ../../programas/kaiju_nr/kaiju_db.fmi \
-i DPVR10_S188_cat.fastq, DPVR11_S189_cat.fastq, DPVR12_S190_cat.fastq, DPVR13_S191_cat.fastq, DPVR14_S192_cat.fastq, DPVR15_S193_cat.fastq, DPVR16_S194_cat.fastq, DPVR17_S195_cat.fastq, DPVR18_S196_cat.fastq, DPVR1_S179_cat.fastq, DPVR2_S180_cat.fastq, DPVR3_S181_cat.fastq, DPVR4_S182_cat.fastq, DPVR5_S183_cat.fastq, DPVR6_S184_cat.fastq, DPVR7_S185_cat.fastq, DPVR8_S186_cat.fastq, DPVR9_S187_cat.fastq > ../data/reports/kaiju/multi/reads_kaiju.out


#Kaiju-multi with contigs
kaiju-multi -z 4 \
-t ../../programas/kaiju_db/nodes.dmp \
-f ../../programas/kaiju_db/fungi/kaiju_db_fungi.fmi
-i DPVR10_S188_cat.fastq, DPVR11_S189_cat.fastq, DPVR12_S190_cat.fastq, DPVR13_S191_cat.fastq, DPVR14_S192_cat.fastq, DPVR15_S193_cat.fastq, DPVR16_S194_cat.fastq, DPVR17_S195_cat.fastq, DPVR18_S196_cat.fastq, DPVR1_S179_cat.fastq, DPVR2_S180_cat.fastq, DPVR3_S181_cat.fastq, DPVR4_S182_cat.fastq, DPVR5_S183_cat.fastq, DPVR6_S184_cat.fastq, DPVR7_S185_cat.fastq, DPVR8_S186_cat.fastq, DPVR9_S187_cat.fastq > ../data/reports/kaiju/multi/contigs_kaiju.out
