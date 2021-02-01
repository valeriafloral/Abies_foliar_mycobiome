# Metatranscriptomic fungal analysis of *Abies religiosa* exposed to an elevated tropospheric ozone concentration
Valeria Flores Almaraz


### **Symbolic links to the comun folder wich contains RAW reads**

In the folder `data/raw` make symbolic links to the files.


## **Processing the reads** 

The [01_quality.sh](./01_quality,sh) script performs the quality analysis of the raw reads with **FastQC** then groups the results from quality analysis across all the samples into a single report  with **MultiQC**, does the trimming process with **Trimomatic** and once again, runs the quality analysis of the trimmed reads with **FastQC** and **multiQC**.

**MultiQC** needs **Python 2.7**, so a new environment should be made and activate it. In order to use the same environment with the script, **FastQC**, **multiQC** and **Trimmomatic** sould be downloaded in the same environment:

```
conda create --name quality python=2.7
conda activate quality
conda install -c bioconda fastqc 
conda install -c bioconda multiqc
conda install -c bioconda trimmomatic
```

The adapters must be copied to another folder inside `data/filter/`

```
cp /LUSTRE/Genetica/valeria/miniconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/adapters/TruSeq3-PE-2.fa ../data/filter/adapters/
```

Run the [01_quality,sh](./01_quality,sh) script:

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

## **Remove the host reads** 

The [02_removehost.sh](./02_removehost.sh) script maps the reads across the *Abies balsamea* transcriptome using the software **BWA**. The reference transcriptome has to be downloaded from NCBI (**Accession:** GGJG00000000 **Bioproject:** PRJNA437248). 

The [02_removehost.sh](./02_removehost.sh) script first make an index with the reference (**GGJG01.1.fasta**), then maps the paired, the R1_unpaired and the R2_unpaired reads. The reads that don't map to the reference are saved in files with the termination (**bulk**). Finally, the script make a file that contains information about the reads that mapped and the reads that map and did not map to the reference.

```
sh 02_removehost.sh
```
# Currently I'am working on the following steps, so the scripts 03-10 haven't been started, concluded, tested or approved.


## **Assign taxonomy using the reads**



#### KRAKEN :construction:Work in progress:construction:
I have issues when trying to buil de kraken database with **Kraken2**, so I've decided to use **Krakenuniq**. The proble persisted, and I use an alternative way to build the database.

For this part of tha analysis I used part of the Paolinelli *et al.* 2020 code that can be found in [**this**](https://bitbucket.org/quetjaune/rnaseq_malbec_082018/src/master/Malbec_metatranscriptomic_analysis.md) repository

Choose one folder to download the database
```
krakenuniq="../../programas/krakenuniq_db"
```
In the database folder, there must be at least 4 files:
* **database.kdb:** Contains the k-mer to taxon mappings
* **database.idx:** Contains minimizer offset locations in database.kdb
* **taxonomy/nodes.dmp:** Taxonomy tree structure + ranks
* **taxonomy/names.dmp:** Taxonomy names


For download the `taxonomy/nodes.dmp`and the `taxonomy/names.dmp:`use the command:

```
krakenuniq-download --db $krakenuniq_db taxonomy
```

In the `krakenuniq_db` folder download the indexed database containing all the NCBI genomes from archeas, bacteria, virus and fungi in NT DB. This will download the `database.kbd` and the `database.idx`.

```
wget -c ftp://ftp.ccb.jhu.edu/pub/software/krakenuniq/Databases/nt/*
```

If in the folder, there are the 4 files it is not necessary to run de `kraken-build` command. The kraken script can be runned. The `03_krakenreads.sh` runs with a subset. The complete script is not finished yet. 

Run the Kraken script **Work in progress**:

```
sh 03_krakenreads.sh
```

Make a Krona graph, first we have to update all the files regarding taxonomy or accesions IDs through the Krona's `updateTaxonomy.sh` and `updateAccession.sh`, later from Krakenuniq output (REPORTFILE.tsv) the next command is used for each sample:

```
ktImportTaxonomy -o m26_s6_kraken.krona.html -t 7 -s 6 REPORTFILE.tsv 
```


#### KAIJU :construction:Work in progress:construction:

## **Assign taxonomy using contigs**
#### Assembly :construction:Work in progress:construction:
#### Binning :construction:Work in progress:construction:
#### KRAKEN (contigs) :construction:Work in progress:construction:
#### KAIJU (contigs) :construction:Work in progress:construction:

## **Function**
#### Gene prediction :construction:Work in progress:construction:
#### Gene annotation :construction:Work in progress:construction:

# References

*  Paolinelli, M., Escoriaza, G., Cesari, C., Garcia-Lampasona, S., & Hernandez-Martinez, R. (2020). Metatranscriptomic approach for microbiome characterization and host gene expression evaluation for “Hoja de malvón” disease in Vitis vinifera cv. Malbec.

