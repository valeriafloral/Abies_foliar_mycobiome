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
```

## Step 3: **Remove host reads**

Download a mouse genome database from Ensembl

```
curl -L ftp://ftp.ensembl.org/pub/current_fasta/mus_musculus/cds/Mus_musculus.GRCm38.cds.all.fa.gz -o ../../metadata/Mmusculus_genome/Mus_musculus.GRCm38.cds.all.fa.gz
gzip -d ../../metadata/Mmusculus_genome/Mus_musculus.GRCm38.cds.all.fa.gz
mv ../../metadata/Mmusculus_genome/Mus_musculus.GRCm38.cds.all.fa ../../metadata/Mmusculus_genome/mouse_cds.fa
```

Repeat the steps above used to generate an index for these sequences for BWA an BLAT

Make index:

```
bwa index -a bwtsw ../../metadata/Mmusculus_genome/mouse_cds.fa
samtools faidx ../../metadata/Mmusculus_genome/mouse_cds.fa
makeblastdb -in ../../metadata/Mmusculus_genome/mouse_cds.fa -dbtype nucl
```

Run the script for remove host reads:

```
sh 3_host.sh
```

## Step 4: **Remove abundant rRNA sequences**

rRNA genes must be screened out to avoid lengthy downstream processing times for assembly and annotations
On a single core, infernal can take as much as 4 hours for ~100,000 reads. This step was skipped and use a precomputed file `mouse1_rRNA.infernalout`from the `tar` file precomputed_files.tar.gz`

```
tar -xzf ../../precomputed/precomputed_files.tar.gz mouse1_rRNA.infernalout > ../../data/qual/mouse1_rRNA.infernalout
```

Then run the script that uses Infernal precomputed output

```
sh 4_removerrna.sh
```

## Step 5: **Remove abundant rRNA sequences**

After removing contaminants, host sequences, and rRNA, we need to replace the previously removed replicate reads back in our data set:

```
sh 5_rereplication.sh
```

