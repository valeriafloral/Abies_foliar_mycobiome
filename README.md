# <div align="center"> Role of endophytic fungi in the resistance of sacred fir (*Abies religiosa*) to air pollution </div>

### <div align="center">  :construction::construction::construction::construction: REPOSITORY UNDER CONSTRUCTION :construction::construction::construction::construction: </div>






Air pollution by tropospheric ozone (O<sub>3</sub>) is causing the strong decline of sacred fir (*Abies religiosa*) in peripheral areas of Mexico City (de Bauer y Hernández-Tejeda, 2007). However, within high contaminated zones, variation in the level of damage to air pollution was detected among fir individuals. These results suggest that there is genetic variability related to tolerance to O<sub>3</sub> (Reyes-Galindo, 2019). Due to their effects on plant resistance to abiotic stresses, it is very likely that endophytic fungi present inside fir leaves are involved in resistance to air pollution (Pan *et al.* 2017).

In this repository, you will find the workflow of a metatranscriptomics analysis from *Abies religiosa* indivuals exposed to high O<sub>3</sub> concentrations and showed 2 different phenotypes (tolerant and damaged). 

## **Aims**

1. To characterize the diversity of fungal endophytes inside the leaves of tolerant and damaged fir trees.
2. To detect differential expression of fungal genes from tolerant and damaged fir trees. 
3. To identify fungal genes putitive involved in the resistance to air pollution caused by (O<sub>3</sub>).

## **Prerequisites**

**SOFTWARE**

