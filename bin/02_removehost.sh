#!/bin/sh

#Valeria Flores
#Remove Abies balsamea reads with BWA

#Make index
bwa index -a bwtsw ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
samtools faidx ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
makeblastdb -in ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa -dbtype nucl

#Perform alignments for paired reads with BWA and filter out any reads that align to our database with Samtools
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR17_S195 DPVR18_S196;
do bwa mem -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${f}_L007_R1_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R2_001_paired.fq.gz > ../data/filter/outputs/${f}_paired.sam;
done

#Convert .sam to .bam using samtools
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR17_S195 DPVR18_S196;
do samtools view -bS ../data/filter/outputs/${f}_paired.sam > ../data/filter/outputs/${f}_paired.bam;
done

#Generate fastq outputs for all reads that mapped to the host reference genome (-F 4)
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR17_S195 DPVR18_S196;
do samtools fastq -n -F 4 -0 ../data/filter/outputs/${f}_paired_host.fastq ../data/filter/outputs/${f}_paired_host.bam;
done

#Generate fastq outputs for all reads that did not map to the host reference genome (-f 4)
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR17_S195 DPVR18_S196;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_paired_bulk.fastq ../data/filter/outputs/${f}_paired_bulk.bam
done

#Statistics
for f in for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR17_S195 DPVR18_S196;
do samtools flagstat ../data/filter/outputs/${f}_paired_bulk.bam > ../metadata/reports/${f}hostmap.txt;
done



###################### UNPAIR ######################
