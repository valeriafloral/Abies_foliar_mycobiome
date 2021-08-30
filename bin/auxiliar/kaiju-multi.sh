#Parse Kaiju outputs

#List with samples name
declare -a samples=("DPVR1_S179" "DPVR2_S180" "DPVR3_S181" "DPVR4_S182" "DPVR5_S183" "DPVR11_S189" "DPVR12_S190" "DPVR13_S191" "DPVR17_S195" "DPVR6_S184" "DPVR7_S185" "DPVR8_S186" "DPVR9_S187" "DPVR10_S188" "DPVR14_S192" "DPVR15_S193" "DPVR16_S194" "DPVR18_S196")

for samples in ${samples[@]};
do wc -l ${samples}_cat_kaiju.tsv;
done


for samples in ${samples[@]};
do cat ${samples}_cat_kaiju.tsv > reads_kaiju.tsv;
done


for samples in ${samples[@]};
do cat ${samples}_contigs_kaiju.tsv > contigs_kaiju.tsv;
done

cat *_contigs_kaiju.tsv > contigs_kaiju.tsv
