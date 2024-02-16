#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores


TransDecoder.LongOrfs -t ../data/assembly/03.Trinity.Trinity.fasta -m 60
TransDecoder.Predict -t ../data/assembly/03.Trinity.Trinity.fasta --retain_pfam_hits 03.Trinity.Trinity.fasta.transdecoder_dir/pfam.domtblout --retain_blastp_hits 03.Trinity.Trinity.fasta.transdecoder_dir/blastp.outfmt6
