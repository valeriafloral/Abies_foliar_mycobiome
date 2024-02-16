#! RScript

#Valeria Flores
#phyloseq object of metabarcoding dataset


#Libraries
library(phyloseq)
library(tidyverse)

#All scripts have to be in bin folder, all data have to be in data 
#Working directory has to be in bin in order to run 
#This script generates the object phyloseq_tables_cleaned without low abundance taxa and without negative control
#This script generates the object phyloseq_rel that is the phyloseq_tables_cleaned transformed to relative abundance 

#Import Metabarcoding data

#load in biom, tree file and metadata
phyloseq_tables <- import_biom('../data/taxonomy.biom', "../data/taxonomy.tree.phy")
sample_data<-read.csv("../data/amptk.mapping_file.csv")

#Wrangling metadata table
sample_data <- sample_data %>% 
  mutate(sample= X.SampleID) %>% 
  column_to_rownames(var = "X.SampleID")
metadata_matrix = (as(sample_data(sample_data), "matrix"))
metadata_df = as.data.frame(metadata_matrix)
metadata_df$Dataset <- rep("Metabarcoding")
metadata_df$classifier_data <- rep("Metabarcoding")
rownames(metadata_df)
colnames(metadata_df)
names(metadata_df)[names(metadata_df) == "Treatment"] <- "Condition"
metadata_df <- metadata_df %>%  #Add information about individuals
  mutate(individual= case_when(str_detect(sample, "DLS01") ~ 'A1',
                               str_detect(sample, "DLS02") ~ 'A2',
                               str_detect(sample, "DLS03") ~ 'A3',
                               str_detect(sample, "DLS04") ~ 'A4',
                               str_detect(sample, "DLS05") ~ 'A5',
                               str_detect(sample, "DLD01") ~ 'S1',
                               str_detect(sample, "DLD02") ~ 'S2',
                               str_detect(sample, "DLD03") ~ 'S3',
                               str_detect(sample, "DLD04") ~ 'S4',
                               str_detect(sample, "DLD05") ~ 'S5')) %>% 
  dplyr::mutate(Condition = gsub("Tolerant", "Asymptomatic", Condition)) %>%  #Change Condition for Symptomatic and asymptomatic
  dplyr::mutate(Condition = gsub("Damaged", "Symptomatic", Condition))


#Create phyloseq file with wrangled metadata
phyloseq_tables <- phyloseq(otu_table(phyloseq_tables, taxa_are_rows=TRUE), 
                            sample_data(metadata_df), 
                            tax_table(phyloseq_tables))

#Set rank names
colnames(tax_table(phyloseq_tables)) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species") # change names of taxonomic table
rank_names(phyloseq_tables) # check changes

#Control filter (delete negative and positive samples)

#move phyloseq_tables to a dataframe to subtract things
PCR_batch_matrix <-  otu_table(phyloseq_tables, "matrix")
PCR_batch_matrix
PCR_batch_df <-  as.data.frame(PCR_batch_matrix)
row.names(PCR_batch_df)
colnames(PCR_batch_df)

#Remove POS2
PCR_batch_df$POS2 <- NULL

# Create a vector from the Negative control
NEG <- as.vector(PCR_batch_df$`NEG2`)
NEG

#Insert the vector into a matrix
test1 <- cbind(NEG)
test1

# Replicate the column for the number of samples
test2 <-  test1[,rep(1,11)]
test2

#Subtract values from original matrix using the matrix based on repetition of negative control 
PCRbatch1_clean<-PCR_batch_df-test2
PCRbatch1_clean

# replace all negative numbers with 0, since we can't have negative seqs reads 
PCRbatch1_cleaned <- replace(PCRbatch1_clean, PCRbatch1_clean < 0, 0)
PCRbatch1_cleaned[,1] # check that it worked


#dataframe from taxa table
taxdata_matrix <-  (as(tax_table(phyloseq_tables), "matrix"))
taxdata_matrix
taxdata_df <- as.data.frame(taxdata_matrix)

categories <- unique(taxdata_df$Species) 
numberOfCategories <- length(categories)

