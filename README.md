# <div align="center"> Role of endophytic fungi in the resistance of sacred fir (*Abies religiosa*) to air pollution </div>

### <div align="center">  :construction::construction::construction::construction: REPOSITORY UNDER CONSTRUCTION :construction::construction::construction::construction: </div>






Air pollution by tropospheric ozone (O<sub>3</sub>) is causing the strong decline of sacred fir (*Abies religiosa*) in peripheral areas of Mexico City. However, within high contaminated zones, variation in the level of damage to air pollution was detected among fir individuals. These results suggest that there is genetic variability related to tolerance to (O<sub>3</sub>). Due to their effects on plant resistance to abiotic stresses, it is very likely that endophytic fungi present inside fir leaves are involved in resistance to air pollution.

In this repository, you will find the workflow of a metatranscriptomics analysis from *Abies religiosa* indivuals exposed to high (O<sub>3</sub>) concentrations and showed 2 different phenotypes (tolerant and damaged). 

## **Aims**

1. To characterize the diversity of fungal endophytes inside the leaves of tolerant and damaged fir individuals through metatranscriptomic analysis.
2. To search for fungal transcript in RNA-Seq transcriptomic data from tolerant and damaged fir individuals to detect signals of differential expression and identify fungal genes involved in the resistance of tolerant individuals.

## **Data**

The data comes from Veronica Reyes Galindo's project [***Abies* vs ozone**](https://github.com/VeroIarrachtai/Abies_vs_ozone). For more information about the samples see the folder [**metadata**](https://github.com/VeroIarrachtai/Abies_vs_ozone/blob/master/4_Transcriptomics/metadata/RNA_sacredfir.csv).

For this project **16** samples in total were used:

* **8** samples **tolerant**.
* **8** samples **damaged**.  


## **Workflow**

![](workflow.png)

## **Repository structure**

This repository contains the folders

>### /bin/

Contains scripts to perform the analysis

#### /shell_scripts/

  * **masterscript.sh**
 Contains the pipeline in detail and specifies the order in which each script must be called.
  * **0_quality.sh**
 Performs quality analysis with FastQC, adapters deletion and paired-end read merging with trimmomatic, and a set a quality treshold with vsearch.
  * **1_abundantrrna.sh**
  Deletes abundant rRNA with sortmeRNA.
  * **2_removehost.sh**
  Deletes host reads (*A. religiosa*) with BWA by mapping to a Reference transcriptomic (*A. balsamea*).
  * **3_taxonomy.sh**
  Assigns taxonomy to reads using kaiju.
  * **4_assembly.sh**
  Performs an assembly into contigs using MetaSPAdes
  * **5_annotation.sh**
  Assigns function to assembled contigs. 
  
 


>### /data/
Contains subfolders:

#### /raw/
(`.fq.gzip`)
#### /trimmed/
(`.fq.gzip`) Trimmomatic output
#### /filtered/
sortmeRNA output and unmaped reads to reference transcriptomic
#### /assembled/
metaSPADES output


>### /metadata/
Contains information about the samples and the reference transcriptomic

>### /parkinsonlabtutorial/
This folder was made to follow the [**Parkinson's Lab tutorial**](https://github.com/ParkinsonLab/Metatranscriptome-Workshop) that I'm following because I' gonna use some of it scripts in my project. This folder is gonna be deleted when I finish adapting my scripts.
I structured the folder with subfolders in which I gonna organize my project.
