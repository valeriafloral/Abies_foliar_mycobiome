#!/RScript

#Expresión diferencial
#TGFH
#Valeria Flores
#Junio 2022


#Paqueterías
library(tximport)
library(DESeq2)
library(tidyverse)
library(Polychrome)
library(ggrepel)
library(eulerr)

#Importar archivos
files <- file.path("./salmon", list.files("salmon"))
names(files) <- str_extract(files, "(?<=salmon/).*(?=_quant)")
samples <- read.delim("./metadata.csv", header=TRUE, sep=",") 
txi <- tximport(files = files, type = "salmon", txOut = T, ignoreTxVersion = TRUE)
head(txi)


#####Annotation information and filtered only annotated to fungi

#####Wrangling annotations

###Las anotaciones están en R/data/ del drive
first <- read.delim("data/1_99k_annotations.txt", sep = "\t")
second <- read.delim("data/100k_199k_annotations.txt", sep = "\t")
third <- read.delim("data/200k_231k_annotations.txt", sep= "\t")


complete <- rbind(first, second, third)

head(complete)
str(complete)

#save
#write.table(complete, "../data/complete_annotations.txt", sep = "\t", col.names = TRUE)

####
#Count how many orf were annotated
nrow(complete) #98713
length(unique(complete$query))

#Count how many orf were fungal
sum(grepl('Fungi', complete$eggNOG_OGs)) #98704

sum(!grepl('Fungi', complete$eggNOG_OGs)) #9

#Keep only annotated to fungal
fungal <- complete %>%
  filter(str_detect(eggNOG_OGs, "4751|Fungi"))

nrow(fungal) #98704
length(unique(fungal$query))

#Evaluate how many have at least a COG_category
#Replace - for NA
fungal$COG_category <- gsub("-",NA,fungal$COG_category)

#Count
sum(!is.na(fungal$COG_category)) #92293

fungal$COG_category <- as.factor(fungal$COG_category) 
levels(fungal$COG_category)
sum(is.na(fungal$COG_category))

fungalcog <- subset(fungal, !is.na(COG_category))
nrow(fungalcog) #92293
length(unique(fungalcog$query)) #92293

#######

#####Filter only classified to fungi and with a COG cathegory
length(unique(abundancematrix$query)) #222060
length(unique(fungalcog$query)) #98704
length(intersect(abundancematrix$query, fungalcog$query)) #89184


####Differential expression analysis
dds <- DESeqDataSetFromTximport(txi,
                                colData = samples, design = ~Condition) #222060 (transcripts maped)


dds <- dds[(rownames(dds) %in% fungalcog$query), ] #89184 fungal and cog category

#keep only rows that have at leats 10 reads total
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

#Establecer valores de referencia
dds$Condition <- relevel(dds$Condition, ref= "Symptomatic")

#Análisis de expresión diferencial
dds <- DESeq(dds)
res <- results(dds)
head(dds, tidy= TRUE)
res$pvalue

#Resumen de nuestro análisis
summary(res, alpha= 0.10)

#Contar cuántos transcritps tenemos de acuerdo a umbrales establecidos por nosotros
res[which(res$log2FoldChange > 0 & res$padj < .10),] #UP

res[which(res$log2FoldChange < 0 & res$padj < .10),] #DOWN

#Volcano plot

#Ordenar archivo de resumen por p-value
res <- res[order(res$padj),]
head(res)

#Hacer una dataframe a partir del objeto de resultados
topT <- as.data.frame(res)
de <- topT[complete.cases(topT), ]

#Añadir una columna con información de la expresión diferencial
de$diffexpressed <- "NOTSIG"
de$diffexpressed[de$log2FoldChange > 1 & de$padj < 0.10] <- "UP"
de$diffexpressed[de$log2FoldChange < 1 & de$padj < 0.10] <- "DOWN"

de$id <- seq.int(nrow(de))
de$id <- ifelse(de$diffexpressed == "NOTSIG", NA, de$id)



