#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#31/01/2021
#Krona visualization


###Work in progress

#Variable with krona taxonomy folder
taxonomy="/LUSTRE/Genetica/valeria/miniconda3/envs/krona/opt/krona/taxonomy"

#Build the taxonomy
ktUpdateTaxonomy.sh /LUSTRE/Genetica/valeria/miniconda3/envs/krona/opt/krona/taxonomy

#Run krona
for i in tolerant damaged;
do ktImportTaxonomy ../data/reports/kraken/kraken${i}.tsv -t 7 -s 6 -o ../data/reports/kraken/kraken${i}complete.html ;
done
