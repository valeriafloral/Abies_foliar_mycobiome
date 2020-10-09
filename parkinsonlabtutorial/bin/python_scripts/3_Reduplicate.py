#!/usr/bin/env python

import sys
import os
import os.path
import shutil
import subprocess
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

reference_file = sys.argv[1]
reference_sequences = SeqIO.to_dict(SeqIO.parse(reference_file, "fastq"))
dedeplicated_file = sys.argv[2]
dedeplicated_sequences = SeqIO.index(dedeplicated_file, "fastq")
cluster_file = sys.argv[3]
cluster_map = {}
reduplicated_file = sys.argv[4]
reduplicated_ids = set()
reduplicated_seqs = []

with open(cluster_file, "r") as clustr_read:
    rep = ""
    seq_id = ""
    for line in clustr_read:
        if line.startswith(">"):
            continue
        elif line.startswith("0"):
            rep = line[line.find(">") + 1:line.find("...")]
            seq_id = rep
            cluster_map[rep] = [seq_id]
        elif len(line) > 5:
            seq_id = line[line.find(">") + 1:line.find("...")]
            cluster_map[rep].append(seq_id)

for sequence in dedeplicated_sequences:
    if len(cluster_map[sequence]) > 1:
        for seq_id in cluster_map[sequence]:
            reduplicated_ids.add(seq_id)
    else:
        reduplicated_ids.add(sequence)

reduplicated_seqs = [reference_sequences[seq_id] for seq_id in sorted(reduplicated_ids)]

with open(reduplicated_file, "w") as out:
    SeqIO.write(reduplicated_seqs, out, "fastq")

print str(len(dedeplicated_sequences)) + " dereplicated reads produce " + str(len(reduplicated_seqs)) + " rereplicated reads."