# Re-plot but this time color the points with "diffexpressed"
options(ggrepel.max.overlaps = Inf)
p <- ggplot(data=de, aes(x=log2FoldChange, y=-log10(padj), col=diffexpressed)) + 
  geom_point() +
  theme_minimal()+ geom_vline(xintercept=c(-1, 1), col="red") +
  geom_hline(yintercept=1, col="red")+
  scale_color_manual(values=c("blue", "black", "red"))+
  geom_text_repel(data=de, aes(label=id), xlim = c(-10, 10), ylim = c(-Inf, Inf), show.legend = FALSE)
  

p

###Filter only differentially expressed
fungalmatrix <- as.data.frame(counts(dds,normalized=TRUE))

fungalmatrix <- fungalmatrix  %>% 
  rownames_to_column("query")

de <- de  %>% 
  rownames_to_column("query")

de$Description <- fungalcog$Description[match(de$query, fungalcog$query)]
de$name <- fungalcog$Preferred_name[match(de$query, fungalcog$query)]
de$COG_category <- fungalcog$COG_category[match(de$query, fungalcog$query)]
de$pfam <- fungalcog$PFAMs[match(de$query, fungalcog$query)]
de$brite <- fungalcog$BRITE[match(de$query, fungalcog$query)]
de$gos <- fungalcog$GOs[match(de$query, fungalcog$query)]
difex <- de[de$diffexpressed != "NOTSIG",]  


nrow(fungalmatrix) #quedan 31950
annotated <- merge(fungalmatrix, fungalcog, by= "query")
length(unique(annotated$query))

large <- annotated %>% 
  pivot_longer(cols = c(DPVR1_S179, DPVR2_S180, DPVR3_S181, DPVR4_S182, DPVR5_S183, DPVR6_S184, DPVR7_S185, DPVR8_S186, DPVR9_S187, DPVR10_S188), names_to = "sampleID", values_to = "counts" )

large$counts <- round(large$counts)
length(unique(large$query)) #89184

#Agregar información sobre la condición
large$Condition <- samples$Condition[match(large$sampleID, samples$sampleID)]
length(unique(large$query))

#Eliminar aquellos ORF que no tengan al menos una categoría cog asignada
large <- large %>% 
  drop_na(COG_category)
length(unique(large$query)) #89184

#Agrupar por condición
condition <- large %>% group_by(Condition, query, COG_category, PFAMs, Preferred_name, KEGG_Pathway) %>% 
  summarise(n = sum(counts))
length(unique(condition$query))

#Remove zero counts rows
condition <- condition[condition$n != 0, ]
length(unique(condition$query)) #86795

###Diagramas de Venn
condition$query <- as.factor(condition$query)


#Split into two different dataframes

symp <- subset(condition,  Condition=="Symptomatic")
symp <- subset(symp, select= c(query, Condition, COG_category, PFAMs, Preferred_name))

asymp <- subset(condition, Condition=="Asymptomatic")
asymp <- subset(asymp, select= c(query, Condition, COG_category, PFAMs, Preferred_name))


#Make vectors from splitted dataframes for venn diagram input
sym <- unique(symp$query)
length(sym)
duplicated(sym)
asym <- unique(asymp$query)
duplicated(asym)
length(asym)


#Draw venn diagrams
VennDiag <- euler(list("Symptomatic"= sym, "Asymptomatic"= asym))
s <- plot(VennDiag, quantities= list(cex = 2), font=1, alpha=0.7, fill = c("chocolate3", "darkolivegreen"), labels= FALSE)
s

# Identify shared and unique elements
shared_elements <- intersect(sym, asym)
length(shared_elements)
symptomatic_only<- setdiff(sym, asym)

asymptomatic_only <- setdiff(asym, sym)


###Filter symptomatic

asym_annot <- subset(condition, query %in% asymptomatic_only)
sym_annot <- subset(condition, query %in% symptomatic_only)


