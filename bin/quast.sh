for f in `ls ../data/assembly | grep "_assembly" | sed "s/_assembly//" | uniq`;
do quast.py -t 4 ../data/assembly/${f}_assembly/transcripts.fasta -o ../data/reports/assembly/${f};
done
