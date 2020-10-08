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


## Step 1: **Processing the reads**

Download the scripts:

``
tar -xvf precomputed_files.tar '*.py' > bin
``


To install the **FASTQC** image: 

```
docker run -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/fastqc:0.11.7--4 fastqc /data/mouse1.fastq
```

[Raw FastQC report](https://drive.google.com/file/d/1yyU2otzkEU3lirDo-03fotXScnYWdTuM/view?usp=sharing)

![](raw_fastq_1)
![](raw_fastq_2)
![](raw_fastq_3)



Install **Trimmomatic** image to remove the adapters and low quality sequences:


```
docker run --rm -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/trimmomatic:0.39--1 trimmomatic SE /data/mouse1.fastq /data/mouse1_trimmed.fastq ILLUMINACLIP:adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
```

Check the quality of the trimmed sequences:

```
docker run -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/fastqc:0.11.7--4 fastqc /data/mouse1_trimmed.fastq
```
[Trimmed FASTQC report](https://drive.google.com/file/d/1N6L854lkK5eCffXEOUw927d6fnUQcpW7/view?usp=sharing)

**vsearch** is used to impose an overall read quality threshold to ensure that all reads being used in our analyses are of sufficiently error-free

I had an error trying to run this code for using **vsearch** in Docker:


```
docker run -v --rm /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/comp-bio-aging/vsearch vsearch --fastq_filter /data/mouse1_trim.fastq --fastq_maxee 2.0 --fastqout mouse1_qual.fastq   
```

ERROR:

![Error](error.png)


So I used conda to download **vsearch**

```
conda install -c bioconda vsearch
```

And then:

```
conda install -c bioconda/label/cf201901 vsearch
```

Once **vsearch** was installaded, I used the code below: 

```
vsearch --fastq_filter mouse1_trim.fastq --fastq_maxee 2.0 --fastqout mouse1_qual.fastq
```


Then check the quality with **fastqc**:

```
docker run -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/fastqc:0.11.7--4 fastqc /data/mouse1_qual.fastq
```

[vsearch quality report](https://drive.google.com/file/d/1mm-aPyjpKWfMb7OMmn1ISDh2yUNBZ9bJ/view?usp=sharing)
 
##Step 2: **Remove duplicate reads**

Install the CD-HIT-Auxtools using bioconda 

Do to the home directory

```
cd ~/
```

Intall the package:

```
conda install cd-hit-auxtools
```

Then run

```
cd-hit-dup -i ../data/mouse1_qual.fastq -o data/mouse1_unique.fastq
```

##Step 3: **Remove vector contamination**

