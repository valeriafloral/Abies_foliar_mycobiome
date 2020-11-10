#!/usr/bin/env python

import sys
import os
import os.path
import shutil
import subprocess
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

read_file = sys.argv[1]
read_seqs = SeqIO.index(read_file, "fastq")
sam_file = sys.argv[2]
output_file = sys.argv[3]
output_map = sys.argv[4]

contig2read_map = {}
unmapped_reads = set()
unmapped_seqs = []

def contig_map(sam, unmapped):
    with open(sam, "r") as samfile:
        for line in samfile:
            if not line.startswith("@") and len(line) > 1:
                line_parts = line.split("\t")
                flag = bin(int(line_parts[1]))[2:].zfill(11)
                if flag[8] == "0":
                    if line_parts[2] in contig2read_map:
                        if line_parts[0] not in contig2read_map[line_parts[2]]:
                            contig2read_map[line_parts[2]].append(line_parts[0])
                    else:
                        contig2read_map[line_parts[2]] = [line_parts[0]]
                elif flag[8] == "1":
                    unmapped.add(line_parts[0])

contig_map(sam_file, unmapped_reads)

for read in unmapped_reads:
    unmapped_seqs.append(read_seqs[read])
with open(output_file, "w") as out:
    SeqIO.write(unmapped_seqs, out, "fastq")

with open(output_map, "w") as outfile:
    for contig in contig2read_map:
        outfile.write(contig + "\t" + str(len(contig2read_map[contig])))
        for read in contig2read_map[contig]:
            outfile.write("\t" + read)
        else:
            outfile.write("\n")

print str(len(read_seqs)-len(unmapped_seqs)) + " reads were aligned to the assemblies"
print str(len(unmapped_seqs)) +  " reads were not aligned to the assemblies"