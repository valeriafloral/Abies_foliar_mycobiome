#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#31/01/2021
#Assign taxonomy to reads using Kraken2

#Use concatenated files
#Make the classification
for i in tolerant damaged;
do krakenuniq --db ../../programas/krakenuniq_db --fastq-input ../data/filter/outputs/${i}test.fastq --threads 12 --report-file ../data/reports/kraken${i}test.tsv;
done

###Work in progress

#Krona visualize
# Delete a symbolic link that is not correct
rm -rf ~/miniconda3/envs/krona/opt/krona/taxonomy

# we create a directory in our home where the krona database will live
mkdir -p ~/krona/taxonomy

# now we make a symbolic link to that directory
ln -s ../../../programas/krona/taxonomy /LUSTRE/Genetica/valeria/miniconda3/envs/krona/opt/krona/taxonomy

#Build the taxonomy
ktUpdateTaxonomy.sh /LUSTRE/Genetica/valeria/miniconda3/envs/krona/opt/krona/taxonomy


#Run krona
for i in tolerant damaged;
do ktImportTaxonomy ../data/reports/kraken/kraken${i}test.tsv -t 7 -s 6 -o ../data/reports/kraken/kraken${i}.html ;
done
