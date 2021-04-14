#!/usr/bin/Rscript

###Plot classs from KrakenUniq reads classification
####Valeria Flores
### 13/04/21

##Libraires
library(ggplot2)
library(tidyverse)
library(Polychrome)
library(ggpubr)
library(tidyselect)



##########Color palette#############
P50 = createPalette(50,  c("#ff0000", "#00ff00", "#0000ff"))
swatch(P50)
P50 <- sortByHue(P50)
P50 <- as.vector(t(matrix(P50, ncol=4)))
swatch(P50)
####################################


#Import tables
tolerant <- read.csv("../data/krakenreadstolerant.csv")
damaged <- read.csv("../data/krakenreadsdamaged.csv")

#Gather columns into rows
plott <- tidyr::gather(tolerant, "sample", "reads", 2:10)
plotd <- tidyr::gather(damaged, "sample", "reads", 2:10)

plott$reads <- as.numeric(plotclass$reads) #Reads as numeric
plotd$reads <- as.numeric(plotclass$reads)


#####Theme for ggplot################
elements <- theme_bw() +  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())+
  theme(
    axis.title.x = element_text(color= "black", size = 15, face = "bold", vjust = -0.3),
    axis.title.y = element_text(color= "black", size = 15, face = "bold", vjust = 1.5)
  )+  
  theme(axis.text.y = element_text(size = 10))+
  theme(axis.text.x=element_text(angle=90, size = 10))


theme <- list(elements, scale_fill_manual(values = P50))

theme_set(theme)     
###############################################################





######Plots########

#Tolerant
krakentolerant <- ggplot(plott, aes(fill= class, y=reads, x=sample)) + 
         geom_bar(position="fill", stat="identity")+
        labs(x="Sample",y="Classified reads")+
        theme
krakentolerant  


###Damaged#######  
krakendamaged <- ggplot(plotd, aes(fill= class, y=reads, x=sample)) + 
  geom_bar(position="fill", stat="identity")+
  labs(x="Sample",y="Classified reads")+
  theme(axis.title.y=element_blank())+
  theme
krakendamaged    


###Group images

ggarrange(krakentolerant, krakendamaged, labels = c("A", "B"),
          common.legend = TRUE, legend = "bottom")
