# CARGAR DATOS DE DEL PROCESO ANTERIOR
directorio <- c("~/sigdata/archivos2/sigdata/PROYECTOS")
setwd(directorio)

setwd("./irsm/DATA")

load("./RData/spatial_data.RData")
load("./RData/denue_data.RData")

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd("../R")

# ASIGNAR NOMBRES A CATEGORIAS PARA GRAFICAS Y MAPAS
denue_data$CATEGORIA <- gsub("ALIMENTOS", "Alimentos", denue_data$CATEGORIA)
denue_data$CATEGORIA <- gsub("ALOJAMIENTO", "Alojamiento", denue_data$CATEGORIA)
denue_data$CATEGORIA <- gsub("COMERCIO AL POR MENOR", "Comercio al por menor", denue_data$CATEGORIA)
denue_data$CATEGORIA <- gsub("COMERCIO AL POR MAYOR", "Comercio al por mayor", denue_data$CATEGORIA)
denue_data$CATEGORIA <- gsub("ESPARCIMIENTO", "Esparcimiento", denue_data$CATEGORIA)
denue_data$CATEGORIA <- gsub("SERVICIOS EDUCATIVOS", "Servicios educativos", denue_data$CATEGORIA)
denue_data$CATEGORIA <- gsub("OTRA ACTIVIDAD", "Otra actividad", denue_data$CATEGORIA)

denue_data$per_ocu <- gsub("0 a 5 personas", "1 (0 a 5)", denue_data$per_ocu)
denue_data$per_ocu <- gsub("6 a 10 personas", "2 (6 a 10)", denue_data$per_ocu)
denue_data$per_ocu <- gsub("11 a 30 personas", "3 (11 a 30)", denue_data$per_ocu)
denue_data$per_ocu <- gsub("31 a 50 personas", "4 (31 a 50)", denue_data$per_ocu)
denue_data$per_ocu <- gsub("51 a 100 personas", "5 (51 a 100)", denue_data$per_ocu)
denue_data$per_ocu <- gsub("101 a 250 personas", "6 (101 a 250)", denue_data$per_ocu)
denue_data$per_ocu <- gsub("251 y más personas", "7 (>251)", denue_data$per_ocu)

# ELIMINAR LOS DATOS DE "OTRAS ACTIVIDADES"
denue_data_subset <- subset(denue_data, denue_data$CATEGORIA != "Otra actividad")
denue_data_subset$IRSM <- denue_data_subset$IRSM_empleados + denue_data_subset$IRSM

denue_data_subset$IRSM <- round((denue_data_subset$IRSM - min(denue_data_subset$IRSM))/((max(denue_data_subset$IRSM) - min(denue_data_subset$IRSM))),2)


rm(denue_data)

# EXPORTAR RESULTADOS EN UN ARCHIVO RDATA
setwd(directorio)
setwd("./irsm/DATA/RData") 

save.image("./stage2.RData")

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd(directorio)
setwd("./irsm/R")

# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())