#Edit names
taxdata_df <- taxdata_df %>%
  dplyr::mutate(Kingdom= gsub("k__", "", Kingdom)) %>%
  dplyr::mutate(Phylum = gsub("p__", "", Phylum)) %>%
  dplyr::mutate(Class= gsub("c__", "", Class)) %>%
  dplyr::mutate(Order = gsub("o__", "", Order)) %>%
  dplyr::mutate(Family= gsub("f__", "", Family)) %>%
  dplyr::mutate(Genus= gsub("g__", "", Genus)) %>%
  dplyr::mutate(Species= gsub("s__", "", Species))


#Fill empty rows
taxdata_df[taxdata_df==""] <- NA

#Make matrix for otu and taxonomy table
otu <- as.data.frame(PCRbatch1_cleaned)
tax_mat <- as.matrix(taxdata_df)
otu_mat <- as.matrix(otu)

# Reimport the clean otu table (matrix), meta data (data frame) and tax table (matrix) into a new phylseq objectttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt
phyloseq_tables_cleaned <- phyloseq(otu_table(otu_mat, taxa_are_rows=TRUE), 
                                    sample_data(metadata_df), 
                                    tax_table(tax_mat))

# Check the object to make sure all the samples and OTUs came back (neg is empty and positive was reoved)
phyloseq_tables_cleaned
phyloseq_tables

# Clean out OTUs rows that are no longer present.
phyloseq_tables_cleaned <- prune_taxa(taxa_sums(phyloseq_tables_cleaned) > 0, phyloseq_tables_cleaned)

# Clean out samples that are now empty (negative samples)
phyloseq_tables_cleaned <- prune_samples(sample_sums(phyloseq_tables_cleaned) > 0, phyloseq_tables_cleaned)

# Check the objects again
phyloseq_tables_cleaned
phyloseq_tables

#Check if any OTUs have zero reads in any sample
any(taxa_sums(phyloseq_tables_cleaned) == 0)

# Read counts before and after cleaning 
taxa_sums(phyloseq_tables_cleaned)
sum(taxa_sums(phyloseq_tables_cleaned)) # total number of reads: 245550
sum(taxa_sums(phyloseq_tables)) # total number of reads: 336962


#Transform read counts into  % relative abundances: because of concerns about rarefying NGS data
#Multiply by 1000 and transform to next integer so it looks like read count:

phyloseq_rel <-  transform_sample_counts(phyloseq_tables_cleaned, function(x) 1000 * x/sum(x))
otu_table(phyloseq_rel) = ceiling(otu_table(phyloseq_rel, "matrix")) # transform to next integer so it looks like read count
otu_table(phyloseq_rel) # check otu table
phyloseq_rel # check project
sample_data(phyloseq_rel)



#load in biom from RNA-Seq taxonomic classification
biom <- import_biom('../data/table.biom')

#import metadata
meta_all <-  read.csv ("../data/metadata_short.csv",
                       check.names = FALSE,
                       header = TRUE,
                       comment.char = "")
rownames(meta_all) <- meta_all$sampleID
meta_all$Dataset <- rep("RNA-Seq")


#Create phyloseq file
rna_all <- phyloseq(otu_table(biom, taxa_are_rows=TRUE), 
                    sample_data(meta_all), 
                    tax_table(biom))

colnames(tax_table(rna_all)) <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species") # change names of taxonomic table
ntaxa(rna_all)
sample_data(rna_all)



