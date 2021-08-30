# Metatranscriptomic fungal analysis of *Abies religiosa* exposed to an elevated tropospheric ozone concentration
Valeria Flores Almaraz


### **Symbolic links to the comun folder wich contains RAW reads**

In the folder `data/raw` make symbolic links to the files.


## **Processing raw reads** 

The [01_quality.sh](./01_quality,sh) script performs the quality analysis of the raw reads with **FastQC** then groups the results from quality analysis across all the samples into a single report  with **MultiQC**, does the trimming process with **Trimomatic** and once again, runs the quality analysis of the trimmed reads with **FastQC** and **multiQC**.

**MultiQC** needs **Python 2.7**, so a new environment should be made and activated. In order to use the same environment with the script, **FastQC**, **multiQC** and **Trimmomatic** sould be downloaded in the same environment:

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

The [02_removehost.sh](./02_removehost.sh) script maps the reads across the *Abies balsamea* transcriptome using the software **BWA**. The reference transcriptome was downloaded from NCBI (**Accession:** GGJG00000000 **Bioproject:** PRJNA437248). 

The [02_removehost.sh](./02_removehost.sh) script first make an index with the reference (**GGJG01.1.fasta**), then maps paired, R1_unpaired and R2_unpaired reads to the host reference transcriptome. The non-host reads are saved in files with the termination (**filtered**). Finally, the script makes a file that contains information about the reads that mapped and the reads that did not map to the reference.

```
sh 02_removehost.sh
```
## **Assembly** :construction:Work in progress:construction:

The [05_assembly](./05_assembly.sh)




## **Assign taxonomy using the reads**



### Kraken2

##### Kraken2 Database building

Choose a folder to download the database:

```
kraken2_db=“../../programas/kraken2_db”
```

Kraken2 database building

```
kraken2-build --download-taxonomy --db fungi
kraken2-build --download-library fungi --db fungi
kraken2-build --build --db fungi
```

##### Bracken-build

```
bracken-build -d ${kraken2_db}/fungi -t 4 -k 31 -l 100
```

##### Taxonomy classification

To concatenate files paired, R1_unpaired and R2_unpaired **non-host** `.fastq` files for every sample: 

```
for f in `ls ../data/filter/nonhost/ | grep “.fastq” | sed “s/_p_filtered.fastq//“ | sed “s/_R1_filtered.fastq//“ | sed “s/_R2_filtered.fastq//“| uniq`;
do cat ../data/filter/nonhost/${f}_p_filtered.fastq ../data/filter/nonhost/${f}_R1_filtered.fastq ../data/filter/nonhost/${f}_R2_filtered.fastq > ../data/filter/nonhost/${f}_cat.fastq;
done
```

Run the Kraken2 script:

```
sh 03_krakenreads.sh
sh 07_krakencontigs.sh
```

#### KAIJU 

Create a conda environment for Kaiju

##### Kaiju Database building

To construct the database:

```
cd ~
cd programas
mkdir kaiju_db
kaiju-makedb -s fungi
rm taxdump.tar.gz merged.dmp
```

Then, run the kraken classification scripts:

```
sh 04_kaijureads.sh
sh 08_kaijucontigs.sh
```

#### KRAKEN (contigs) :construction:Work in progress:construction:
#### KAIJU (contigs) :construction:Work in progress:construction:


##Export to R
###Combine Kraken2-Bracken reports

Combine reports:

```
for cat contigs;
do combine_mpa.py -i ../data/reports/kraken2/*_k2_${f}.txt -o ../data/reports/kraken2/combined_sp.txt;
done
```

Keep sequence only classified at species level:

```
for f in paired R1 R2 cat contigs;
do grep -E "(s__)|(#Classification)" -o ../data/reports/kraken2/combined_sp.tx > -o ../data/reports/diversity/kraken2.txt;
done
```


###Covert kaiju report to mpa

Make a kraken-report style to homogenize outputs:

```
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kraken-report --db ../../programas/krakenuniq_db/ ../data/reports/kaiju/${f}_kaiju_cat.out > ../data/reports/kaiju/kraken/${f}_ka_cat.out;
kraken-report --db ../../programas/krakenuniq_db/ ../data/reports/kaiju/${f}_contigs_kaiju.out > ../data/reports/kaiju/kraken/${f}_ka_contigs.out;
done
```

Make a mpa report style to easier export it to R:

```
for f in `ls ../data/filter/nonhost/ | grep ".fastq" | sed "s/_p_filtered.fastq//" | sed "s/_R1_filtered.fastq//" | sed "s/_R2_filtered.fastq//"| sed "s/_cat.fastq//" | uniq`;
do kreport2mpa.py -r ../data/reports/kaiju/kraken/${f}_ka_cat.out -o ../data/reports/kaiju/kraken/${f}_ka_cat.txt --no-intermediate-ranks --read_count --display-header;
kreport2mpa.py -r ../data/reports/kaiju/kraken/${f}_ka_contigs.out -o ../data/reports/kaiju/kraken/${f}_ka_contigs.txt --no-intermediate-ranks --read_count --display-header;
done

```

Combine:

```
for f cat contigs;
do combine_mpa.py -i ../data/reports/kaiju/kraken/*_ka_${f}.txt -o ../data/reports/kaiju/kraken/combined_sp.txt;
done

#Keep only classified at species level
grep -E "(s__)|(#Classification)" ../data/reports/kaiju/kraken/combined_sp.txt > ../data/reports/diversity/kaiju.tx
```

move files to diversity reports:

```
for f in ../data/reports/kraken2/kraken2.txt ../data/reports/kaiju/kraken/kaiju.txt;
do cp ${f} ../data/reports/diversity;
done
```


###In `data/reports/diversity/`:

Combine Kraken2-Bracken reports into one single final report:

```
for f in kraken2 kaiju;
do combine_mpa.py -i ../data/reports/diversity/${f}.txt -o ../data/reports/diversity/taxonomy_classification_sp.txt
```


# Currently I'am working on the following steps, so the scripts 04-10 haven't been started, concluded, tested or approved.




## **Function**
#### Gene prediction :construction:Work in progress:construction:
#### Gene annotation :construction:Work in progress:construction:

# References

*  Paolinelli, M., Escoriaza, G., Cesari, C., Garcia-Lampasona, S., & Hernandez-Martinez, R. (2020). Metatranscriptomic approach for microbiome characterization and host gene expression evaluation for “Hoja de malvón” disease in Vitis vinifera cv. Malbec.

