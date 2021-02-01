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
As I was having issues when trying to build de kraken database with **Kraken2**, I've decided to use **Krakenuniq**. The problem persisted, so I use an alternative way to build the database.

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


To download the `taxonomy/nodes.dmp` and the `taxonomy/names.dmp` use the command:

```
krakenuniq-download --db $krakenuniq_db taxonomy
```

Download the indexed database containing all the NCBI genomes from archeas, bacteria, virus and fungi in NT DB in the `krakenuniq_db` folder. This command will download the `database.kbd` and the `database.idx`.

```
wget -c ftp://ftp.ccb.jhu.edu/pub/software/krakenuniq/Databases/nt/*
```

If in the folder, there are the 4 files (`taxonomy/nodes.dmp`, `taxonomy/names.dmp`,`database.kbd` and `database.idx`) it is not necessary to run de `kraken-build` command. The kraken classification can be runned. The `03_krakenreads.sh` runs with a subset. The complete script is not finished yet. 

Run the Kraken script **Work in progress**:

```
sh 03_krakenreads.sh
```
To graphic visualize the report use **Krona**.

Create a variable with the folder in which **Krona** host the program files. I download **Krona** using **miniconda**, so, the **Krona** folder is in `~/miniconda3/envs/krona/opt/krona/taxonomy`.

```
taxonomy="~/miniconda3/envs/krona/opt/krona/taxonomy"
```
Build the taxonomy:

```
ktUpdateTaxonomy.sh $taxonomy
```

Run krona ** This is a test command, the loop for all samples has not been tested **


```
for i in tolerant damaged;
do ktImportTaxonomy ../data/reports/kraken/kraken${i}test.tsv -t 7 -s 6 -o ../data/reports/kraken/kraken${i}.html ;
done
```
To run multiple samples I think I can run a loop with tolerant and damaged samples separately:

```
##Tolerant
for i in TOLERANTSAMPLESNAMES;
do ktImportTaxonomy -t 7 -s 6  ${i}.tsv -o toleratkrona.html;
done

###Damaged
for i in DAMAGEDSAMPLESNAMES;
do ktImportTaxonomy -t 7 -s 6  ${i}.tsv -o damagedkrona.html;
done
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

