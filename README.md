# <div align="center"> Role of endophytic fungi in the resistance of sacred fir (*Abies religiosa*) to air pollution </div>

### <div align="center">  :construction::construction::construction::construction: REPOSITORY UNDER CONSTRUCTION :construction::construction::construction::construction: </div>






Air pollution by tropospheric ozone (O<sub>3</sub>) is causing the strong decline of sacred fir (*Abies religiosa*) in peripheral areas of Mexico City (de Bauer y Hernández-Tejeda, 2007). However, within high contaminated zones, variation in the level of damage to air pollution was detected among fir individuals. These results suggest that there is genetic variability related to tolerance to O<sub>3</sub> (Reyes-Galindo, 2019). Due to their effects on plant resistance to abiotic stresses, it is very likely that endophytic fungi present inside fir leaves are involved in resistance to air pollution (Pan *et al.* 2017).

In this repository, you will find the workflow of a metatranscriptomics analysis from *Abies religiosa* indivuals exposed to high O<sub>3</sub> concentrations and showed 2 different phenotypes (tolerant and damaged). 

## **Aims**

1. To characterize the diversity of fungal endophytes inside the leaves of tolerant and damaged fir trees.
2. To detect differential expression of fungal genes from tolerant and damaged fir trees. 
3. To identify fungal genes putitive involved in the resistance to air pollution caused by (O<sub>3</sub>).

## **Prerequisites**

* [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [Trimmomatic-0.39](http://www.usadellab.org/cms/?page=trimmomatic)
* [BWA-0.7.17](http://bio-bwa.sourceforge.net)
* [samtools-1.10](http://www.htslib.org)
* [SPADES-3.14.1](https://cab.spbu.ru/software/spades/)
* [MaxBin2-2.2.4-1](https://sourceforge.net/projects/maxbin2/)
* [Kraken2](https://ccb.jhu.edu/software/kraken2/)
* [Kaiju-1.7.3](http://kaiju.binf.ku.dk)
* [Prodigal-2.6.3](https://github.com/hyattpd/Prodigal)
* [Diamond-2.0.5](https://github.com/bbuchfink/diamond)	


## **Data**

The data comes from Veronica Reyes Galindo's project [***Abies* vs ozone**](https://github.com/VeroIarrachtai/Abies_vs_ozone). 

In this project **16** samples in total were used:

* **8** samples **tolerant**.
* **8** samples **damaged**.  

For more information about the samples see the file [**metadata/RNA_sacredfir.csv**](./metadata/RNA_sacredfir.csv).
Where the first column is the **Sample_name**, the second column stipulates the tree **Condition** (tolerant or damaged), the column **Seasson** specifies if the sample was collected in high O<sub>3</sub> concentration (*Contingency*) or middle O<sub>3</sub> concentration. And finally, the last column gives information about the **Year** in which the sample was collected.


## **Workflow**

![](workflow.png)

## **Repository structure**

This repository contains the following folders:

### `/bin`

Folder with the scripts to perform the analysis:

* **README.md**: Every step of the analysis detaily explained.
* **01_filter.sh:** Performs the quality analysis with FastQC, adapters deletion and paired-end read merging with *Trimmomatic*.
* **02_removehost.sh:** Deletes host reads with BWA by mapping the paired and unpaired reads to the reference transcriptome and saves the unmapped reads (paired and unpaired) with *samtools*.
* **03_assembly.sh:** Assamblies the reads into contigs using *metaSPADES*. **Work in progress**
* **04_binning.sh:** Groups the contigs into bins with *MaxBin*. **Work in progress**
* **05_kraken.sh:** Assigns taxonomic profile to reads and bins using *Kraken*. **Work in progress**
* **06_kaiju.sh:** Makes a taxonomic profile from reads and bins using *Kaiju*. **Work in progress**
* **07_prediction.sh:** Predicts the genes using *Prodigal*. **Work in progress**
* **08_annotation.sh:** Annotates the predicted genes by comparing them against the Non-Redundant (NR) protein database. **Work in progress**
  
### `/metadata`


Contains the **RNA_sacredfir.csv** file with information about the samples, and the subfolder `reports` with the output reports from *fastqc* and *multiqc* analyses. 

### `/parkinsonlabtutorial`

This folder was made to follow the [Parkinson's Lab tutorial](https://github.com/ParkinsonLab/Metatranscriptome-Workshop). Some of tutorial steps are gonna be used in my analyses. This folder will be deleted once the scripts are fully adapted.

### `/archive/`

Contains the slides from a [seminar](./archive/findfungi.pdf) were I spoke about the approaches to look for fungal signals in RNA-Seq data and the [Diagram](./archive/metawf.png) that I made to review the typical workflow followed in most of the metatranscriptomics analyses.

Also it contains the subfolder `tutorales` with the slides from each of the Master Project evaluations. **26/01/2020** only the first ([**0_Tutoral.pdf**](./archive/Tutorales/0_Tutoral.pdf)) has been presented.

### `/figures/`

This folder was made to enclose the `.jpeg` or `.tiff` images that result from each step of the analysis. 

It is subgrouped in folders:
* `bin` with the scripts that allow to make the figures. 
* `data` contains the information to make the figures as processed standard outputs, intermediate and final tables. 

The figures discussion will be put it in `.md` files. But until now, **26/01/2020** there is only one file ([Quality.md])(figures/Quality.md) file with the `01_filteredreads.jpeg` and `02_filteredreads.jpeg` discussion. 


### `/data`

This folder is in the `.gitignore` file, so it is not visible in this repository. This folder should contain the raw data and the subsequent analysis outputs. The content will remain hidden until publication. Once published the data will be available on [**OSF**](https://osf.io/xur7g/)(**PRIVATE PROJECT TEMPORARELY!!!!**).

<details>
<summary><b>To run the complete analysis I suggest you to subdivide this folder into the following structure:</b></summary>
<br>
<pre>
  

data
├── assembly
├── binning
├── filter
│   ├── adapters
│   ├── outputs
│   └── reference
├── function
│   ├── annotation
│   └── prediction
├── raw
├── reports
│   ├── mapped
│   └── trimmed
└── taxonomy
    ├── kaiju
    │   ├── contigs
    │   └── reads
    └── kraken
        ├── contigs
        └── reads

</pre>
</details>


## **References**

* de Bauer, M. de L., y Hernández-Tejeda, T. (2007). A review of ozone- induced effects on the forests of central Mexico.
Environmental Pollution, 147: 446–453.
* Pan, F., Su, T. J., Cai, S. M., & Wu, W. (2017). Fungal endophyte-derived Fritillaria unibracteata var. wabuensis: diversity, antioxidant capacities in vitro and relations to phenolic, flavonoid or saponin compounds. Scientific reports, 7: 1-14.
* Reyes-Galindo, V. (2019). Análisis transcriptómico de la tolerancia a ozono troposférico en Abies religiosa (Tesis de
maestría). Universidad Nacional Autónoma de México. México.

