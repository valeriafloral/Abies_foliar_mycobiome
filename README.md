# **Role of endophytic fungi in the resistance of sacred fir (*Abies religiosa*) to air pollution**

This repository contains the data and the scripts used to in the present project.

## **Problem**

Air pollution by tropospheric ozone (O3) is causing the strong decline of sacred fir (*Abies religiosa*) in peripheral areas of Mexico City. However, within high contaminated zones, variation in the level of damage to air pollution was detected among fir individuals. These results suggest that there is genetic variability related to tolerance to O3. Due to their effects on plant resistance to abiotic stresses, it is very likely that endophytic fungi present inside fir leaves are involved in resistance to air pollution.


## **Aims**

1. To characterize the diversity of fungal endophytes inside the leaves of health and damaged fir individuals through isolate in culture and Sanger sequencing.
2. To characterize the diversity of fungal endophytes inside the leaves of health and damaged fir individuals through metatranscriptomic analysis.
3. To search for fungal transcript in RNA-Seq transcriptomic data from healthy and damaged fir individuals to detect signals of differential expression and identify fungal genes involved in the resistance of tolerant individuals.

## **Data**

The data comes from Veronica Reyes Galindo's project [***Abies* vs ozone**](https://github.com/VeroIarrachtai/Abies_vs_ozone). 64 libraries were sequenced, resulting libraries were quality filtered. For more information about the samples see the folder [**metadata**](https://github.com/valeriafloral/Abies_fungal_endophytes/tree/master/metadata).

For this project 16 samples in total were used:

Of these samples:

* **8** samples were tolerant.
* **8** samples were damaged.  


## **Workflow**

![](workflow.png)

## **Repository structure**

This repository contains the folders **bin**, **data**, **metadata** and **figures**.

* The folder **bin** contains the scripts divided in subfolders which contains the scripts for each step of the transcriptomic analysis. 
* The folder **data** contains the data used.
* The folder **metadata** contains the information about the samples.
* The folder **figures** contains the    results of the analysis organized in figures.  
