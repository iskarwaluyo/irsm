# CARGAR DATOS DEL PROCESO ANTERIOR

directorio <- c("~/sigdata/archivos2/sigdata/PROYECTOS")
setwd(directorio)

setwd("./irsm/DATA") 
load("./RData/stage2.RData")

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd("../R")
 
# TRANSFORMAR DATOS TIPO SF A SP PARA HACER CONTEO DE PUNTOS EN POLIGONO
library(sf)
sf_use_s2(FALSE)
denue_data_subset_sp <- st_as_sf(denue_data_subset, coords = c("longitud", "latitud"), crs = 4326)

# CONFIGURAR PROYECCIONES DE LOS DATOS
library(rgeos)
crs.project <- CRS("+init=epsg:4326")
alcaldias <- st_transform(alcaldias, "EPSG:4326")
colonias <- st_transform(colonias, "EPSG:4326")
denue_data_subset_sp <- st_transform(denue_data_subset_sp, "EPSG:4326")
denue_data_subset_sp$count <- 1

# LIMPIEZA DE POLIGONOS 
alcaldias <- st_make_valid(alcaldias)
colonias <- st_make_valid(colonias)

# CALCULA AGREGADOS DE LA INFORMACIÓN POR COLONIA (HOOD)
denue_data_hood_aggregate <- aggregate(denue_data_subset_sp[c("IRSM", "count")], colonias, sum)
denue_data_hood_aggregate <- cbind(colonias, denue_data_hood_aggregate)
denue_data_hood_aggregate$geometry.1 <- NULL
denue_data_hood_aggregate$IRSM_prom <- denue_data_hood_aggregate$IRSM / denue_data_hood_aggregate$count
denue_data_hood_aggregate$personas_por_estab <- denue_data_hood_aggregate$PobTot2020 / denue_data_hood_aggregate$count

denue_data_hood_aggregate$area_km2 <- as.numeric(st_area(denue_data_hood_aggregate)* 0.000001)

denue_data_hood_aggregate$ESTABLECIMIENTO_km2 <- denue_data_hood_aggregate$count / (denue_data_hood_aggregate$area_km2) 

denue_data_hood_aggregate[is.na(denue_data_hood_aggregate)] <- 0

#NOTA: Datos de Poblacion segun son 2020 de Datos Abiertos CDMX traen encabezado de 2010
#NOTA: Area superficial total es menor que datos oficiales porque no se suman colonias sin UECS

sector_aggregate_function <- function(categoria){
  nombre <- paste0(categoria) 
  x <- aggregate(
    subset(denue_data_subset_sp, denue_data_subset_sp$CATEGORIA == paste(categoria))[c("IRSM", "count")], colonias, sum)
  x[is.na(x)] <- 0
  x$geometry<- NULL 
  colnames(x) <- c(paste(nombre, "IRSM", sep ="_"), paste(nombre, "count", sep = "_"))
  denue_data_hood_aggregate <<- cbind(denue_data_hood_aggregate, x)
}

sector_aggregate_function("Alimentos")  
sector_aggregate_function("Comercio al por menor")  
sector_aggregate_function("Comercio al por mayor")  
sector_aggregate_function("Servicios educativos")  
sector_aggregate_function("Alojamiento")  
sector_aggregate_function("Esparcimiento")  

library(dplyr)
denue_data_borough_aggregate <- denue_data_hood_aggregate %>%
  group_by(alcaldia) %>%
  dplyr::summarise(PobTot2020 = sum(PobTot2020),
                   area_km2 = round(sum(area_km2),2),
                   colonias = n(),
                   uecs = sum(count),
                   personas_por_estab = round(sum(PobTot2020)/sum(count),2),
                   ESTABLECIMIENTO_km2 = round(sum(count)/sum(area_km2),2),
                   IRSM = sum(IRSM),
                   IRSM_prom = sum(IRSM_prom),
                   Alimentos_IRSM = sum(Alimentos_IRSM),
                   Alimentos_count = sum(Alimentos_count),
                   Comercio.al.por.menor_IRSM = sum(Comercio.al.por.menor_IRSM),
                   Comercio.al.por.menor_count = sum(Comercio.al.por.menor_count),
                   Comercio.al.por.mayor_IRSM = sum(Comercio.al.por.mayor_count),
                   Servicios.educativos_IRSM = sum(Servicios.educativos_IRSM),
                   Servicios.educativos_count = sum(Servicios.educativos_count),
                   Alojamiento_IRSM = sum(Alojamiento_IRSM),
                   Alojamiento_count = sum(Alojamiento_count),
                   Esparcimiento_IRSM = sum(Esparcimiento_IRSM),
                   Esparcimiento_count = sum(Esparcimiento_count),
  ) %>%
  mutate(perc = round(uecs/sum(uecs),2),
         cumulativo_count = cumsum(uecs))

# EXPORTA RESULTADOS A UN ARCHIVO .CSV Y GEOJSON
setwd(directorio)
setwd("./irsm/DATA/RESULTS") 

st_write(denue_data_subset_sp, "denue_data_subset.geojson", delete_dsn = T)
st_write(denue_data_hood_aggregate, "denue_data_hood_aggregate.geojson", delete_dsn = T)
st_write(denue_data_borough_aggregate, "denue_data_borough_aggregate.geojson", delete_dsn = T)

write.csv(st_drop_geometry(denue_data_borough_aggregate), file = "denue_data_borough_aggregate.csv")
write.csv(st_drop_geometry(denue_data_hood_aggregate), file = "denue_data_hood_aggregate.csv")

rm(denue_data_subset_sp)

# PRUEBA PARA EXPORTAR ARCHIVOS A UN ARCHIVO TIPO .JSON (NO ES NECESARIO CORRER)
# export <- export[c(4, 8, 8, 10, 230, 231, 232, 233)]
# export <- toJSON(export)
# write(export, "test.json")
# setwd("~/sigdata/archivos2/sigdata/PROYECTOS/irsm")

# EXPORTAR RESULTADOS EN UN ARCHIVO RDATA
setwd(directorio)
setwd("./irsm/DATA/RData") 
save.image("./stage3.RData")

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd(directorio)
setwd("./irsm/R") 

# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())

