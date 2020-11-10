#!/share/apps/anaconda/bin/python

import sys
import os
import os.path
import shutil
import subprocess
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

sequence_file = sys.argv[1]
sequences = list(SeqIO.parse(sequence_file, "fastq"))
Infernal_out = sys.argv[2]
mRNA_file = sys.argv[3]
rRNA_file = sys.argv[4]

Infernal_rRNA_IDs = set()

mRNA_seqs = set()
rRNA_seqs = set()

# Original implementation had a bug, may be it was implemented for a previous version.
# Declare these lists just for testing proposses
# FIXME: Implement a more efficient method to avoid search on a list each time an insertion occur.
mRNA_list = list()
rRNA_list = list()
rRNA_IDs= list()

with open(Infernal_out, "r") as infile_read:
    for line in infile_read:
        if not line.startswith("#") and len(line) > 10:
            Infernal_rRNA_IDs.add(line[:line.find(" ")].strip())



for sequence in sequences:
    if sequence.id in Infernal_rRNA_IDs:
        if sequence.id not in rRNA_IDs:
            rRNA_IDs.append(sequence.id)
            rRNA_list.append(sequence)	
            #rRNA_seqs.add(sequence)
    else:
        mRNA_list.append(sequence)
        #mRNA_seqs.add(sequence)

#print "IDs comparison"
#print rRNA_IDs

with open(mRNA_file, "w") as out:
    SeqIO.write(list(mRNA_list), out, "fastq")

with open(rRNA_file, "w") as out:
    SeqIO.write(list(rRNA_list), out, "fastq")

print (str(len(rRNA_list)) + " reads were aligned to the rRNA database")
print (str(len(mRNA_list)) +  " reads were not aligned to the rRNA database")
