#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#27/01/2021
#Buil databases indexes in database files

krakenuniq-build --db ../../programas/kraken --kmer-len 31 --threads 10 --taxids-for-genomes --taxids-for-sequences



