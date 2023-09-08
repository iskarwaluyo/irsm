# SPATIAL AUTOCORRELATION
library(sf)
library(rgeoda)
library(rgdal)

# CARGAR DATOS
directorio <- c("~/sigdata/archivos2/sigdata/PROYECTOS")
setwd(directorio)

setwd("./irsm/DATA") 
# LOAD DATA
 load("./RData/stage3.RData")

 # SET ENVIRONMENT TO WORKING DIRECTORY
 setwd("../R")
 
# CLEAR RAM MEMORY
gc()

lisa_function <- function(sector){
 
  sector <<- sector
  if(sector == "Todos"){parameter_values <- denue_data_hood_aggregate["IRSM"]}
  if(sector == "Alimentos"){parameter_values <- denue_data_hood_aggregate["Alimentos_IRSM"]}
  if(sector == "Comercio al por menor"){parameter_values <- denue_data_hood_aggregate["Comercio.al.por.menor_IRSM"]}
  if(sector == "Comercio al por mayor"){parameter_values <- denue_data_hood_aggregate["Comercio.al.por.mayor_IRSM"]}
  if(sector == "Educacion"){parameter_values <- denue_data_hood_aggregate["Servicios.educativos_IRSM"]}
  if(sector == "Alojamiento"){parameter_values <- denue_data_hood_aggregate["Alojamiento_IRSM"]}
  if(sector == "Esparcimiento"){parameter_values <- denue_data_hood_aggregate["Esparcimiento_IRSM"]}
  
  spatial_weights <- queen_weights(denue_data_hood_aggregate, order=1, include_lower_order = FALSE, precision_threshold = 0)
  
  l <- local_moran(spatial_weights, parameter_values)
  lisa_colors <- lisa_colors(l)
  etiquetas <- c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")
  
  x <- cbind(l$c_vals, l$p_vals)
  
  colnames(x) <- c(paste(sector, "LISA", sep ="_"), paste(sector, "PVALUE", sep = "_"))
 
  denue_data_hood_aggregate <<- cbind(denue_data_hood_aggregate, x)
  
  plot(st_geometry(denue_data_hood_aggregate),
       col=sapply(lisa_clusters(l), function(x){return(lisa_colors[[x+1]])}),
       border = "#333333", lwd=0.2)
  title(main = paste0("Autocorrelacón espacial en ", sector, " Índice de Residuos Sólidos Municipales"))
  legend('bottomleft', legend = etiquetas, fill = lisa_colors, border = "#eeeeee")
  
}

# 1 for High-High, 2 for Low-Low, 3 for Low-High, and 4 for High-Low

# RUNNING CODE WITH DATA

lisa_function("Todos")
lisa_function("Alimentos")
lisa_function("Comercio al por menor")
lisa_function("Comercio al por mayor")
lisa_function("Alojamiento")
lisa_function("Educacion")
lisa_function("Esparcimiento")

# EXPORTAR RESULTADOS EN UN ARCHIVO RDATA
setwd(directorio)
setwd("./irsm/DATA/RData") 
save.image("./stage4.RData")
setwd("~/sigdata/archivos2/sigdata/PROYECTOS/irsm/R")

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd(directorio)
setwd("./irsm/R") 

# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())
