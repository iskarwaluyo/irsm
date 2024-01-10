# IRSM CDMX

## Archivos para el análisis de datos
Dentro del directorio 'R' se encuentra el código ustilizado para el análisis de los datos para los mapas de la APP. 

1. Preparación de datos
Archivo: 1_data_prep.R, Librerías: sf
Función: Lectura y limpieza de datos, cáluclo de índicadores e índice IRSM.

3. Sub-conjunto de datos para el estudio
Archivo: 2_data_subset.R
Librerías: Ninguna
Función: Homologa algunos datos de categorización y crea un subconjunto de datos. El subconjunto excluye datos de establecimientos que no pertencen a alguna de las categorías de interés. 

4. Agregados por colonia y alcaldía
Archivo: 3_data_aggregates.R, Librerías: sf, rgeos, jsonlite
Función: Crea agregados de la información por colonia y alcaldía. Haciendo uniones espaciales con los datos de origen y datos geográficos del área de interés, en este caso la CDMX. 

5. Autocorrelación local
Archivo: 4_neighborhood_lisa.R, Librerías: sf, rgeoda, rgdal
Función: Función en R diseñada con rgeoda para evaluar la autocorrelación espacial local (LISA).

6. Análisis exploratorio de datos
Archivo: 5_borough_aggregate_analysis.R, Librerías: gridExtra, plyr, data.table, sf, ggplot2, forcats, dplyr, classInt, colorspace, wesanderson
Función: análisis exploratorio de datos de los resultados

7. Mapas de la LISA
Archivo: 6_lisa_plots.R, Librerías: ggplot2, gridExtra, plyr, sf
Función: Crea una tabla consolidada y mapas de los resultados del LISA por factor. En este caso para la CDMX para diferentes tipos de activiadad económica del DENUE. Crea mapas temáticos de acuerdo a los resultados de LISA.

8. Comparación por colonia y alcaldía
Archivo: 7_analisis_univariante.R, Librerías: summaryTools, DescTools, rcompanion, sf
Función: Análisis estadístico básico univariado para comparar resultados agregados por colonia, alcaldía y tipo de actividad económica.

## APP
Shiny App
Librerías: DT, leaflet, shiny, shinythemes, grDevices
Función; app para ejecutar en R-Shiny que permite la visualización de todos los resultados de este trabajo

## Deployment de la APP

- Decompress "foodwastemexicocity_DATA.zip"
- Decompress all ZIP files in the "RData" directory
- Rename directory where needed

## Fuentes de datos utilizadas

-   DENUE: <https://www.inegi.org.mx/temas/directorio/>
-   Alcaldías de la CDMX: <https://datos.cdmx.gob.mx/dataset/alcaldias/resource/8648431b-4f34-4f1a-a4b1-19142f944300>
-   Colonias de la CDMX: <https://datos.cdmx.gob.mx/dataset/densidad-de-poblacion-2010>

## Autor

Iskar J. Waluyo Moreno [waluyo\@usc.edu](mailto:waluyo@usc.edu)
Sitio web: <https://www.iskarwaluyo.wordpress.com>

## Derechos

This project is licensed under the [CC0 1.0 Universal](LICENSE.md) Creative Commons License - see the [LICENSE.md](LICENSE.md) file for details
