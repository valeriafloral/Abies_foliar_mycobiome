#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#11/05/2021
#Krakenuniq report to mpa


kreport2mpa.py -r DPVR10_S188_kc.report -o DPVR10_S188.mpa.txt --no-intermediate-ranks --read_count --display-header

ktImportTaxonomy DPVR10_S188_kc.report -t 7 -s 6 -o DPVR10_S188_kc.html ;



../../../../../../programas/bracken -d ../../../../../../programas/krakenuniq_db -i DPVR10_S188_kr_cat_cut.report -r 90 -t 10 -l S -o DPVR10_S188_kr_cat_cut_species.txt

../../../../../../programas/bracken-build -d ../../../../../../programas/krakenuniq_db -t 4 -k 31 -l 150


grep -c '>' ../data/reports/assembly/*assembly/*ranscr*.fa*
