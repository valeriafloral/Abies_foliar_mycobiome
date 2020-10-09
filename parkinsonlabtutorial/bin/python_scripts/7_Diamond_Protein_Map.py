#!/usr/bin/env python

import sys
import os
import os.path
import shutil
import subprocess
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import re

Prot_DB = sys.argv[1]
contig2read_file = sys.argv[2]
gene2read_file = sys.argv[3]
prot_file = sys.argv[4]

contig2read_map = {}

with open(contig2read_file, "r") as mapping:
    for line in mapping:
        if len(line) > 5: 
            entry = line.strip("\n").split("\t")
            contig2read_map[entry[0]] = entry[2:]

gene2read_map = {}
gene_len = {}
mapped_reads = set()

with open(gene2read_file, "r") as mapping:
    for line in mapping:
        if len(line) > 5:
            entry = line.split("\t")
            gene2read_map[entry[0]] = entry[3:]
            gene_len[entry[0]] = entry[1]

def sortbyscore(line):
    return line[11]

for x in range((len(sys.argv) - 5) / 3):
    read_file = sys.argv[3 * x + 5]
    read_seqs = SeqIO.index(read_file, os.path.splitext(read_file)[1][1:])
    DMND_tab_file = sys.argv[3 * x + 6]
    output_file = sys.argv[3 * x + 7]

    unmapped_reads = set()
    unmapped_seqs = []

    def gene_map(tsv, unmapped):
        with open(tsv, "r") as tabfile:
            query = ""
            identity_cutoff = 85
            length_cutoff = 0.65
            score_cutoff = 60
            Hits = []
            for line in tabfile:
                if len(line) < 2:
                    continue
                else:
                    Hits.append(line.split("\t"))
            Sorted_Hits = sorted(Hits, key = sortbyscore)
            for line in Sorted_Hits:
                if query in contig2read_map:
                    contig = True
                else:
                    contig = False
                if query == line[0]:
                    continue
                else:
                    query = line[0]
                    db_match = line[1]
                    seq_identity = line[2]
                    align_len = line[3]
                    score = line[11]
                if float(seq_identity) > float(identity_cutoff):
                    if align_len > len(read_seqs[query].seq) * length_cutoff:
                        if float(score) > float(score_cutoff):
                            if db_match in gene2read_map:
                                if contig:
                                    for read in contig2read_map[query]:
                                        if read not in gene2read_map[db_match]:
                                            if read not in mapped_reads:
                                                gene2read_map[db_match].append(read)
                                                mapped_reads.add(read)
                                elif not contig:
                                    if query not in gene2read_map[db_match]:
                                        gene2read_map[db_match].append(query)
                                        mapped_reads.add(query)
                            else:
                                if contig:
                                    read_count = 0
                                    for read in contig2read_map[query]:
                                        if read not in mapped_reads:
                                            mapped_reads.add(read)
                                            read_count += 1
                                            if read_count == 1:
                                                gene2read_map[db_match] = [read]
                                            elif read_count > 1:
                                                gene2read_map[db_match].append(read)
                                elif not contig:
                                    gene2read_map[db_match] = [query]
                                    mapped_reads.add(query)
                            continue
                unmapped.add(query)

    gene_map(DMND_tab_file, unmapped_reads)

    for read in read_seqs:
        if read not in unmapped_reads:
            for gene in gene2read_map:
                if read in gene2read_map[gene]:
                    mapped_reads.add
            else:
                unmapped_reads.add(read)

    for read in unmapped_reads:
        unmapped_seqs.append(read_seqs[read])
    with open(output_file, "w") as outfile:
        SeqIO.write(unmapped_seqs, outfile, "fasta")

reads_count = 0
proteins = []
with open(gene2read_file, "w") as out_map:
    for gene in gene2read_map:
        try:
            out_map.write(gene + "\t" + gene_len[gene] + "\t" + str(len(gene2read_map[gene])))
            for read in gene2read_map[gene]:
                out_map.write("\t" + read.strip("\n"))
            else:
                out_map.write("\n")
        except:
            pass
    for record in SeqIO.parse(Prot_DB, "fasta"):
        if record.id in gene2read_map:
            proteins.append(record)
            out_map.write(record.id + "\t" + str(len(record.seq) * 3) + "\t" + str(len(gene2read_map[record.id])))
            for read in gene2read_map[record.id]:
                out_map.write("\t" + read.strip("\n"))
                reads_count += 1
            else:
                out_map.write("\n")

with open(prot_file, "w") as out_prot:
    SeqIO.write(proteins, out_prot, "fasta")

print str(reads_count) + " reads were mapped with Diamond"
print "Sequences mapped to %d proteins." % (len(proteins))