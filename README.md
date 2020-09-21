<<<<<<< HEAD
**Metagenómica**

**Introducción a la bioinformática e investigación reproducible para análisis genómicos**

En este repositorio se encuentran los análisis metagenómicos de 24 muestras de suelo rizosférico en sitios de bosque nativo (**N**) y mixto (**M**) de Quercus (**Q**) y Juniperus (**J**).

- En la carpeta **bin** se encuentra un script de bash para realizar el análisis con AMPtk que:

**1º** Pre-procesa los archivos FASTQ ensamblando los reads *forward *y *reverse* , además de eliminar *primers* y secuencias cortas.

**2º** Agrupa las secuencias con un 97% de similitud para asignarlas en OTUs.

**3º** Filtra de la tabla de OTUs el *Index bleed*

**4º** Asigna la taxonomía a cada OTU utilizando la base de datos de secuencias de UNITE ([https://unite.ut.ee/]())
 
Además contiene los archivos `.rmd` y `.html` con los reportes que se generaron sobre el análisis de diversidad.

- En la carpeta **data** se encuentra el archivo `.biom` resultado de correr el análisis de AMPtk con el filtro de mínimo 200 pb. 


**Explicación de los resultados obtenidos con AMPkt**

Al utilizar los filtros de 200 pb y 300 pb con el programa AMPtk se obtuvieron resultados diferentes. En el caso del filtro de 200 pb se obtuvo un total de 1257 taxa, mientras que utilizando el filtro de 300 pb se obtuvo un total de 329 taxa. 

De acuerdo con Yang *et al.* (2018) el ITS2 en hongos tiene una longitud promedio de 182 pb (en su estudio, con un rango de 14 pb a 730 pb). Por lo tanto, considero que utilizar el filtro de 200 pb es conveniente para este estudio, aunque se corre el riesgo de inflar la diversidad.


**Explicación de los resultados de diversidad**
Ascomycota y Basidiomycota son los Phyla predominantes tanto en sitios mixtos como nativos (Figura 1). En los sitios nativos *Juniperus* presenta una mayor abundancia de Ascomycota, en comparación con el sitio mixto. Mientras que en sitios mixtos *Quercus* tiene una mayor abundancia de Basidiomycota. Los resultados de la prueba de ANOVA nos indican que no hay diferencias significativas en la abundancia ni por hospedero (0.221), ni por tratamiento (0.797), ni en su interacción (0.262).

En cuanto al NMDS de la diversidad beta, se observó que en el bosque nativo la diversidad se agrupa por el tipo de hospedero, mientras que en el bosque mixto no se observa una separación (Figura 2). Al incluir ambos factores en el test de Adonis se observa que existen diferencias significativas para el hospedero (0.026), para el tratamiento (0.022), pero no para su interacción (0.100). 

**Referencias**

Yang, R. H., Su, J. H., Shang, J. J., Wu, Y. Y., Li, Y., Bao, D. P., & Yao, Y. J. (2018). Evaluation of the ribosomal DNA internal transcribed spacer (ITS), specifically ITS1 and ITS2, for the analysis of fungal diversity by deep sequencing. PloS one, 13(10).



=======
# **Role of endophytic fungi in the resistance of sacred fir (Abies religiosa) to air pollution**

This repository contains the data and the scripts used to in the present project.


**Aims**

1. To characterize the fungal communities present inside the leaves of healthy and damaged fir individuals 
2. To compare if there are differences in diversity and community composition related to air pollution. 
3. To search for fungal transcript in RNA-Seq transcriptomic data from healthy and damaged fir individuals to detect signals of differential expression and identify fungal genes involved in the resistance of tolerant individuals.


**Repository structure**

This repository contains the folders **bin**, **data**, **metadata** and **figures**.

* The folder **bin** contains the scripts divided in subfolders which contains the scripts for each step of the transcriptomic analysis. 
* The folder **data** contains the data used.
* The folder **metadata** contains the information about the samples.
* The folder **figures** contains the    results of the analysis organized in figures.  

**Data**

The data comes from Veronica Reyes Galindo's project [***Abies* vs ozone**](https://github.com/VeroIarrachtai/Abies_vs_ozone). 64 libraries were sequenced, resulting libraries were quality filtered. For more information about the samples see the folder [**metadata**](https://github.com/valeriafloral/Abies_fungal_endophytes/tree/master/metadata).

For this project 18 samples in total were used:

* **12** samples were obtained during the contingency season.
* **6** samples were obtained during the middle concentration season.

Of these samples:

* **9** samples were tolerant.
* **9** samples were damaged.  
>>>>>>> 38ade6a95d745e05796fc61cba94729181b04d6d