asym_annot$PFAMs <- as.factor(asym_annot$PFAMs)
levels(asym_annot$PFAMs)
sym_annot$PFAMs <- as.factor(sym_annot$PFAMs)
levels(sym_annot$PFAMs)


# Identify shared and unique elements
shared_elements <- intersect(asym_annot$PFAMs, sym_annot$PFAMs)
length(shared_elements)
sym_only<- setdiff(sym_annot$PFAMs, asym_annot$PFAMs)
length(sym_only)
duf <- "DUF"
filtered_sym <- sym_only[-grep(duf, sym_only)]
length(filtered_sym)


asym_only <- setdiff(asym_annot$PFAMs, sym_annot$PFAMs)
length(asym_only)
filtered_asym <- asym_only[-grep(duf, asym_only)]
length(filtered_asym)

a <- as.data.frame(filtered_asym)
s <- as.data.frame(filtered_sym)


####Enriched of UNIQUE
asym_only_a <- subset(asym_annot, PFAMs %in% a$filtered_asym)
sym_only_a <- subset(sym_annot, PFAMs %in% s$filtered_sym)

which(duplicated(sym_only_a$PFAMs))

asymcog <- asym_only_a %>% 
  group_by(COG_category) %>% 
  summarise(count=n())
sum(asymcog$count)




symcog <- sym_only_a  %>% 
  group_by(COG_category) %>% 
  summarise(count=n())
sum(symcog$count)



####
#Agrupar por condición
conditioncog <- large %>% group_by(Condition, query, COG_category) %>% 
  summarise(n = sum(counts))



#Hacer la COG category un factor
levels(conditioncog$COG_category)
conditioncog$COG_category <- as.factor(conditioncog$COG_category)



#Separate COG category
conditioncog$COG_category <- as.character(conditioncog$COG_category)

superlarge <- conditioncog %>% 
  mutate(COG=strsplit(COG_category, "")) %>% 
  unnest(COG)

superlarge$COG <- as.factor(superlarge$COG)
levels(superlarge$COG)

#Evaluate how many have at least a COG_category
#Replace - for NA
superlarge$COG<- gsub("-",NA,superlarge$COG)
superlarge$COG <- as.factor(superlarge$COG)

levels(superlarge$COG)

#Add count

superlarge <- superlarge %>% 
  mutate(COGcount = ifelse(is.na(COG), 1, 1))
class(superlarge$COGcount)



superlarge$Condition <- as.factor(superlarge$Condition)

#Remove zeros
superlarge <- superlarge[superlarge$n != 0, ]

aver <- superlarge %>% 
  group_by(Condition, COG) %>% 
  summarise(n = sum(COGcount))

aver$Condition <- factor(aver$Condition, levels = c("Symptomatic", "Asymptomatic"))
aver <- aver[order(aver$Condition), ]

###NO ELIMINAR 0 counts, agregar NA A COGCOUNT


set.seed(30)
P50 <-  createPalette(154,  c("#c97d2d", "#628ed6", "#8d3619"))
P50 <- sortByHue(P50)
P50 <- as.vector(t(matrix(P50, ncol=4)))


cogplot <- ggplot(aver, aes(fill=COG, y=n, x=Condition)) + 
  labs(x="Condition", y="Relative adundance")+
  geom_bar(position="fill", stat="identity")+
  theme_classic()+
  scale_fill_manual(values = P50)+
  theme(axis.text.x = element_text(size = 10, color=  c("chocolate3", "darkolivegreen")), axis.text.y = element_text(size=13))
  
cogplot

#Number of annotated orf at each COG category per Condition
cogs <- pivot_wider(aver, names_from= Condition, values_from=n)
summary(cogs)

description <- subset(difex, select=c("query"))
description$id <- seq.int(nrow(description))


write.table(description, "differentiallyexpressed.txt", sep= "\t")


fungaldiff <- subset(fungal,  fungal$query %in% description$query)

fungaldiff <- merge(description, fungaldiff, by="query")



write.table(fungaldiff, "cogdifferentiallyexpressed.txt", sep= "\t")

