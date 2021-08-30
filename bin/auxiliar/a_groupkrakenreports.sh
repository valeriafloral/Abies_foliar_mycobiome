#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#Group kraken reports by condition and paired/unpaired/concatenated

#Set Krakenuniq reports directory
kr="../data/reports/kraken/reads"
declare -a con=("tolerant" "damaged")
declare -a type=("paired" "r1" "r2" "cat")
declare -a tolerant=("DPVR1_S179" "DPVR2_S180" "DPVR3_S181" "DPVR4_S182" "DPVR5_S183" "DPVR11_S189" "DPVR12_S190" "DPVR13_S191" "DPVR17_S195")
declare -a damaged=("DPVR6_S184" "DPVR7_S185" "DPVR8_S186" "DPVR9_S187" "DPVR10_S188" "DPVR14_S192" "DPVR15_S193" "DPVR16_S194" "DPVR18_S196")

declare -a samples=("DPVR1_S179" "DPVR2_S180" "DPVR3_S181" "DPVR4_S182" "DPVR5_S183" "DPVR11_S189" "DPVR12_S190" "DPVR13_S191" "DPVR17_S195" "DPVR6_S184" "DPVR7_S185" "DPVR8_S186" "DPVR9_S187" "DPVR10_S188" "DPVR14_S192" "DPVR15_S193" "DPVR16_S194" "DPVR18_S196")
#Make nested folders to save each type of reports and outputs
for con in ${con[@]};
do for tf in ${tf[@]};
do mkdir -p ${kr}/${f}/${i};
done;
done


for samples in ${samples[@]};
do mv ${samples}_cat_kaiju.tsv ${samples}_kaiju_cat.tsv;
mv ${samples}_contigs_kaiju.tsv ${samples}_kaiju_contigs.tsv;
done

#Parse outputs
for f in `ls ${kr} | grep "DPVR" | sed "s/.kraken//" | sed "s/.report//" | uniq`;
do tail -n +5 ${kr}/${f}.report | cut -f 1-3,7-10 > ${kr}/${f}_clean.report;
done

for f in `ls | grep "DPVR" | sed "s/.kraken//" | sed "s/.report//" | uniq`;
do mv ${f}_clean.report ${f}.report | cut -f 1-3,7-10 ${f}.report > ${f}_cut.report | mv ${f}_cut.report ${f}.report;
done

#Move each report and output to its respective folder
for tol in ${tolerant[@]};
do for dam in ${damaged[@]}
do for f in kraken report;
do mv ${kr}/${dam}_kr_paired.${f} ${kr}/damaged/paired;
mv ${kr}/${dam}_kr_r1.${f} ${kr}/damaged/r1;
mv ${kr}/${dam}_kr_r2.${f} ${kr}/damaged/r2;
mv ${kr}/${dam}_kr_cat.${f} ${kr}/damaged/cat;
mv ${f}/${tol}__kr_paired.${f} ${kr}/tolerant/paired;
mv ${f}/${tol}__kr_r1.${f} ${kr}/tolerant/r1;
mv ${f}/${tol}__kr_r2.${f} ${kr}/tolerant/r2;
mv ${f}/${tol}__kr_cat.${f} ${kr}/tolerant/cat;
done;
done;
done




for dam in ${damaged[@]};
do cp ${dam}.txt damaged;
done


for damaged in DPVR6_S184 DPVR7_S185 DPVR8_S186 DPVR9_S187 DPVR10_S188 DPVR14_S192 DPVR15_S193 DPVR16_S194 DPVR18_S196;
do cat ../data/filter/bulk/${damaged}_paired_bulk.fastq ../data/filter/bulk/${damaged}_R1_unpaired_bulk.fastq ../data/filter/bulk/${damaged}_R2_unpaired_bulk.fastq > ../data/filter/bulk/${damaged}.fastq;
done

for f in `ls | grep ".report" | sed "s/.report//" | uniq`;
tail -n +5 ${kr}/${f}.report | cut -f 1-3,7-10 >> ${kr}/${f}.report;
done

for f in `ls | grep "DPVR" | sed "s/.kraken//" | sed "s/.report//" | uniq`;
do echo ${kr}/${f};
done
