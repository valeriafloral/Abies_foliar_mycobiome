#!/usr/bin/Rscript


##### Plot the BWA mapped reads
##Valeria Flores 
###28/01/11

#Libraries
library(ggplot2)
library(cowplot)

#Import table
to_graph <- read.csv("../data/to_graph.csv")


#Set the samples order and set samples as factor
to_graph$sample <- factor(to_graph$sample, levels = c('DPVR1_S179', 'DPVR2_S180', 'DPVR3_S181', 'DPVR4_S182', 'DPVR5_S183', 'DPVR6_S184', 'DPVR7_S185', 'DPVR8_S186', 'DPVR9_S187', 'DPVR10_S188', 'DPVR11_S189', 'DPVR12_S190', 'DPVR13_S191', 'DPVR14_S192', 'DPVR15_S193', 'DPVR16_S194', 'DPVR17_S195', 'DPVR18_S196'), ordered = TRUE)

#####Theme

newtheme <- theme_bw() +  
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())+
  theme(
    axis.title.x = element_text(color= "black", size = 20, face = "bold", vjust = -0.3),
    axis.title.y = element_text(color= "black", size = 20, face = "bold", vjust = 1.5)
  )+  
  theme(legend.title = element_blank(), legend.text = element_text(size = 20))+
  theme(plot.title = element_text(face= "bold", hjust = 0.5, size=30))+
  theme(axis.text.y = element_text(size = 15))+
  theme(axis.text.x=element_text(angle=90, size = 15))
  


###Set theme

theme_set(newtheme)     

#Plot the R1_unmaped

r1 <- ggplot(to_graph, aes(x= sample, y= R1_unpaired, fill = category)) + 
  labs(title = "R1 unpaired reads", x="Sample",y="Number of reads")+
  geom_bar(position = "stack", stat = "identity",color='black',width=0.9) +
  geom_text(aes(label=paste(round(R1percentage*100),"%", sep="")),size = 5,vjust=0,position="stack")+
  scale_fill_manual( values = c("#ffe3ad", "#6ce9d4"), labels = c("mapped", "unmapped"))+
  theme(legend.position = "none")+
  theme(axis.title.x = element_blank())
r1 

#Plot the R2_unmaped

r2 <- ggplot(to_graph, aes(x= sample, y= R2_unpaired, fill = category)) +
  labs(title = "R2 unpaired reads", x="Sample",y="Number of reads")+
  geom_bar(position = "stack", stat = "identity",color='black',width=0.9) +
  geom_text(aes(label=paste(round(R2percentage*100),"%", sep="")),size = 5,vjust=0,position="stack") + 
  scale_fill_manual( values = c("#ffe3ad", "#6ce9d4"), labels = c("mapped", "unmapped"))+
  theme(legend.position = "none")+
  theme(axis.title.x = element_blank())+
  theme(axis.title.y = element_blank())
r2

#Paired

p <- ggplot(to_graph, aes(x= sample, y= paired, fill = category)) +
  labs(title = "Paired reads", x="Sample",y="Number of reads")+
  geom_bar(position = "stack", stat = "identity",color='black',width=0.9) +
  geom_text(aes(label=paste(round(Ppercentage*100),"%", sep="")),size = 5,vjust=0,position="stack")+
  scale_fill_manual( values = c("#ffe3ad", "#6ce9d4"), labels = c("mapped", "unmapped"))
p

#Group the plots in one
mappedreads<- ggdraw() +
  draw_plot(r1, x = 0, y = .5, width = .5, height = .5) +
  draw_plot(r2, x = .5, y = .5, width = .5, height = .5) +
  draw_plot(p, x = 0, y = 0, width = 1, height = 0.5)
mappedreads
