#$ -S /bin/bash
#$ -N Salmon
#$ -cwd
#$ -o outs/salmon_orf.out
#$ -e outs/salmon_orf.err
source /etc/bashrc

#For ORF

#INDEX
ORF_PATH="/data2/PEG/hoaxaca/vale/results/05.Protein_prediction"

INDEX='salmon index --index orf --transcripts '$ORF_PATH'/orf.fasta'

$INDEX


#mkdir results/06.Salmon_orf_quant


for sample in `ls data/*.fastq | sed 's/.fastq//g'  | sed 's/data\///g' | sed 's/_*..$//g' | sort -u`;
do salmon quant -i orf -p 2 -l A -1 data/${sample}_R1.fastq -2 data/${sample}_R2.fastq -o results/06.Salmon_orf_quant/${sample}ORF_quant;
done
