## Step 1: **Processing the reads**

Download the scripts:

``
tar -xvf precomputed_files.tar '*.py' > bin
``


Then I moved manually to the folder `bin`so I need to find a way to dot it since `tar`step.

To install the **FASTQC** image: 

```
docker run -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/fastqc:0.11.7--4 fastqc /data/mouse1.fastq
```


Install **Trimmomatic** image:


```
docker run --rm -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/trimmomatic:0.39--1 trimmomatic SE /data/mouse1.fastq /data/mouse1_trimmed.fastq ILLUMINACLIP:adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:50
```

Check the quality of the trimmed data:

```
docker run -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/fastqc:0.11.7--4 fastqc /data/mouse1_trimmed.fastq
```

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

Once **vsearch** was installaded, the code is:

```
vsearch --fastq_filter mouse1_trim.fastq --fastq_maxee 2.0 --fastqout mouse1_qual.fastq
```


The check the quality with **fastqc**:

```
docker run -v /Users/valfloral/Desktop/metatranscriptomics/data/:/data quay.io/biocontainers/fastqc:0.11.7--4 fastqc /data/mouse1_qual.fastq
```

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

