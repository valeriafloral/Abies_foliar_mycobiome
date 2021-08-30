ln -s /LUSTRE/Genetica/valeria/programas/Bracken/bracken .
ln -s /LUSTRE/Genetica/valeria/programas/KrakenTools/*py .



#Edit files
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do tail -n +4 ../data/reports/kraken/${f}_k_reads_cat.report | cut -f 1-3,7-10 > ../data/reports/kraken/bracken/${f}_kr_reads_cat.bracken;
done


####bracken-build
bracken-build -d ../../programas/krakenuniq_db -t 4 -k 31 -l 100
kraken-build --db ../../programas/krakenuniq_db --threads 4

#Kraken2 database building
kraken2-build --download-taxonomy --db fungi
kraken2-build --download-library fungi --db fungi
kraken2-build --build --db fungi


####bracken-build
bracken-build -d ../../programas/kraken2_db/fungi -t 4 -k 31 -l 100
bracken -d ../../programas/kraken2_db/fungi -i ../data/reports/kraken2/DPVR17_S195_k2_reads_paired.report -o ../data/reports/bracken/DPVR17_S195_k2_reads_paired.bracken -r 100 -l S -t 1
kreport2mpa.py -r DPVR17_S195_k2_reads_paired_bracken_species.report -o DPVR17_S195_k2_reads_paired.txt --no-intermediate-ranks --read_count

#Parse output
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do sed -i "s/$/\t${f}_k2_R1_bracken.txt/" ../data/reports/kraken2/${f}_k2_R1_bracken.txt;
sed -i "s/$/\t${f}_k2_R2_bracken.txt/" ../data/reports/kraken2/${f}_k2_R2_bracken.txt;
sed -i "s/$/\t${f}_k2_paired_bracken.txt/" ../data/reports/kraken2/${f}_k2_paired_bracken.txt;
sed -i "s/$/\t${f}_k2_cat_bracken.txt/" ../data/reports/kraken2/${f}_k2_cat_bracken.txt;
sed -i "s/$/\t${f}_k2_contigs_bracken.txt/" ../data/reports/kraken2/${f}_k2_contigs_bracken.txt;
done

#Change bracken report to mpa report
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_R1_bracken_species.report -o ../data/reports/kraken2/${f}_k2_R1_bracken.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_R2_bracken_species.report -o ../data/reports/kraken2/${f}_k2_R2_bracken.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_paired_bracken_species.report -o ../data/reports/kraken2/${f}_k2_paired_bracken.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_reads_cat_bracken_species.report -o ../data/reports/kraken2/${f}_k2_cat_bracken.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kraken2/${f}_k2_contigs.report -o ../data/reports/kraken2/${f}_k2_contigs_bracken.txt --no-intermediate-ranks --read_count --display-header;
done


#Combine each reort
for f in R1 R2 paired cat contigs;
do combine_mpa.py -i ../data/reports/kraken2/*_k2_${f}_bracken.txt -o ../data/reports/kraken2/combined_sp_${f}_bracken.txt;
done

#Selection only species
for f in R1 R2 paired cat contigs;
do grep -E "(s__)|(#Classification)" ../data/reports/kraken2/combined_sp_${f}_bracken.txt > ../data/reports/kraken2/${f}_kraken2.txt;
done


#move files to diversity reports
for f in paired R1 R2 cat contigs;
do cp ../data/reports/kraken2/${f}_kraken2.txt ../data/reports/diversity;
done
