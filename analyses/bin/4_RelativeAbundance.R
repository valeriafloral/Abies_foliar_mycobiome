#Libraries

library(phyloseq)
library(ampvis2)
library(scales)
library(DESeq2)
library(tidyverse)

#Necesito los objetos phyloseq_rel, phylo_rel_kra y merged_all
source("metabarcoding_phyloseq.R")

#Taxglom per class
Class_dna <- tax_glom(phyloseq_rel, taxrank = "Class")
Class_rna <- tax_glom(phylo_rel_kra, taxrank = "Class")


#Class dataframe
Class_dna <- as.data.frame(tax_table(Class_dna))
Class_rna <- as.data.frame(tax_table(Class_rna))


#Parse names for heatmap
inmeta <- unique(Class_dna$Class[! Class_dna$Class %in% Class_rna$Class])
inmeta
intwo <- unique(Class_dna$Class[Class_dna$Class %in% Class_rna$Class])
intwo
inrna <- unique(Class_rna$Class[! Class_rna$Class  %in% Class_dna$Class])
inrna
names <- c(inrna, intwo, inmeta)

####HEATMAP

#Merged
Class <- tax_glom(merged_all, taxrank = "Class")
tax_table(Class)

class_tax <- data.frame(tax_table(Class))
class_tax <- rownames_to_column(class_tax, var="OTU")
class_tax <- column_to_rownames(class_tax, var = "Class")
class_tax$Class <- rownames(class_tax)
tax_names <- subset(class_tax, select= c("OTU", "Class"))
class_tax <- class_tax %>% 
  select(-OTU) 
class_tax <- rownames_to_column(class_tax, var="OTU")

class_meta <- data.frame(sample_data(Class))
class_meta$SampleID <- with(class_meta, paste(class_meta$Dataset, class_meta$individual, sep = ""))
class_meta <- rownames_to_column(class_meta, var="Sample")

meta_names <- subset(class_meta, select=c(Sample, SampleID))
class_meta <- class_meta %>%
  select(SampleID, everything())
class_meta$SampleID <- factor(class_meta$SampleID, levels = c("MetabarcodingS1", "MetabarcodingS2", "MetabarcodingS3", "MetabarcodingS4", "MetabarcodingS5", "MetabarcodingA1", "MetabarcodingA2", "MetabarcodingA3", "MetabarcodingA4", "MetabarcodingA5", "RNA-SeqS1", "RNA-SeqS2", "RNA-SeqS3", "RNA-SeqS4", "RNA-SeqS5", "RNA-SeqA1", "RNA-SeqA2", "RNA-SeqA3", "RNA-SeqA4", "RNA-SeqA5"))


class_df <- psmelt(Class)
class <- subset(class_df, select=c("OTU", "Class"))

class$OTU <- as.factor(class$OTU)
class <- class %>% 
  distinct(OTU, .keep_all = TRUE)


classtab <- data.frame(otu_table(Class)) %>% 
  rownames_to_column("OTU")

classtab$OTU <- as.factor(classtab$OTU)
metadata <- as.data.frame(sample_data(Class))

classtab2 <- merge(classtab, class, by= "OTU") %>% 
  column_to_rownames(var = "Class") %>% 
  select(-OTU)


class_otu <- rownames_to_column(classtab2, var= "OTU")
class_large <- pivot_longer(class_otu, cols= -OTU, names_to= "Sample", values_to="Count")

merged <- merge(class_large, meta_names, by="Sample")
merged <- subset(merged, select= -Sample)
class_otu <- pivot_wider(merged, values_from = Count, names_from = "SampleID")


####Ampvis2object


d <- amp_load(otutable = class_otu,
              metadata= class_meta,
              taxonomy= class_tax)

class_names <- c(inrna, intwo, inmeta)
class_names

sampleid <- c("MetabarcodingS1", "MetabarcodingS2", "MetabarcodingS3", "MetabarcodingS4", "MetabarcodingS5", "MetabarcodingA1", "MetabarcodingA2", "MetabarcodingA3", "MetabarcodingA4", "MetabarcodingA5", "RNA-SeqS1", "RNA-SeqS2", "RNA-SeqS3", "RNA-SeqS4", "RNA-SeqS5", "RNA-SeqA1", "RNA-SeqA2", "RNA-SeqA3", "RNA-SeqA4", "RNA-SeqA5")


amp_heatmap(
  d,
  tax_aggregate = "Class",
  tax_show = 19,
  order_y_by = class_names,
  order_x_by = sampleid,
  color_vector = c("#f2f2f2", "#909190")
)+
  theme(axis.ticks.x= element_blank(),
        axis.text.x = element_blank(),
        strip.background = element_blank(),
        strip.text.x = element_text(size = 20))

### log2flochange

Class <- tax_glom(phyloseq_rel, taxrank = "Class")
class_df <- psmelt(Class)

class <- subset(class_df, select=c("OTU", "Class"))

class$OTU <- as.factor(class$OTU)
class <- class %>% 
  distinct(OTU, .keep_all = TRUE)