#Kraken reads
###Subset
kra_phylo <- subset_samples(rna_all, classifier_data=="kraken2_reads")
meta_kra <- as.matrix(sample_data(kra_phylo)) 
meta_kra_df <- as.data.frame(meta_kra)
meta_kra_df <- rownames_to_column(meta_kra_df, var = "sampleID2")
names(meta_kra_df)[names(meta_kra_df) == "condition"] <- "Condition"
kra_metadata <- meta_kra_df %>% 
  filter(grepl('kraken2_reads', classifier_data)) %>%
  dplyr::mutate(sampleID2 = gsub("_k2_reads", "", sampleID)) %>% 
  dplyr::mutate(Condition = gsub("Tolerant", "Asymptomatic", Condition)) %>% 
  dplyr::mutate(Condition = gsub("Damaged", "Symptomatic", Condition)) %>% 
  mutate(individual = case_when(str_detect(sampleID2, "R1_") ~ 'A1',
                                str_detect(sampleID2, "R2_") ~ 'A2',
                                str_detect(sampleID2, "R3_") ~ 'A3',
                                str_detect(sampleID2, "R4_") ~ 'A4',
                                str_detect(sampleID2, "R5_") ~ 'A5',
                                str_detect(sampleID2, "R6_") ~ 'S1',
                                str_detect(sampleID2, "R7_") ~ 'S2',
                                str_detect(sampleID2, "R8_") ~ 'S3',
                                str_detect(sampleID2, "R9_") ~ 'S4',
                                str_detect(sampleID2, "R10_") ~ 'S5')) %>% 
  column_to_rownames(var= "sampleID2")

#Taxonomy
taxdata_rna <- as.matrix(tax_table(kra_phylo))
taxdata_rna_df <- as.data.frame(taxdata_rna)

#Edit names
taxdata_rna_df <- taxdata_rna_df %>%
  dplyr::mutate(Kingdom= gsub("k__", "", Kingdom)) %>%
  dplyr::mutate(Phylum = gsub("p__", "", Phylum)) %>%
  dplyr::mutate(Class= gsub("c__", "", Class)) %>%
  dplyr::mutate(Order = gsub("o__", "", Order)) %>%
  dplyr::mutate(Family= gsub("f__", "", Family)) %>%
  dplyr::mutate(Genus= gsub("g__", "", Genus)) %>%
  dplyr::mutate(Species= gsub("s__", "", Species)) 

#Fill empty rows
taxdata_rna_df$Species[taxdata_rna_df$Species ==""] <- "sp."

#Fill empty rows
taxdata_rna_df[taxdata_rna_df ==""] <- NA

#Join Genus and Species
taxjoined <- taxdata_rna_df %>% 
  unite(Species, Genus:Species, remove= FALSE, sep=" ")

#Fix order

col_order <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
taxdata_rna_df <- taxjoined[,col_order]
taxdata_rna_df <- taxdata_rna_df %>% 
  mutate(Species= gsub("NA sp.", NA, Species)) 



tax_kra <- as.matrix(taxdata_rna_df)

#OTUtable
otu_kra <- as.matrix(otu_table(kra_phylo)) 
otu_kra_df <- as.data.frame(otu_kra)

for ( col in 1:ncol(otu_kra_df)){
  colnames(otu_kra_df)[col] <-  sub("_k2_reads", "", colnames(otu_kra_df)[col])
} 

otu_kra <- as.matrix(otu_kra_df)

#New phyloseq object
kra <- phyloseq(otu_table(otu_kra, taxa_are_rows = TRUE), 
                sample_data(kra_metadata), 
                tax_table(tax_kra))



# Clean out OTUs rows that are no longer present.
kra <- prune_taxa(taxa_sums(kra) > 0, kra)

# Clean out samples that are now empty (negative samples)
kra <- prune_samples(sample_sums(kra) > 0, kra)

tax_table(kra)[,colnames(tax_table(kra))] <- gsub(tax_table(kra)[,colnames(tax_table(kra))],pattern="Eukaryota",replacement="Fungi") 


#Data transformation
####RELATIVIZATION FOR RNA-Seq
phylo_rel_kra <- transform_sample_counts(kra, function(x) 1000 * x/sum(x)) 
otu_table(phylo_rel_kra) <-  ceiling(otu_table(phylo_rel_kra, "matrix")) #Transform to the next integer
otu_table(phylo_rel_kra)

Class <- tax_glom(phylo_rel_kra, taxrank = "Class")
tax_table(Class)

merged_all <- merge_phyloseq(phylo_rel_kra, phyloseq_rel)


####Remove all other objects
rm(list=ls()[! ls() %in% c("phyloseq_tables_cleaned", "phyloseq_rel", "kra", "phylo_rel_kra", "merged_all")])
ls()

