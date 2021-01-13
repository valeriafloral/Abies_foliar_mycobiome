## Metatranscriptomic fungal analysis of *Abies religiosa* exposed to an elevated tropospheric ozone concentration
Valeria Flores Almaraz


### **Symbolic links to the comun folder wich contains RAW reads**

In the folder `data/raw` make symbolic links to the commun folder where the files are


### **Processing the reads** 

The first script performs the quality analysis of the raw reads with **FastQC** then groups the results from quality analysis across all the samples into a single report  with **MultiQC**, does the trimming process with **Trimomatic** and once again, runs the quality analysis of the trimmed reads with **FastQC** and **Trimmomatic**.

**MultiQC** needs **Python 2.7**, so a new environment should be made and activate it. In order to use the same environment with the script, **FastQC**, **multiQC** and **Trimmomatic** sould be downloaded in the same environment:

```
conda create --name quality python=2.7
conda activate quality
conda install -c bioconda fastqc 
conda install -c bioconda multiqc
conda install -c bioconda trimmomatic
```

Run the script that first performs an analysis of the raw reads with **multiQC**, then makes the trimming process with **Trimmomatic** and finally makes the quality analysis of the trimmed reads:


```
sh 01_quality.sh
```

Exit the current conda environment:

```
conda deactivate
```

Open the `(base)`conda environment

```
conda activate
```
