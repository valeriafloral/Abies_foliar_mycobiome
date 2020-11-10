#!/usr/bin/env python

import sys
import os
import os.path
import shutil
import subprocess
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

target_rank = sys.argv[1]
classification_file = sys.argv[2]
nodes_file = sys.argv[3]
names_file = sys.argv[4]
consensus_classification_file = sys.argv[5]

nodes = {}
with open(nodes_file, "r") as infile:
    for line in infile:
        cols = line.split("\t|\t")
        taxid = cols[0]
        parent = cols[1]
        rank = cols[2]
        nodes[taxid] = (parent, rank)
    else:
        nodes["0"] = ("0", "unclassified")

names = {}
with open(names_file, "r") as infile:
    for line in infile:
        cols = line.split("\t|\t")
        taxid = cols[0]
        name = cols[1]
        if "scientific name" in cols[3]:
            names[taxid] = name
    else:
        names["0"] = "unclassified"

Ranks = ["unclassified", "superkingdom", "phylum", "subphylum", "class", "subclass", "superorder", "order", "suborder", "superfamily", "family", "subfamily", "genus", "subgenus", "species", "subspecies"]

read_classifications = {}
classification_count = {}
with open(classification_file, "r") as infile:
    for line in infile:
        cols = line.split("\t")
        read = cols[1]
        taxid = cols[2].strip()
        if taxid != "0" and taxid in nodes:
            while True:
                if taxid == "1":
                    read_classifications[read] = (taxid, names[taxid])
                    break
                if nodes[taxid][1] in Ranks:
                    if Ranks.index(nodes[taxid][1]) > Ranks.index(target_rank):
                        taxid = nodes[taxid][0]
                    else:
                        read_classifications[read] = (taxid, names[taxid])
                        break
                else:
                    taxid = nodes[taxid][0]
        else:
            read_classifications[read] = ("0", names["0"])

with open(consensus_classification_file, "w") as outfile:
    for read in read_classifications:
        if read_classifications[read][0] == "0":
            outfile.write("U\t" + read + "\t" + read_classifications[read][0] + "\n")
        else:
            outfile.write("C\t" + read + "\t" + read_classifications[read][0] + "\n")