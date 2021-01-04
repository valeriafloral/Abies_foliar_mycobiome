#!/bin/sh

#Valeria Flores
#Remove Abies balsamea reads with BWA

#Make index
bwa index -a bwtsw ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
samtools faidx ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa
makeblastdb -in ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa -dbtype nucl

#Perform alignments for paired reads with BWA
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do bwa mem -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${f}_L007_R1_001_paired.fq.gz ../data/filter/outputs/${f}_L007_R2_001_paired.fq.gz > ../data/filter/outputs/${f}_paired.sam;
done

#Convert .sam to .bam using samtools
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools view -bS ../data/filter/outputs/${f}_paired.sam > ../data/filter/outputs/${f}_paired.bam;
done

#Generate fastq outputs for all reads that did not map to the host reference genome (-f 4)
#This is the datatset that is going to be used
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_paired_bulk.fastq ../data/filter/outputs/${f}_paired.bam;
done

#Statistics
for f in for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools flagstat ../data/filter/outputs/${f}_paired.bam > ../../data/reports/${f}_hostmap_paired.txt;
done

###################### UNPAIRED DATA ######################
#Each unpaired dataset must be separately mapped


#Perform alignments for R1 with BWA
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do bwa mem -aM -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${f}_L007_R1_001_unpaired.fq.gz > ../data/filter/outputs/${f}_R1_unpaired.sam;
done

#Perform alignments for R2 with BWA
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do bwa mem -aM -t 4 ../data/filter/reference/GCAT_AB-RNA-1.0.16.fa ../data/filter/outputs/${f}_L007_R2_001_unpaired.fq.gz > ../data/filter/outputs/${f}_R2_unpaired.sam;
done

#Convert R1.sam to R1.bam using samtools
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools view -bS ../data/filter/outputs/${f}_R1_unpaired.sam > ../data/filter/outputs/${f}_R1_unpaired.bam;
done

#Convert R2.sam to R2.bam using samtools
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools view -bS ../data/filter/outputs/${f}_R2_unpaired.sam > ../data/filter/outputs/${f}_R2_unpaired.bam;
done

#Generate fastq outputs for all unpaired R1 reads that did not map to the host reference genome (-f 4)
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_R1_unpaired_bulk.fastq ../data/filter/outputs/${f}_R1_unpaired.bam;
done

#Generate fastq outputs for all unpaired R2 reads that did not map to the host reference genome (-f 4)
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools fastq -n -f 4 -0 ../data/filter/outputs/${f}_R2_unpaired_bulk.fastq ../data/filter/outputs/${f}_R2_unpaired.bam;
done


#R1_unpaired Statistics
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools flagstat ../data/filter/outputs/${f}_R1_unpaired.bam > ../../data/reports/hostmap_R1_unpaired.txt;
done

#R2_unpaired Statistics
for f in DPVR1_S179 DPVR2_S180 DPVR3_S181 DPVR4_S182 DPVR5_S183 DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR11_S189 DPVR12_S190 DPVR13_S191 DPVR14_S192 DPVR15_S193 DPVR16_S194;
do samtools flagstat ../data/filter/outputs/${f}_R2_unpaired.bam > ../../data/reports/hostmap_R2_unpaired.txt;
done