* [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [Trimmomatic-0.39](http://www.usadellab.org/cms/?page=trimmomatic)
* [BWA-0.7.17](http://bio-bwa.sourceforge.net)
* [samtools-1.10](http://www.htslib.org)
* [SPADES-3.14.1](https://cab.spbu.ru/software/spades/)
* [MaxBin2-2.2.4-1](https://sourceforge.net/projects/maxbin2/)
* [Kraken2](https://ccb.jhu.edu/software/kraken2/)
* [krona 2.7.1](https://github.com/marbl/Krona/wiki)
* [Kaiju-1.7.3](http://kaiju.binf.ku.dk)
* [Prodigal-2.6.3](https://github.com/hyattpd/Prodigal)
* [Diamond-2.0.5](https://github.com/bbuchfink/diamond)	


**R Libraries**

* [tidyverse](https://www.tidyverse.org)

## **Data**

The data comes from Veronica Reyes Galindo's project [***Abies* vs ozone**](https://github.com/VeroIarrachtai/Abies_vs_ozone). 

In this project **16** samples in total were used:

* **8** samples **tolerant**.
* **8** samples **damaged**.  

For more information about the samples see the file [**metadata/RNA_sacredfir.csv**](./metadata/RNA_sacredfir.csv).
Where the columns:

* **Sample_name:** name with which the samples are identified. 
* **Condition:** tree condition(tolerant or damaged).
* **Seasson:** seasson in which the sample was collected (high O<sub>3</sub> concentration (*Contingency*) or middle O<sub>3</sub> concentration).
* **Year:** year of sample collection.


## **Workflow**

![](workflow.png)

## **Repository structure**

This repository has the following structure:


```

Abies_fungal_endophytes-master
├── LICENSE
├── README.md
├── archive
│   ├── Tutorales
│   │   └── 0_Tutoral.pdf
│   ├── findfungi.pdf
│   └── metawf.png
├── bin
│   ├── 01_quality.sh
│   ├── 02_removehost.sh
│   ├── 03_krakenreads.sh
│   ├── 04_kaijureads.sh
│   ├── 05_assembly.sh
│   ├── 06_binning.sh
│   ├── 07_krakencontigs.sh
│   ├── 08_kaijucontigs.sh
│   ├── 09_prediction.sh
│   ├── 10_annotation.sh
│   └── README.md
├── figures
│   ├── 01_filteredreads.jpeg
│   ├── 02_filteredreads.jpeg
│   ├── Quality.md
│   └── bin
│       ├── cleanreadstable.R
│       ├── extract_trimmomatic.sh
│       └── quality_barplot.R
├── metadata
│   ├── RNA_sacredfir.csv
│   └── reports
│       ├── R1_paired_multiqc_report.html
│       ├── R1_unpaired_multiqc_report.html
│       ├── R2_paired_multiqc_report.html
│       ├── R2_unpaired_multiqc_report.html
│       ├── raw_multiqc_report.html
│       └── trimmomatic.txt
├── parkinsonlabtutorial
│   ├── README.md
│   ├── bin
│   │   ├── python_scripts
│   │   │   ├── 1_BLAT_Filter.py
│   │   │   ├── 2_Infernal_Filter.py
│   │   │   ├── 3_Reduplicate.py
│   │   │   ├── 4_Constrain_Classification.py
│   │   │   ├── 5_Contig_Map.py
│   │   │   ├── 6_BWA_Gene_Map.py
│   │   │   ├── 6_modified.py
│   │   │   ├── 7_Diamond_Protein_Map.py
│   │   │   ├── 8_Gene_EC_Map.py
│   │   │   └── 9_RPKM.py
│   │   └── shell_scripts
│   │       ├── 0_quality.sh
│   │       ├── 1_duplicate.sh
│   │       ├── 2_vector.sh
│   │       ├── 3_host.sh
│   │       ├── 4_removerrna.sh
│   │       ├── 5_rereplication.sh
│   │       └── unpaired.sh
│   └── metadata
│       └── fastqc
│           ├── mouse1_fastqc.html
│           ├── mouse1_fastqc.zip
│           ├── mouse1_mRNA_fastqc.html
│           ├── mouse1_mRNA_fastqc.zip
│           ├── mouse1_trimmed_fastqc.html
│           └── mouse1_trimmed_fastqc.zip
└── workflow.png

```

### `/archive`

Contains the slides from a [seminar](./archive/findfungi.pdf) were I spoke about the approaches to look for fungal signals in RNA-Seq data and the [Diagram](./archive/metawf.png) that I made to review the typical workflow followed in most of the metatranscriptomics analyses.

Also it contains the subfolder `tutorales` with the slides from each of the Master Project evaluations. By **26/01/2021** only the first ([**0_Tutoral.pdf**](./archive/Tutorales/0_Tutoral.pdf)) has been presented.

### `/bin`

Folder with the scripts to perform the analysis:

* **README.md**: Every step of the analysis detaily explained.
* **01_filter.sh:** Performs the quality analysis with FastQC, adapters deletion and paired-end read merging with *Trimmomatic*.
* **02_removehost.sh:** Deletes host reads with BWA by mapping the paired and unpaired reads to the reference transcriptome and saves the unmapped reads (paired and unpaired) with *samtools*.
* **03_krakenreads.sh:** Makes a taxonomic profile to reads using *Kraken*. :construction:**Work in progress**:construction:
* **04_kaijureads.sh:** Makes a taxonomic profile from reads using *Kaiju*. :construction:**Work in progress**:construction:
* **05_assembly.sh:** Assamblies the reads into contigs using *metaSPADES*. :construction:**Work in progress**:construction:
* **06_binning.sh:** Groups the contigs into bins with *MaxBin*. :construction:**Work in progress**:construction:
* **07_krakencontigs.sh:** Makes a taxonomic profile from bins using *Kraken*. :construction:**Work in progress**:construction:
* **08_kaijucontigs.sh:** Makes a taxonomic profile from bins using *Kaiju*. :construction:**Work in progress**:construction:
* **09_prediction.sh:** Predicts the genes using *Prodigal*. :construction:**Work in progress**:construction:
* **10_annotation.sh:** Annotates the predicted genes by comparing them against the Non-Redundant (NR) protein database. :construction:**Work in progress**:construction:

### `/figures`

This folder was made to enclose the `.jpeg` or `.tiff` images that result from each step of the analysis. 

It is subgrouped in folders:
* `bin` with the scripts that allow to make the figures. 
* `data` contains the information to make the figures as processed standard outputs, intermediate and final tables. 

The figures discussion will be put it in `.md` files. But until now, **26/01/2021** there is only one file ([Quality.md](figures/Quality.md)) with the `01_filteredreads.jpeg` and `02_filteredreads.jpeg` discussion. 
  
### `/metadata`


Contains the [**RNA_sacredfir.csv**](./metadata/RNA_sacredfir.csv) table with information about the samples, and the subfolder `reports` with the reports from *Trimmomatic* and *multiqc* analyses. 

### `/parkinsonlabtutorial`

This folder was made to follow the [Parkinson's Lab tutorial](https://github.com/ParkinsonLab/Metatranscriptome-Workshop). Some of tutorial steps are gonna be used in this work. This folder will be deleted once the scripts are fully adapted. The tutorial has a README file that explain each step of the analysis, but it is not finished yet. The `/bin` folder has the phyton (made by the author) and adapted shell scripts. In the `/metadata` folder there are the *trimmomatic* reports.

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

