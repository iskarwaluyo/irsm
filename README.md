# Evaluación del riesgo por acumulación de residuos sólidos municipales basado en la actividad comercial y de servicios en la Ciudad de México

## Resumen
La gestión integral de los residuos sólidos tiene por objeto disminuir sus impactos ambientales por lo que la consistencia y actualización en datos oficiales, así como la localización de las fuentes generadoras, cobra importancia para su manejo. Metodología: Este trabajo propone un Indice para evaluar el riesgo por acumulación de Residuos Sólidos Municipales (IRSM) en las Unidades Económicas Comerciales y de Servicios (UECS) de la Ciudad de México que permitiría evaluar la distribución territorial del riesgo de acumulación de RSM debido a la concentración de actividad económica en cada alcaldía y colonia. Resultados: Se encontró el mayor riesgo promedio por establecimiento en las alcaldías M. Hidalgo, B. Juárez, Cuajimalpa, Cuauhtémoc y A. Obregón. Sin embargo, el mayor IRSM acumulado no coincidió con estas. Conclusiones: El riesgo de acumulación de RSM varía de acuerdo con el tipo de actividad económica y tamaño de establecimiento. Dicho riesgo se evalúa con un índice que integra datos de diversas fuentes en información fácil de interpretar resultando en una herramienta que complementa la información existente sobre RSM para una mejor planeación de su manejo. 

## Archivos para el análisis de datos

- data_prep.R - Takes raw data and GIS data and creates RData files to run program (not necessary to run, just read RData files)
- data_analysis.R - Analyzes data and creates plots
- esda.R - Creates more plots and runs autocorrelation processes with rgeoda package. Also creates shape files of results.
- scratch.R - scratch file to try code
- foodwastemexicocity_DATA.zip - contains raw data, gis data, resulting shape files and RData files
- README.md - this text

## APP

## Deployment

Before running remember to:

- Decompress "foodwastemexicocity_DATA.zip"
- Decompress all ZIP files in the "RData" directory
- Rename directory where needed

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

## Data sources

-   BUSINESS DIRECTORY (DENUE): <https://www.inegi.org.mx/temas/directorio/>
-   BOROUGHS (ALCALDIAS): <https://datos.cdmx.gob.mx/dataset/alcaldias/resource/8648431b-4f34-4f1a-a4b1-19142f944300>
-   NEIGHBORHOODS W/ POPULATION DENSITY (COLONIAS): <https://datos.cdmx.gob.mx/dataset/densidad-de-poblacion-2010>

## Author

Iskar J. Waluyo Moreno [waluyo\@usc.edu](mailto:waluyo@usc.edu){.email}

## License

This project is licensed under the [CC0 1.0 Universal](LICENSE.md) Creative Commons License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Project for USC Spatial Sciences Institute
