# Evaluación del riesgo por acumulación de residuos sólidos municipales basado en la actividad comercial y de servicios en la Ciudad de México

## Resumen
La gestión integral de los residuos sólidos tiene por objeto disminuir sus impactos ambientales por lo que la consistencia y actualización en datos oficiales, así como la localización de las fuentes generadoras, cobra importancia para su manejo. Metodología: Este trabajo propone un Indice para evaluar el riesgo por acumulación de Residuos Sólidos Municipales (IRSM) en las Unidades Económicas Comerciales y de Servicios (UECS) de la Ciudad de México que permitiría evaluar la distribución territorial del riesgo de acumulación de RSM debido a la concentración de actividad económica en cada alcaldía y colonia. Resultados: Se encontró el mayor riesgo promedio por establecimiento en las alcaldías M. Hidalgo, B. Juárez, Cuajimalpa, Cuauhtémoc y A. Obregón. Sin embargo, el mayor IRSM acumulado no coincidió con estas. Conclusiones: El riesgo de acumulación de RSM varía de acuerdo con el tipo de actividad económica y tamaño de establecimiento. Dicho riesgo se evalúa con un índice que integra datos de diversas fuentes en información fácil de interpretar resultando en una herramienta que complementa la información existente sobre RSM para una mejor planeación de su manejo. 

## APP

## Deployment de la APP

- Decompress "foodwastemexicocity_DATA.zip"
- Decompress all ZIP files in the "RData" directory
- Rename directory where needed

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

## Built With

| Software       | Description                                                      | Version           |
|------------------------|------------------------|------------------------|
| R              | Statistical computing software                                   | 4.2.2             |
| Rstudio        | IDE for R                                                        | Spotted Wakerobin |
| ddplyr         | Grammar of data manipulation that helps solve common challenges. | 1.1-3             |
| R Color Brewer | Provides color schemes for maps designed by Cynthia Brewer       | 1.0.10            |
| ggplot2        | System for creating graphics based on "The Grammar of Graphics"  | 3.3.6             |
| sf             | Binds to GDAL for reading and writing geospatial data            | 1.0-8             |
| rgeoda         | R Library for Spatial Data Analysis                              | 0.0.9             |
| rgdal          | Bindings for 'Geospatial' Data Abstraction Library               | 1.5-32            |

## Fuentes de datos utilizadas

-   DENUE: <https://www.inegi.org.mx/temas/directorio/>
-   Alcaldías de la CDMX: <https://datos.cdmx.gob.mx/dataset/alcaldias/resource/8648431b-4f34-4f1a-a4b1-19142f944300>
-   Colonias de la CDMX: <https://datos.cdmx.gob.mx/dataset/densidad-de-poblacion-2010>

## Autor

Iskar J. Waluyo Moreno [waluyo\@usc.edu](mailto:waluyo@usc.edu)
Sitio web: <https://www.iskarwaluyo.wordpress.com>

## Derechos

This project is licensed under the [CC0 1.0 Universal](LICENSE.md) Creative Commons License - see the [LICENSE.md](LICENSE.md) file for details
