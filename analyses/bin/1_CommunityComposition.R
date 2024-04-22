#Load function to assign guilds
library(microbiome)
library(tidyverse)
library(DescTools)
library(phyloseq)
library(Polychrome)

source("metabarcoding_phyloseq.R")


###NMDS
#Transform to binary
bin_table <-  transform_sample_counts(phyloseq_rel, function(x, minthreshold=0){
  x[x > minthreshold] <- 1
  return(x)})

head(otu_table(bin_table))

# Remove OTUs that appear only in 1 sample (using presence/absence)
any(taxa_sums(bin_table) == 1)
otu_table(prune_taxa(taxa_sums(bin_table) <= 1, bin_table))
bin_table <- prune_taxa(taxa_sums(bin_table) > 1, bin_table)
any(taxa_sums(bin_table) == 1)

bin_table

#Calculate distance
set.seed(4235421)
raup_dist <- phyloseq::distance(bin_table, method="raup")
phylo_rel_nmds<- ordinate(bin_table, method = "NMDS", distance = raup_dist)

cat("stress is:", phylo_rel_nmds$stress)

## testing of significance for raup crick ordinations using ANOSIM
# create vector with condition labels for each samples
condition <- get_variable(bin_table, "Condition")
sampledf <- data.frame(sample_data(bin_table))

# Adonis test
m1 <- anosim(raup_dist, sampledf$Condition, permutations = 999)
m1

adonis2(raup_dist~ Condition, data = sampledf)


#NMDS Plot
nmds_metabarcoding <- plot_ordination(bin_table, phylo_rel_nmds, type= "samples", color = "Condition") + 
  geom_point(size = 4) +
  theme_bw() + 
  theme(legend.position = "none")+
  ggtitle("NMDS+Raup-Crick Stress=0.14")+
  scale_color_manual(values = c("darkolivegreen", "chocolate3"))


pdf("../NuevasFig/nmds_meta.pdf", height=1000/300, width=1000/300)
nmds_metabarcoding 
dev.off()

#RNA-Seq
###NMDS
#Transform to binary
bin_table <-  transform_sample_counts(phylo_rel_kra, function(x, minthreshold=0){
  x[x > minthreshold] <- 1
  return(x)})

head(otu_table(bin_table))

# Remove OTUs that appear only in 1 sample (using presence/absence)
any(taxa_sums(bin_table) == 1)
otu_table(prune_taxa(taxa_sums(bin_table) <= 1, bin_table))
bin_table <- prune_taxa(taxa_sums(bin_table) > 1, bin_table)

bin_table

#Calculate distance
set.seed(4235421)
raup_dist <- phyloseq::distance(bin_table, method="raup")
phylo_rel_nmds<- ordinate(bin_table, method = "NMDS", distance = raup_dist)

cat("stress is:", phylo_rel_nmds$stress)

## testing of significance for raup crick ordinations using ANOSIM
# create vector with condition labels for each samples
condition <- get_variable(bin_table, "Condition")
sampledf <- data.frame(sample_data(bin_table))

# Adonis test
m1 <- anosim(raup_dist, sampledf$Condition, permutations = 999)
m1
summary(m1)

adonis2(raup_dist~ Condition, data = sampledf)

#NMDS Plot
nmds_rna <- plot_ordination(bin_table, phylo_rel_nmds, type= "samples", color = "Condition") + 
  geom_point(size = 4)+
  theme_bw() + 
  theme(legend.position = "none")+
  ggtitle("NMDS+Raup-Crick Stress= 0.00009")+
  scale_color_manual(values = c("darkolivegreen", "chocolate3"))
nmds_rna


pdf("../NuevasFig/nmds_rna.pdf", height=1000/300, width=1000/300)
nmds_rna
dev.off()
