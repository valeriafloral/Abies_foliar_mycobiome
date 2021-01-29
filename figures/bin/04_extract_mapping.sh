#! /bin/bash

#SBATCH -w nodo07
#SBATCH -n 6

#Valeria Flores
#28/01/2021

# file header
echo "bam_file total mapped unmapped"

# loop to count reads in all files and add results to a table
# ultimately the data is saved in a space-separated file countmappedreads.csv
for bam_file in *.bam
do
total=$(samtools view -c $bam_file)
mapped=$(samtools view -c -F 4 $bam_file)
unmapped=$(samtools view -c -f 4 $bam_file)
echo "$bam_file $total $mapped $unmapped"
done  > ../data/countmappedreads.csv


#The table must be manually edited (divide bam_file in sample and R1_unpaired, R2_unpaired or paired)
