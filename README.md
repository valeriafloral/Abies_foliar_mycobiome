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

En cuanto al NMDS de la diversidad beta se observó que en el bosque nativo la diversidad se agrupa por el tipo de hospedero, mientras que en el bosque mixto no se observa una separación (Figura 2). Al incluir ambos factores en el test de Adonis se observa que existen diferencias significativas para el hospedero (0.026), para el tratamiento (0.022), pero no para su interacción (0.100).

**Referencias**

Yang, R. H., Su, J. H., Shang, J. J., Wu, Y. Y., Li, Y., Bao, D. P., & Yao, Y. J. (2018). Evaluation of the ribosomal DNA internal transcribed spacer (ITS), specifically ITS1 and ITS2, for the analysis of fungal diversity by deep sequencing. PloS one, 13(10).




**Referencias**

Yang, R. H., Su, J. H., Shang, J. J., Wu, Y. Y., Li, Y., Bao, D. P., & Yao, Y. J. (2018). Evaluation of the ribosomal DNA internal transcribed spacer (ITS), specifically ITS1 and ITS2, for the analysis of fungal diversity by deep sequencing. PloS one, 13(10).
