#Guild analyses

#Libraries
library(vegan)
library(tidyverse)

source("metabarcoding_phyloseq.R")
source("assign_guild.R")

#Guild table
guilt_table <-  assign_guild(object = phyloseq_rel, database="FungalTraits")   ### Polme et al. 2020, Fungal Diversity 105, 1-16

guilt_table$primary_lifestyle <- as.factor(guilt_table$primary_lifestyle)

sum(table(guilt_table$primary_lifestyle))
sum(is.na(guilt_table$primary_lifestyle))


met <- as.data.frame(psmelt(phyloseq_rel))
guilt_table <- rownames_to_column(guilt_table, var="OTU")

metguilds <- merge(guilt_table, met, by="OTU")

metguilds <- metguilds %>% 
  group_by(Sample,Condition, primary_lifestyle) %>% 
  summarise(counts=sum(Abundance))


metguilds$Condition <- as.factor(metguilds$Condition)

metguildm <- subset(metguilds, select=c(Sample, primary_lifestyle, counts))

metguildm <- pivot_wider(metguildm, names_from = primary_lifestyle, values_from = counts)
metguildm <- column_to_rownames(metguildm, var="Sample")

metguildm <- as.matrix(metguildm)

# Calculate Bray-Curtis dissimilarity matrix
bray_curtis_matrix <- vegdist(metguildm, method = "bray")

# View the Bray-Curtis dissimilarity matrix
print(bray_curtis_matrix)

condition <- metguilds %>% 
  group_by(Sample, Condition) %>% 
  summarise()

# Perform ANOSIM test
anosim_result <- anosim(bray_curtis_matrix, condition$Condition)

# View ANOSIM test results
print(anosim_result)

#RNA-Seq

#Guild table
guild_table_kra <-  assign_guild(object = phylo_rel_kra, database="FungalTraits")   ### Polme et al. 2020, Fungal Diversity 105, 1-16

guild_table_kra$primary_lifestyle <- as.factor(guild_table_kra$primary_lifestyle)

sum(table(guild_table_kra$primary_lifestyle))
sum(is.na(guild_table_kra$primary_lifestyle))


kra <- as.data.frame(psmelt(phylo_rel_kra))
guild_table_kra <- rownames_to_column(guild_table_kra, var="OTU")

kraguilds <- merge(guild_table_kra, kra, by="OTU")

kraguilds <- kraguilds %>% 
  group_by(Sample,Condition, primary_lifestyle) %>% 
  summarise(counts=sum(Abundance))


krapatho <- subset(kraguilds, primary_lifestyle=="plant_pathogen")

kraguilds$Condition <- as.factor(kraguilds$Condition)

kraguildm <- subset(kraguilds, select=c(Sample, primary_lifestyle, counts))

kraguildm <- pivot_wider(kraguildm, names_from = primary_lifestyle, values_from = counts)
kraguildm <- column_to_rownames(kraguildm, var="Sample")

kraguildm <- as.matrix(kraguildm)

# Calculate Bray-Curtis dissimilarity matrix
bray_curtis_matrix <- vegdist(kraguildm, method = "bray")

# View the Bray-Curtis dissimilarity matrix
print(bray_curtis_matrix)

condition <- kraguilds %>% 
  group_by(Sample, Condition) %>% 
  summarise()

# Perform ANOSIM test
anosim_result <- anosim(bray_curtis_matrix, condition$Condition)

# View ANOSIM test results
print(anosim_result)
