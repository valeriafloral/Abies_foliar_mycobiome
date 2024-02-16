#Libraries
library(phyloseq)
library(tidyverse)
library(Polychrome)
library(vegan)
library(indicspecies)
library(pheatmap)
library(mvabund)
library(iNEXT)
library(MASS)

#Set working directory to source file location

#### We need the object phyloseq_rel with relative abundance
source("metabarcoding_phyloseq.R")

###Community characterization
#alpha index (Observed richness)

#Evaluate richness of every sample in the phyloseq object and create a dataframe
richness_metabarcoding<- data.frame(
  "Observed" = phyloseq::estimate_richness(phyloseq_rel, measures = "Observed"),
  "Condition" = phyloseq::sample_data(phyloseq_rel)$Condition)

#Set Condition as factor
richness_metabarcoding$Condition <- as.factor(richness_metabarcoding$Condition)

#Models of observed richnness and Condition 
res1 <- glm(Observed~1, data=richness_metabarcoding, family = poisson(link = "log"))
res2 <- glm(Observed~Condition, data=richness_metabarcoding, family = poisson(link = "log"))

# Perform chi-square test
chi_sq_test <- anova(res1, res2, test = "Chisq")

# Print the results
print(chi_sq_test)


###Community characterization
#alpha index (Observed richness)

#Evaluate richness of every sample in the phyloseq object and create a dataframe
richness_rnaseq<- data.frame(
  "Observed" = phyloseq::estimate_richness(phylo_rel_kra, measures = "Observed"),
  "Condition" = phyloseq::sample_data(phylo_rel_kra)$Condition)

#Set Condition as factor
richness_rnaseq$Condition <- as.factor(richness_rnaseq$Condition)

#Set Condition as factor
richness_rnaseq$Condition <- as.factor(richness_rnaseq$Condition)

#Models of observed richnness and Condition 
res1 <- glm(Observed~1, data=richness_rnaseq, family = poisson(link = "log"))
res2 <- glm(Observed~Condition, data=richness_rnaseq, family = poisson(link = "log"))

# Perform chi-square test
chi_sq_test <- anova(res1, res2, test = "Chisq")

# Print the results
print(chi_sq_test)