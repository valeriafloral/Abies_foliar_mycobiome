# **Role of endophytic fungi in the resistance of sacred fir (*Abies religiosa*) to air pollution**


Air pollution by tropospheric ozone (O<sub>3</sub>) is causing the strong decline of sacred fir (*Abies religiosa*) in peripheral areas of Mexico City. However, within high contaminated zones, variation in the level of damage to air pollution was detected among fir individuals. These results suggest that there is genetic variability related to tolerance to (O<sub>3</sub>). Due to their effects on plant resistance to abiotic stresses, it is very likely that endophytic fungi present inside fir leaves are involved in resistance to air pollution.

In this repository, you will find the workflow of a metatranscriptomics analysis from *Abies religiosa* indivuals exposed to high (O<sub>3</sub>) concentrations and showed 2 different phenotypes (tolerant and damaged). 

## **Aims**

1. To characterize the diversity of fungal endophytes inside the leaves of tolerant and damaged fir individuals through metatranscriptomic analysis.
2. To search for fungal transcript in RNA-Seq transcriptomic data from tolerant and damaged fir individuals to detect signals of differential expression and identify fungal genes involved in the resistance of tolerant individuals.

## **Data**

The data comes from Veronica Reyes Galindo's project [***Abies* vs ozone**](https://github.com/VeroIarrachtai/Abies_vs_ozone). For more information about the samples see the folder [**metadata**](https://github.com/valeriafloral/Abies_fungal_endophytes/tree/master/metadata).

For this project **16** samples in total were used:

* **8** samples **tolerant**.
* **8** samples **damaged**.  


## **Workflow**

![](workflow.png)

## **Repository structure**

This repository contains the folders

>### /bin/

Contains scripts to perfrom the analysis

* /shell_scripts/

  1. **masterscript.sh**
 Contains the pipeline in detail and specifies the order in which each script must be called.
  2. **0_quality.sh**
 Performs quality analysis with FastQC, adapters deletion and paired-end read merging with trimmomatic, and a set a quality          treshold with vsearch.
  3. **1_abundantrrna.sh**
  Delete abundant rRNA with sormeRNA.
  4. **2_removehost.sh**
  Delete host reads (*A. religiosa*) with BWA by mapping to a Reference transcriptomic (*A. balsamea).
  5. **3_taxonomy.sh**
  Assign taxonomy using kaiju.
  6. **4_assembly.sh**
  Permorms a *de novo* assambly using MetaSPAdes
  7. **5_annotation.sh**
  Assing function to assembled contigs. 
  
 


>### /data/
>### /metadata/

* The folder **bin** contains the scripts divided in subfolders which contains the scripts for each step of the transcriptomic analysis. 
* The folder **data** contains the data used.
* The folder **metadata** contains the information about the samples.
* The folder **figures** contains the    results of the analysis organized in figures.  
