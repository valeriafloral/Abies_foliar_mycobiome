#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#Last update 21/09/2021
#Remove Abies reads with BWA

#Make host reference index
bwa index -a bwtsw ../data/filter/reference/GGJG01.1.fasta

#Map reads against host reference
for f in `ls ../data/filter/trimmed/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do bwa mem -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/trimmed/${f}_L007_R1_001_paired.fq.gz ../data/filter/trimmed/${f}_L007_R2_001_paired.fq.gz > ../data/filter/nonhost/${f}_paired.sam;
bwa mem -a -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/trimmed/${f}_L007_R1_001_unpaired.fq.gz > ../data/filter/nonhost/${f}_R1_unpaired.sam;
bwa mem -a -t 4 ../data/filter/reference/GGJG01.1.fasta ../data/filter/trimmed/${f}_L007_R2_001_unpaired.fq.gz > ../data/filter/nonhost/${f}_R2_unpaired.sam;
done

#Convert .sam to .bam using samtools
for f in `ls ../data/filter/trimmed/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools view -bS ../data/filter/nonhost/${f}_paired.sam > ../data/filter/nonhost/${f}_paired.bam;
samtools view -bS ../data/filter/nonhost/${f}_R1_unpaired.sam > ../data/filter/nonhost/${f}_R1_unpaired.bam;
samtools view -bS ../data/filter/nonhost/${f}_R2_unpaired.sam > ../data/filter/nonhost/${f}_R2_unpaired.bam;
done

#Extract unmapped reads (non-host)
for f in `ls ../data/filter/trimmed/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools view -b -f 12 -F 256 ../data/filter/nonhost/${f}_paired.bam > ../data/filter/nonhost/${f}_p_um.bam;
samtools view -b -f 4 -F 256 ../data/filter/nonhost/${f}_R1_unpaired.bam > ../data/filter/nonhost/${f}_R1_up_um.bam;
samtools view -b -f 4 -F 256 ../data/filter/nonhost/${f}_R2_unpaired.bam > ../data/filter/nonhost/${f}_R2_up_um.bam;
done

#Sort bam file to organize paired reads and convert bam paired files into fastq
for f in `ls ../data/filter/trimmed/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools sort -n ../data/filter/nonhost/${f}_p_um.bam -o ../data/filter/nonhost/${f}_p_um_sorted.bam;
samtools bam2fq  ../data/filter/nonhost/${f}_p_um_sorted.bam > ../data/filter/nonhost/${f}_p_filtered.fastq;
done

#Convert bam unpaired files into fastq
for f in `ls ../data/filter/trimmed/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools bam2fq ../data/filter/nonhost/${f}_R1_up_um.bam > ../data/filter/nonhost/${f}_R1_up_filtered.fastq;
samtools bam2fq ../data/filter/nonhost/${f}_R2_up_um.bam > ../data/filter/nonhost/${f}_R2_up_filtered.fastq;
done

#Statistics
for f in `ls ../data/filter/trimmed/ | grep ".fq.gz" | sed "s/_L007_R1_001_paired.fq.gz//"| sed "s/_L007_R2_001_paired.fq.gz//" | sed "s/_L007_R1_001_unpaired.fq.gz//"| sed "s/_L007_R2_001_unpaired.fq.gz//"| uniq`;
do samtools stats ../data/filter/nonhost/${f}_paired.bam > ../data/reports/mapping/${f}_hostmap_paired.txt;
samtools stats ../data/filter/nonhost/${f}_R1_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R1_unpaired.txt;
samtools stats ../data/filter/nonhost/${f}_R2_unpaired.bam > ../data/reports/mapping/${f}_hostmap_R2_unpaired.txt;
done

#Quality with FastQC
for f in p_filtered.fastq R1_up_filtered.fastq R2_up_filtered.fastq;
do fastqc ../data/filter/nonhost/*_${f} --outdir=../data/reports/nonhost;
done

#Group reports with multiQC
for f in p_filtered_fastqc.html R1_up_filtered_fastqc.html R2_up_filtered_fastqc.html
do multiqc ../data/reports/nonhost/*_${f} --outdir=../data/reports/nonhost;
done

