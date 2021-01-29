#!/usr/bin/env Rscript

#Import the standard output from samtools result from mapping to a reference
#This script is an unpdate version of: http://adomingues.github.io/2012/10/25/calculating-and-plotting-mapped-reads/
# Valeria Flores
#28/01/21


library(dplyr)
library(tidyverse)
library(reshape2)
library(plyr) #dplyr must be off before liad plyr


#Import table that was previous manually edited (divide sample name and paired/unpaired)
mappingout <- read.table(file="../data/edited_count_map.csv", header=T, sep = ",")

# a bit of polishing to remove total (not needed for plotting)  
small <- data.frame(sample = mappingout$sample, type = mappingout$type, mapped = mappingout$mapped ,unmapped = mappingout$unmapped)

# ggplot needs data in a specific layout
ggplotable <- small %>% gather(key = "category", value="reads", -c(1,2))

#Make a wider table
mapping <- pivot_wider(ggplotable, names_from = type, values_from = reads) 

#######Calculate parecetage

# calculate the fraction of R1_unpaired mapped reads  
R1_ufraction <- ddply(  
  mapping,  
  .(sample),  
  summarise,  
  R1Count.Fraction = R1_unpaired / sum(R1_unpaired)  
)

# calculate the fraction of R2_unpaired mapped reads  
R2_ufraction <- ddply(  
  mapping,  
  .(sample),  
  summarise,  
  R2Count.Fraction = R2_unpaired / sum(R2_unpaired)  
)

# calculate the fraction of paired mapped reads  
P_ufraction <- ddply(  
  mapping,  
  .(sample),  
  summarise,  
  PCount.Fraction = paired / sum(paired)  
)


###Add percentage to the table

# sort the data frame and add R1 fraction to the data frame 
to_graph <- cbind(arrange(mapping, sample), R1percentage = R1_ufraction$R1Count.Fraction, R2percentage = R2_ufraction$R2Count.Fraction, Ppercentage = P_ufraction$PCount.Fraction)


#Save it as .csv
write.table(to_graph,file="../data/to_graph.csv", col.names = TRUE, sep=",")

  
  