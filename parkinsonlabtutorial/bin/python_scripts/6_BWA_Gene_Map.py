#!/usr/bin/env python

import sys
import os
import os.path
import shutil
import subprocess
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import re

DNA_DB = sys.argv[1]
contig2read_file = sys.argv[2]
gene2read_file = sys.argv[3]
gene_file = sys.argv[4]

contig2read_map = {}
contig2read_map_full = {}
contig_reads = []

with open(contig2read_file, "r") as mapping:
    for line in mapping:
        if len(line) > 5:
            entry = line.split("\t")
            contig2read_map_full[entry[0]] = entry[2:]
            for read in contig2read_map_full[entry[0]]:
                contig_reads.append(read.strip("\n"))
for contig in contig2read_map_full:
    for read in contig2read_map_full[contig]:
        if contig_reads.count(read) > 1:
            break
    else:
        contig2read_map[contig] = contig2read_map_full[contig]

gene2read_map = {}
mapped_reads = set()
prev_mapping_count = 0
for x in range((len(sys.argv) - 5) / 3):
    read_file = sys.argv[3 * x + 5]
    read_seqs = SeqIO.index(read_file, os.path.splitext(read_file)[1][1:])
    BWA_sam_file = sys.argv[3 * x + 6]
    output_file = sys.argv[3 * x + 7]

    unmapped_reads = set()
    unmapped_seqs = []

    def gene_map(sam, unmapped):
        with open(sam, "r") as samfile:
            len_chars = ["M","I","S","=","X"]
            for line in samfile:
                if not line.startswith("@") and len(line) > 1:
                    line_parts = line.split("\t")
                    query_seq = line_parts[0]
                    db_match = line_parts[2]
                    flag = bin(int(line_parts[1]))[2:].zfill(11)
                    if query_seq in contig2read_map_full:
                        if query_seq in contig2read_map:
                            contig = True
                        else:
                            unmapped_reads.add(query_seq)
                            continue
                    else:
                        contig = False
                    if flag[8] == "0":
                        CIGAR = re.split("([MIDNSHPX=])", line_parts[5])
                        length = 0
                        matched = 0
                        for index, entry in enumerate(CIGAR):
                            if index + 1 == len(CIGAR):
                                break
                            if CIGAR[index + 1] in len_chars:
                                length += int(CIGAR[index])
                            if CIGAR[index + 1] == "M":
                                matched += int(CIGAR[index])
                        if matched > length * 0.9:
                            if db_match in gene2read_map:
                                if contig:
                                    for read in contig2read_map[query_seq]:
                                        gene2read_map[db_match].append(read)
                                        mapped_reads.add(read)
                                elif not contig:
                                    if query_seq in contig_reads:
                                        continue
                                    elif query_seq in mapped_reads:
                                        unmapped_reads.add(query_seq)
                                        for gene in gene2read_map:
                                            if query_seq in gene2read_map[gene]:
                                                if len(gene2read_map[gene]) == 1:
                                                    del gene2read_map[gene]
                                                else:
                                                    gene2read_map[gene].remove(query_seq)
                                                break
                                    else:
                                        gene2read_map[db_match].append(query_seq)
                                        mapped_reads.add(query_seq)
                            else:
                                if contig:
                                    gene2read_map[db_match] = contig2read_map[query_seq]
                                    for read in contig2read_map[query_seq]:
                                        mapped_reads.add(read)
                                elif not contig:
                                    if query_seq in mapped_reads:
                                        unmapped_reads.add(query_seq)
                                        for gene in gene2read_map:
                                            if query_seq in gene2read_map[gene]:
                                                if len(gene2read_map[gene]) == 1:
                                                    del gene2read_map[gene]
                                                else:
                                                    gene2read_map[gene].remove(query_seq)
                                                break
                                    else:
                                        gene2read_map[db_match] = [query_seq]
                                        mapped_reads.add(query_seq)
                    elif flag[8] == "1":
                        unmapped.add(query_seq)

    gene_map(BWA_sam_file, unmapped_reads)

    for read in unmapped_reads:
        unmapped_seqs.append(read_seqs[read])

    with open(output_file, "w") as out:
        SeqIO.write(unmapped_seqs, out, "fasta")
    
    print str(len(mapped_reads) - prev_mapping_count) + " reads were mapped from " + os.path.basename(read_file)
    prev_mapping_count = len(mapped_reads)

genes = []
with open(gene2read_file, "w") as out_map:
        for record in SeqIO.parse(DNA_DB, "fasta"):
            if record.id in gene2read_map:
                genes.append(record)
                out_map.write(record.id + "\t" + str(len(record.seq)) + "\t" + str(len(gene2read_map[record.id])))
                for read in gene2read_map[record.id]:
                    out_map.write("\t" + read.strip("\n"))
                else:
                    out_map.write("\n")
                    
with open(gene_file, "w") as out_gene:
    SeqIO.write(genes, out_gene, "fasta")

print "Sequences mapped to %d genes." % (len(genes))