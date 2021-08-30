#!/bin/bash

#SBATCH -w nodo3
#SBATCH -n 6

# Valeria Flores
#14/05/2021
#Export Kaiju report to kraken



make_ktaxonomy.py --nodes ../../programas/kraken2_db/fungi/taxonomy/nodes.dmp --names ../../programas/kraken2_db/fungi/taxonomy/names.dmp --seqid2taxid ../../programas/kraken2_db/fungi/seqid2taxid.map -o ../../programas/kraken2_db/fungi/fungi_taxonomy.txt

make_kreport.py -i ../data/reports/kaiju/DPVR18_S196_cat_kaiju.out -t ../../programas/kraken2_db/fungi/fungi_taxonomy.txt -o ../data/reports/kaiju/test.kraken2


for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do make_kreport.py -i ../data/reports/kaiju/${f}_paired_kaiju.out -t ../../programas/kraken2_db/fungi/ktaxonomy -o ../data/reports/kaiju/kraken/${f}_ka_paired.tsv;
done

make_kreport.py -i DPVR18_S196_kaiju_cat.out -t ../../../../programas/kraken2_db/fungi/ktaxonomy -o test.tsv



#Make a kraken-report style from Kaiju to import it to phyloseq
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kraken-report --db ../../programas/krakenuniq_db/ ../data/reports/kaiju/${f}_paired_kaiju.out > ../data/reports/kaiju/kraken/${f}_ka_paired.out;
kraken-report --db ../../programas/krakenuniq_db/ ../data/reports/kaiju/${f}_R1_unpaired_kaiju.out > ../data/reports/kaiju/kraken/${f}_ka_R1.out;
kraken-report --db ../../programas/krakenuniq_db/ ../data/reports/kaiju/${f}_R2_unpaired_kaiju.out > ../data/reports/kaiju/kraken/${f}_ka_R2.out;
kraken-report --db ../../programas/krakenuniq_db/ ../data/reports/kaiju/${f}_kaiju_cat.out > ../data/reports/kaiju/kraken/${f}_ka_cat.out;
kraken-report --db ../../programas/krakenuniq_db/ ../data/reports/kaiju/${f}_contigs_kaiju.out > ../data/reports/kaiju/kraken/${f}_ka_contigs.out;
done


#Make a mpa report style to easier export it to R
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kaiju/kraken/${f}_ka_paired.out -o ../data/reports/kaiju/kraken/${f}_ka_paired.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kaiju/kraken/${f}_ka_R1.out -o ../data/reports/kaiju/kraken/${f}_ka_R1.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kaiju/kraken/${f}_ka_R2.tsv -o ../data/reports/kaiju/kraken/${f}_ka_R2.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kaiju/kraken/${f}_ka_cat.out -o ../data/reports/kaiju/kraken/${f}_ka_cat.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kaiju/kraken/${f}_ka_contigs.out -o ../data/reports/kaiju/kraken/${f}_ka_contigs.txt --no-intermediate-ranks --read_count --display-header;
done

#Combine
for f in paired R1 R2 cat contigs;
do combine_mpa.py -i ../data/reports/kaiju/kraken/*_ka_${f}.txt -o ../data/reports/kaiju/kraken/combined_sp.txt;
done

#Keep only classified at species level
grep -E "(s__)|(#Classification)" ../data/reports/kaiju/kraken/combined_sp.txt > ../data/reports/diversity/kaiju.txt
