#!/usr/bin/env python

import os
import os.path
import sys
import shutil

Swiss_prot_map = sys.argv[1]
Gene_file = sys.argv[2]
Prot_file = sys.argv[3]
Gene_EC_map = sys.argv[4]

mapping_dict = {}
with open(Swiss_prot_map, "r") as mapping:
    for line in mapping:
        line_as_list = line.strip("\n").split("\t")
        mapping_dict[line_as_list[0]] = set(line_as_list[2:])

EC2Gene = {}
def db_hits(dmnd_out, EC_map):
    with open(dmnd_out, "r") as diamond:
        for line in diamond:
            line_as_list = line.strip("\n").split("\t")
            for EC in mapping_dict:
                if line_as_list[1] in mapping_dict[EC]:
                    try:
                        EC_map[EC].append(line_as_list[0])
                    except:
                        EC_map[EC] = [line_as_list[0]]

db_hits(Gene_file, EC2Gene)
db_hits(Prot_file, EC2Gene)

gene_count = 0
with open(Gene_EC_map, "w") as ec_out:
    for EC in EC2Gene:
        ec_out.write(EC)
        for Gene in EC2Gene[EC]:
            ec_out.write("\t" + Gene)
            gene_count += 1
        else:
            ec_out.write("\n")

print str(gene_count) + " genes were mapped with Diamond to " + str(len(EC2Gene)) + " unique enzyme functions."