# Metatranscriptomics [tutorial from Parkinson's Lab](https://github.com/ParkinsonLab/Metatranscriptome-Workshop)



**Valeria Flores Almaraz**

## **Prerequisites*

Download the precomputed files from Parkinson's lab repository:

```
curl https://github.com/ParkinsonLab/2017-Microbiome-Workshop/releases/download/Extra/precomputed_files.tar.gz > precomputed_files.tar.gzcurl https://github.com/ParkinsonLab/2017-Microbiome-Workshop/releases/download/Extra/precomputed_files.tar.gz > precomputed_files.tar.gz
```


Software:

* **Docker**
* **Conda**
* **FastQC**
* **Trimmomatic**
* **vsearch**
* **CD-HIT-Auxtools**
* **BWA**
* **Blat**
* **Samtools**
* **blast+**

**Start**

```
conda activate
```

## **Processing the reads**

Extract the python scripts and save it in data/pyton_scripts folder

```
tar -xvf precomputed_files.tar '*.py'
```

Check the quality of raw data, use trimmomatic to remove the low quality sequences

Copy adapters to data folder

```
cp /Users/valfloral/opt/anaconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/adapters/TruSeq2-SE.fa ../../data/adapters 
```

Run the script for fastqc, trimmomatic and vsearch

```
sh 0_processing.sh
```

## Step 1: **Remove duplicate reads**

```
sh 1_duplicate
```


## Step 2: **Remove vector contaminantion**
Download the dataset for identifying contaminating vector and adapter sequences

```
curl -L ftp://ftp.ncbi.nih.gov/pub/UniVec/UniVec_Core -o ../../metadata/index/vector_contamination/UniVec_Core
```

Generate an index of these sequences for BWA an BLAT

```
bwa index -a bwtsw ../../metadata/index/vector_contamination/UniVec_Core
samtools faidx ../../metadata/index/vector_contamination/UniVec_Core
makeblastdb -in ../../metadata/index/vector_contamination/UniVec_Core -dbtype nucl
```

Run the script for remove vector contamination

```
sh 2_vector.sh

