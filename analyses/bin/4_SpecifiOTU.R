#! RScript


#010223
#Associated OTUs

#Libraries
library(phyloseq)
library(tidyverse)
library(Polychrome)
library(vegan)
library(indicspecies)
library(pheatmap)
library(mvabund)
library(iNEXT)

#Set working directory to source file location

#### We need the object phyloseq_rel with relative abundance
source("metabarcoding_phyloseq.R")

#####################Index OTU
SpOTU <- data.frame(otu_table(phyloseq_rel))
metadata <- as.data.frame(sample_data(phyloseq_rel))

#do some shuffling of the OTU table
SpOTUFlip <- as.data.frame(t(SpOTU)) #makes it a dataframe and puts x into y and y into x (flips it)
SpOTUFlip_num<-as.data.frame(lapply(SpOTUFlip, as.numeric)) #convert from character to number
SpOTUFlip_num$sample<-row.names(SpOTUFlip) #puts row names as sample ID column
#OK now we have the OTU table that's somewhat in the way they like

## Join based on SampleID
SpOTU_Final<- left_join(SpOTUFlip_num, metadata, by = c("sample" = "sample")) # join based on sample IDs, assuming they're the same for both OTU table and metadata

SPotus <-  SpOTU_Final[,1:259] #select just the ASV/OTU table part of the file (you may have to scroll to the back of the OTU file to find it...)
SPwat <-  SpOTU_Final$Condition #the metadata column group you care about

SPind <- multipatt(x=SPotus, cluster=SPwat, func="IndVal.g", control = how(nperm=9999))
summary(SPind)

bin <- as.data.frame(ifelse(SPotus>0,1,0))
phi <- multipatt(bin, SPwat, func = "r", control = how(nperm=999))
summary(phi)


#Same for RNA-Seq
#####################Index OTU
SpOTU <- data.frame(otu_table(phylo_rel_kra))
metadata <- as.data.frame(sample_data(phylo_rel_kra))
metadata <- subset(metadata, select= -sampleID)
metadata$sampleID <- row.names(metadata)

#do some shuffling of the OTU table
SpOTUFlip <- as.data.frame(t(SpOTU)) #makes it a dataframe and puts x into y and y into x (flips it)
SpOTUFlip_num<-as.data.frame(lapply(SpOTUFlip, as.numeric)) #convert from character to number
SpOTUFlip_num$sampleID<-row.names(SpOTUFlip) #puts row names as sample ID column

#OK now we have the OTU table that's somewhat in the way they like

## Join based on SampleID
SpOTU_Final<- left_join(SpOTUFlip_num, metadata, by = c("sampleID" = "sampleID")) # join based on sample IDs, assuming they're the same for both OTU table and metadata

SPotus <-  SpOTU_Final[,1:89] #select just the ASV/OTU table part of the file (you may have to scroll to the back of the OTU file to find it...)
SPwat <-  SpOTU_Final$Condition #the metadata column group you care about

SPind <- multipatt(x=SPotus, cluster=SPwat, func="IndVal.g", control = how(nperm=9999))
summary(SPind)

bin <- as.data.frame(ifelse(SPotus>0,1,0))
phi <- multipatt(bin, SPwat, func = "r", control = how(nperm=999))
summary(phi)