####Differential expression analysis
dds <- DESeqDataSetFromTximport(txi,
                                colData = samples, design = ~Condition) #222060 (transcripts maped)

dds$Condition
colnames(dds)
dds <- dds[(rownames(dds) %in% fungalcog$query), ] #89184 fungal and cog category

#keep only rows that have at leats 10 reads total
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

#Establecer valores de referencia
dds$Condition <- relevel(dds$Condition, ref= "Symptomatic")

#Análisis de expresión diferencial
dds <- DESeq(dds)
res <- results(dds)
head(dds, tidy= TRUE)

#Resumen de nuestro análisis
summary(res, alpha= 0.10)

res$pvalue

#Extraer counts
counts <- as.data.frame(counts(dds,normalized=TRUE))
counts <- rownames_to_column(counts, var= "query")

#Relacionar cuentas de cada query con cada cog

#Quedarse con el primer hit de cada categoría
fungalcog$cog <- substr(fungalcog$COG_category, 1, 1)
cog <- subset(fungalcog, select=c(query, cog))


countlarge <- pivot_longer(counts, -query, names_to = "sampleID", values_to = "Count")

#Merge counts con cog
categories <- merge(countlarge, cog, by="query")

suma <- categories %>% 
  group_by(cog, sampleID) %>% 
  summarise(Count=sum(Count))


wide <- pivot_wider(suma, names_from = cog, values_from = Count)
wide <- column_to_rownames(wide, var="sampleID")

cogmatrix <- as.matrix(wide)
order <- c("DPVR1_S179", "DPVR2_S180", "DPVR3_S181", "DPVR4_S182", "DPVR5_S183", "DPVR6_S184", "DPVR7_S185", "DPVR8_S186", "DPVR9_S187", "DPVR10_S188")

# Reorder rows according to desired order
cogmatrix <- cogmatrix[order, , drop = FALSE]
set.seed(4235421)
example_NMDS <- metaMDS(cogmatrix, distance="bray")
stressplot(example_NMDS)
plot(example_NMDS)


# Order the dataframe by the specific order in Column1
samples <- samples[order(match(samples$sampleID, order)), ]
analisis<-anosim(cogmatrix, samples$Condition, distance="bray",permutations=9999)
analisis

cognmds <- as.data.frame(scores(example_NMDS, display = "sites"))
cognmds <- rownames_to_column(cognmds, var="sampleID")
cognmds <- merge(cognmds, samples, by="sampleID")

adon <- adonis2(cogmatrix~ Condition, distance="bray", data = samples)
adon

treat <- c(rep("Asymptomatic",5),rep("Symptomatic",5))
ordiplot(example_NMDS)
ordispider(example_NMDS,groups=treat,col="grey90",label=F)
orditorp(example_NMDS,display="species",col="red",air=0.01)
orditorp(example_NMDS,display="sites",
         air=0.01,cex=0.9)


ggplot(cognmds, aes(x = NMDS1, y = NMDS2)) + 
  geom_point(size = 4, aes(colour = Condition, shape= Condition, fill = Condition)) +  
  stat_ellipse(aes(fill = Condition), alpha = 0.2, geom = "polygon") +
  theme(axis.text.y = element_text(colour = "black", size = 12, face = "bold"), 
        axis.text.x = element_text(colour = "black", face = "bold", size = 12), 
        axis.title.x = element_text(face = "bold", size = 14, colour = "black"), 
        axis.title.y = element_text(face = "bold", size = 14, colour = "black"),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill = NA, size = 1.2)) +
  labs(x = "NMDS1", y = "NMDS2") +
  scale_color_manual(values = c("darkolivegreen", "chocolate3")) +
  scale_fill_manual(values = c("darkolivegreen", "chocolate3")) +
  scale_x_continuous(limits = c(-0.1, 0.15)) +  # Change x-axis scale
  scale_y_continuous(limits = c(-0.056, 0.06))    # Change y-axis scale


# Reorder rows according to desired order
dis <- cogmatrix[order, , drop = FALSE]
dis <- vegdist(dis, "bray")


