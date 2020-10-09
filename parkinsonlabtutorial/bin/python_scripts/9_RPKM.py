#!/usr/bin/env python

import os
import os.path
import sys
import shutil

nodes = sys.argv[1]
read2taxid = sys.argv[2]
gene2read = sys.argv[3]
EC2genes = sys.argv[4]
RPKM = sys.argv[5]
Cytoscape = sys.argv[6]

Rank_dict = {"2157": "Archaea", "2759": "Eukaryota", "2": "Bacteria", "201174": "Actinobacteria", "976": "Bacteroidetes", "1224": "Proteobacteria", "1236": "Gammaproteobacteria", "28216": "Betaproteobacteria", "28211": "Alphaproteobacteria", "1239": "Firmicutes", "91061": "Bacilli", "186801": "Clostridia", "31979": "Clostridiaceae", "186806": "Eubacteriaceae", "186803": "Lachnospiraceae", "216572": "Oscillospiraceae", "541000": "Ruminococcaceae"}

nodes_dict = {}
with open(nodes, "r") as infile:
    for line in infile:
        cols = line.split("\t|\t")
        taxid = cols[0]
        parent = cols[1]
        rank = cols[2]
        nodes_dict[taxid] = (parent, rank)
    else:
        nodes_dict["0"] = ("0", "unclassified")

read2taxid_dict = {}
with open(read2taxid, "r") as infile:
    for line in infile:
        cols = line.split("\t")
        read = cols[1]
        taxid = cols[2].strip("\n")
        while True:
            if taxid == "0" or taxid == "1":
                break
            if taxid in Rank_dict:
                read2taxid_dict[read] = taxid
                break
            else:
                taxid = nodes_dict[taxid][0]

mapped_reads = 0
gene2read_dict = {}
with open(gene2read, "r") as infile:
    for line in infile:
        cols = line.split("\t")
        gene = cols[0]
        gene_len = cols[1]
        reads = []
        for read in cols[3:]:
            reads.append(read.strip("\n"))
        mapped_reads += len(reads)
        gene2read_dict[gene] = (gene_len, reads)

EC2genes_dict = {}
with open(EC2genes, "r") as infile:
    for line in infile:
        cols = line.split("\t")
        EC = cols[0]
        genes = []
        for gene in cols[1:]:
            genes.append(gene.strip("\n"))
        EC2genes_dict[EC] = genes

RPKM_dict = {}
for gene in gene2read_dict:
    RPKM_div = ((float(gene2read_dict[gene][0])/float(1000))*(mapped_reads/float(1000000)))
    RPKM_dict[gene] = [gene2read_dict[gene][0], len(gene2read_dict[gene][1])]
    for EC in EC2genes_dict:
        if gene in EC2genes_dict[EC]:
            RPKM_dict[gene].append(EC)
            break
    else:
        RPKM_dict[gene].append("0.0.0.0")
    RPKM_dict[gene].append(len(gene2read_dict[gene][1])/RPKM_div)
    for taxa in Rank_dict:
        read_count = 0
        for read in gene2read_dict[gene][1]:
            try:
                if read2taxid_dict[read] == taxa:
                    read_count += 1
            except:
                pass
        else:
            RPKM_dict[gene].append(read_count/RPKM_div)
with open(RPKM, "w") as RPKM_out:
    RPKM_out.write("GeneID\tLenght\t#Reads\tEC#\tRPKM\tArchaea\tEukaryota\tBacteria\tActinobacteria\tBacteroidetes\tProteobacteria\tGammaproteobacteria\tBetaproteobacteria\tAlphaproteobacteria\tFirmicutes\tBacilli\tClostridia\tClostridiaceae\tEubacteriaceae\tLachnospiraceae\tOscillospiraceae\tRuminococcaceae\n")
    for entry in RPKM_dict:
        RPKM_out.write(entry + "\t" + "\t".join(str(x) for x in RPKM_dict[entry]) + "\n")

Cytoscape_dict = {}
for EC in EC2genes_dict:
    for entry in RPKM_dict:
        if RPKM_dict[entry][2] == EC:
            try:
                for index, RPKM_val in enumerate(Cytoscape_dict[EC]):
                    Cytoscape_dict[EC][index] += RPKM_dict[entry][3 + index]
            except:
                Cytoscape_dict[EC] = RPKM_dict[entry][3:]
    try:
        Cytoscape_dict[EC].append('''piechart: attributelist="Archaea,Eukaryota,Bacteria,Actinobacteria,Bacteroidetes,Proteobacteria,Gammaproteobacteria,Betaproteobacteria,Alphaproteobacteria,Firmicutes,Bacilli,Clostridia,Clostridiaceae,Eubacteriaceae,Lachnospiraceae,Oscillospiraceae,Ruminococcaceae" colorlist="#FFA500,#C0C0C0,#EDF252,#0000FF,#FF00FF,#2C94DE,#ED4734,#00FFFF,#FFCCFF,#34C400,#A52A2A,#663366,#F0FFFF,#AFCCFF,#F4C400,#F52A2A,#F63366" showlabels=false"''')
    except:
        pass
with open(Cytoscape, "w") as Cytoscape_out:
    Cytoscape_out.write("EC#\tRPKM\tArchaea\tEukaryota\tBacteria\tActinobacteria\tBacteroidetes\tProteobacteria\tGammaproteobacteria\tBetaproteobacteria\tAlphaproteobacteria\tFirmicutes\tBacilli\tClostridia\tClostridiaceae\tEubacteriaceae\tLachnospiraceae\tOscillospiraceae\tRuminococcaceae\tPiechart\n")
    for entry in Cytoscape_dict:
        Cytoscape_out.write(entry + "\t" + "\t".join(str(x) for x in Cytoscape_dict[entry]) + "\n")