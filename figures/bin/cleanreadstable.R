### Fit a table made with trimmomatic extracted information 
###and plot the plotreads report
#Valeria Flores
#19/01/2021


#Libraries
library(tidyverse)
library(viridis)
library(dplyr)


#Load table
trimreads <- read.delim("./../data/table.txt", header = FALSE, sep = " ") #Put reads into separate cells, but add multiple columns

#take the cells with the reads
trimreads <-  subset(trimreads, select = c(V1, V5, V9, V13) ) #The samples name is in the same cell with paired reads!!!

#separate the 1st cell into "sample" and "paired"
trimreads <- trimreads %>% separate(V1, c("sample", "paired"), sep = "\t", remove=TRUE) 

#name the columns
colnames(trimreads) <- c("sample", "paired", "unpairedr1", "unpairedr2", "dropped") 
as.data.frame(trimreads)

#Make a large table to plot it
plotreads<- trimreads %>% gather(key = "category", value="reads", -c(1,))

#Save it as .csv
write.csv(plotreads,"./../data/plotreads.csv", row.names = TRUE)