# Order the dataframe by the specific order in Column1
samples <- samples[order(match(samples$sampleID, order)), ]
groups <- as.factor(samples$Condition)


## Calculate multivariate dispersions
mod <- betadisper(dis, groups)
mod$call

sd_of_dispersions <- tapply(dis, groups, sd)

mod$group.distances
mod$sdev
permutest(mod)

## Perform test
anova(mod)

## Permutation test for F
pmod <- permutest(mod, permutations = 99, pairwise = TRUE)

## Tukey's Honest Significant Differences
(mod.HSD <- TukeyHSD(mod))
plot(mod.HSD)

## Has permustats() method
pstat <- permustats(pmod)
densityplot(pstat, scales = list(x = list(relation = "free")))
qqmath(pstat, scales = list(relation = "free"))


#####Log2FC cog
#Extraer log2Foldchange
df <- as.data.frame(res)
df <- rownames_to_column(df, var="query")
logcat <- merge(df, cog, by="query")
logcat$cog <- as.factor(logcat$cog)

cogcat <- read.delim("classifier_count.txt", sep="\t")
cogcat$Description <- paste(cogcat$LETTER, cogcat$DESCRIPTION, sep=": ")
cogcaat <- subset(cogcat, select=c("LETTER", "Description"))
colnames(cogcaat)[1] <- "cog"


logcat <- merge(logcat, cogcaat, by="cog")
table(logcat$cog)

dif <- subset(logcat, padj < 0.10)
table(dif$cog)

# Remove rows with NA values in the 'col' column
logcat_filtered <- logcat[!is.na(logcat$padj), ]
logcat_filtered <- subset(logcat_filtered, cog %in% c("B", "C", "E", "G", "I", "O", "P", "Q", "S", "T"))

# Plotting with filtered data
ggplot(logcat_filtered, aes(x = cog, y = log2FoldChange, fill = Description)) + 
  geom_boxplot() +
  geom_point(alpha=0.3, aes(colour = (padj < 0.1)), 
             position = position_jitter(height = .2, width = .5)) +
  scale_colour_manual(values = c("black", "red"))+
  guides(fill = guide_legend(ncol = 1), color="none") +
  theme_minimal()


set.seed(30)
P50 <-  createPalette(30,  c("#00ffff", "#ff00ff", "#ffff00"), M=1000)
P50 <- sortByHue(P50)
P50 <- as.vector(t(matrix(P50, ncol=4)))

ggplot(logcat_filtered, aes(x = cog, y = log2FoldChange, fill = Description)) + 
  geom_point(size = 3, 
             position = position_jitter(height = .01, width = .25), alpha=0.3, color="gray88") +
  geom_point(data = subset(logcat_filtered, padj < 0.1), 
             aes(colour = (padj < 0.1)), size = 3, alpha = 0.6) +  # Increase alpha for red dots
  geom_boxplot(outlier.shape = NA, alpha = 0.5, show.legend = FALSE) +
  scale_colour_manual(values = c("red", "gray88")) +
  scale_fill_manual(values = P50)+
  guides(color = "none", fill = guide_legend(ncol = 1, title.position = "top",
                                             keywidth = unit(1, "cm"),
                                             keyheight = unit(1, "cm"),
                                             override.aes = list(shape = 22,
                                                                 size = 10)), ) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "blue", size = 1) +
  coord_flip() +
  theme_minimal() +
  labs(x = "COG category",  # Custom x-axis label
       y = bquote(log[2]*"FC"))+
  theme(
    legend.text = element_text(size = 9, face = "bold"),  # Adjust legend text size and weight
    legend.title = element_text(size = 14, face = "bold"),  # Adjust legend title size and weight
    axis.text = element_text(size = 12, face = "bold"),  # Adjust axis text size and weight
    axis.title = element_text(size = 14, face = "bold"),
    axis.title.y = element_text(vjust=2.5)# Adjust axis title size and weight# Adjust axis title size and weight
  )

