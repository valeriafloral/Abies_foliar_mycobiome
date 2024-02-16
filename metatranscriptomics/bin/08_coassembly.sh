# -S /bin/bash
# -N Trinity
# -cwd
# -o outs/trinity.out
# -e outs/trinity.err
source /etc/bashrc

data=$(ls data/*.fastq | sed 's/.fastq//g'  | sed 's/data\///g' | sed 's/_*..$//g' | sort -u)
Trinity  --seqType fq --samples_file data/samples.txt --jaccard_clip --output results/03.Trinity --full_cleanup  --CPU 60 --max_memory 250G

#Assemblies Stats

#create output directory
mkdir -p results/04.QC_assemblies_stats

#Define in and out path variables
OUT="/data2/PEG/hoaxaca/vale/results/04.QC_assemblies_stats"
FASTAS=$(ls /data2/PEG/hoaxaca/vale/results/03.Trinity_Assemblies/*.fasta)

#Run stats command
echo "assemblies statistics"
for fasta in `ls $FASTAS`; do
stats='TrinityStats.pl  '$fasta''
echo $stats
$stats
done