classtab <- data.frame(otu_table(Class)) %>% 
  rownames_to_column("OTU")

classtab$OTU <- as.factor(classtab$OTU)
metadata <- as.data.frame(sample_data(Class))

classtab2 <- merge(classtab, class, by= "OTU") %>% 
  column_to_rownames(var = "Class") %>% 
  select(-OTU)


classtx <- data.frame(tax_table(Class))
row.names(classtx) <- classtx$Class
classtx <- as.matrix(classtx)


phyloseq_class <- phyloseq(otu_table(classtab2, taxa_are_rows=TRUE), 
                            sample_data(Class), 
                            tax_table(classtx))

nuevo <- phyloseq_to_deseq2(phyloseq_class,~Condition)
nuevo$Condition <- relevel(nuevo$Condition, ref= "Symptomatic")
diagdds <-  DESeq(nuevo)

res <-  results(diagdds, cooksCutoff = FALSE)

df2 <- data.frame(res)
res$padj
alpha = 0.05
sigtab = res[which(res$padj < alpha), ]
sigtab = cbind(as(sigtab, "data.frame"), as(tax_table(Class)[rownames(sigtab), ], "matrix"))
head(sigtab)

res
avwer

df2 <- rownames_to_column(df2, var= "Class")
df2$Class <- as.factor(avwer$Class)
Class2 <- c(intwo, inmeta)
df2$Class <- factor(df2$Class , levels = df2$Class[order(Class2)])
df2 <- df2 %>% 
  mutate(pos= log2FoldChange > 0)

df2 %>% 
  mutate(Class = factor(Class, levels=Class2)) %>%
ggplot(aes(Class, log2FoldChange, fill=pos)) +
  geom_col(position = "identity")+
  coord_flip()+
  theme_bw()+
  theme(legend.position = "none",
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  ylim(-2.2, 2.2)+
  scale_fill_manual(values=c("chocolate3", "darkolivegreen"))


#### PARA RNA-SEQ
#### Para Clases
Class <- tax_glom(phylo_rel_kra, taxrank = "Class")
tax_table(Class)
class_df <- psmelt(Class)

class_df$Class <- as.factor(class_df$Class)
names_rna <- c(levels(class_df$Class))

class <- subset(class_df, select=c("OTU", "Class"))

class$OTU <- as.factor(class$OTU)
class <- class %>% 
  distinct(OTU, .keep_all = TRUE)


classtab <- data.frame(otu_table(Class)) %>% 
  rownames_to_column("OTU")

classtab$OTU <- as.factor(classtab$OTU)
metadata <- as.data.frame(sample_data(Class))

classtab2 <- merge(classtab, class, by= "OTU") %>% 
  column_to_rownames(var = "Class") %>% 
  select(-OTU)


class_df$Class <- as.factor(class_df$Class)
levels(class_df$Class)

class_tax <- data.frame(tax_table(Class))
class_tax <- rownames_to_column(class_tax, var="OTU")
class_tax <- column_to_rownames(class_tax, var = "Class")
class_tax$Class <- rownames(class_tax)
tax_names <- subset(class_tax, select= c("OTU", "Class"))
class_tax <- class_tax %>% 
  select(-OTU) 
class_tax <- rownames_to_column(class_tax, var="OTU")


classtx <- data.frame(tax_table(Class))
row.names(classtx) <- classtx$Class
classtx <- as.matrix(classtx)


classtab2

phyloseq_class <- phyloseq(otu_table(classtab2, taxa_are_rows=TRUE), 
                           sample_data(Class), 
                           tax_table(classtx))

nuevo <- phyloseq_to_deseq2(phyloseq_class,~Condition)
nuevo$Condition <- relevel(nuevo$Condition, ref= "Symptomatic")
diagdds <-  DESeq(nuevo)

res <-  results(diagdds, cooksCutoff = FALSE)

avwer <- data.frame(res)
res$padj
alpha = 0.05
sigtab = res[which(res$padj < alpha), ]
sigtab = cbind(as(sigtab, "data.frame"), as(tax_table(Class)[rownames(sigtab), ], "matrix"))
head(sigtab)

res
avwer
str(avwer)
avwer <- rownames_to_column(avwer, var= "Class")
avwer$Class <- as.factor(avwer$Class)
avwer$abs <- abs(avwer$log2FoldChange)
avwer <- arrange(avwer, abs)
avwer$Class <- factor(avwer$Class , levels = avwer$Class[order(avwer$abs)])

avwer <- avwer %>% 
  mutate(pos= log2FoldChange > 0)


intwo2 <- rev(intwo) 
inrna
Class3 <- c(intwo2, inrna)
Class3 <- rev(Class3)

avwer <- avwer %>% 
  mutate(pos= log2FoldChange > 0)

avwer %>% 
  mutate(Class = factor(Class, levels=Class3)) %>%
ggplot(aes(Class, log2FoldChange, fill=pos)) +
  geom_col(position = "identity")+
  theme_bw()+
  theme(legend.position = "none",
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  ylim(-1.5, 1.5)+
  scale_fill_manual(values=c("chocolate3", "darkolivegreen"))
