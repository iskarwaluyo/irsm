library(sf)

# CARGAR DATOS DE ALCALDIAS Y COLONIAS
directorio <- c("~/sigdata/archivos2/sigdata/PROYECTOS") # CAMBAIR A DIRECTORIO DE DESCARGA DEL ARCHIVO
setwd(directorio)

setwd("./irsm/DATA")

colonias <- st_read("./gis_data/COLONIAS/densidadpoblacion2010/densidadpoblacion2010_qUjGLm0.shp")


alcaldias <- st_read("./gis_data/ALCALDIAS/ALCALDIAS.shp")
alcaldias_pop <- read.csv(unz("./raw_data/poblacion_total_tasa_crecimiento_1.1.csv.zip", "poblacion_total_tasa_crecimiento_1.1.csv"), header = TRUE, sep = ",", fileEncoding = "latin1")
alcaldias_pop <- subset(alcaldias_pop, alcaldias_pop$Año == 2020 & alcaldias_pop$Alcaldia != 'CDMX')
alcaldias <- subset(alcaldias, alcaldias$CVE_ENT == '09')
alcaldias <- merge(alcaldias, alcaldias_pop, by.x = "NOM_MUN", by.y = "Alcaldia")

alcaldias$Población.total <- gsub(",", "", alcaldias$Población.total)
alcaldias$Población.total <- as.numeric(alcaldias$Población.total)
alcaldias$area_m2 <- as.numeric(st_area(alcaldias))

rm(alcaldias_pop)

# UNIFICAR LOS NOMBRES DE ALCALDÍAS
# ELEIMINAR ACENTOS
 # alcaldias$NOM_MUN <- toupper(alcaldias$NOM_MUN)
 # alcaldias$NOM_MUN <- gsub("Á", "A", alcaldias$NOM_MUN)
 # alcaldias$NOM_MUN <- gsub("É", "E", alcaldias$NOM_MUN)
 # alcaldias$NOM_MUN <- gsub("Í", "I", alcaldias$NOM_MUN)
 # alcaldias$NOM_MUN <- gsub("Ó", "O", alcaldias$NOM_MUN)
 # alcaldias$NOM_MUN <- gsub("Ú", "U", alcaldias$NOM_MUN)

setwd("./raw_data/")

denue_data <- read.csv(unz("denue_inegi_09_2021.csv.zip", "denue_inegi_09_2021.csv"), header = TRUE,
         sep = ",", fileEncoding = "latin1")

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd(directorio)
setwd("./irsm/R") 

# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())

## ADVERTENCIA.
## SE RECOMIENDA PARA R ES QUE SE REQUIERE APROXIMADAMENTE 3 VECES EL TAMAÑO DE LOS ARCHIVOS UTILIZADOS DE RAM
## LOS ARCHIVOS DEL DENUE Y DATOS SHAPE PESAN APROXIMADAMENTE 2 GB
## POR LO CUAL SE RECOMIENDA TENER 8 GB LIBRES DE MEMORIA RAM PARA CORRER EL ALGORITMO

# -------------------- CATEGORIZAR LOS ESTALBECIMIENTOS  -------------------------

  denue_data$CATEGORIA <- ""

  denue_data$CATEGORIA <- ifelse(
    grepl("^4311|^4312", denue_data$codigo_act),
    "COMERCIO AL POR MAYOR", denue_data$CATEGORIA)
  denue_data$CATEGORIA <- ifelse(
    grepl("^4611|^4612|^46211|^462111|^462112", denue_data$codigo_act),
    "COMERCIO AL POR MENOR", denue_data$CATEGORIA)
  denue_data$CATEGORIA <- ifelse(
    grepl("^6111|^6112|^6113|^6114|^6115|^6116|^6117", denue_data$codigo_act),
    "SERVICIOS EDUCATIVOS", denue_data$CATEGORIA)
  denue_data$CATEGORIA <- ifelse(
    grepl("^713", denue_data$codigo_act),
    "ESPARCIMIENTO", denue_data$CATEGORIA)
  denue_data$CATEGORIA <- ifelse(
    grepl("^721", denue_data$codigo_act),
    "ALOJAMIENTO", denue_data$CATEGORIA)
  denue_data$CATEGORIA <- ifelse(
    grepl("^722", denue_data$codigo_act),
    "ALIMENTOS", denue_data$CATEGORIA)
  denue_data$CATEGORIA <- ifelse(
    denue_data$CATEGORIA == "", "OTRA ACTIVIDAD", denue_data$CATEGORIA)

# -------------------- FACTOR EMP ---------------
  
  denue_data$FACTOR_EMP <- ""
  
  for(i in 1:nrow(denue_data)){
    if(denue_data[i,7] == "0 a 5 personas"){denue_data[i,44] = 1}
    if(denue_data[i,7] == "6 a 10 personas"){denue_data[i,44] = 2}
    if(denue_data[i,7] == "11 a 30 personas"){denue_data[i,44] = 3}
    if(denue_data[i,7] == "31 a 50 personas"){denue_data[i,44] = 4}
    if(denue_data[i,7] == "51 a 100 personas"){denue_data[i,44] = 5}
    if(denue_data[i,7] == "101 a 250 personas"){denue_data[i,44] = 6}
    if(denue_data[i,7] == "251 y más personas"){denue_data[i,44] = 7}
  }

  denue_data$FACTOR_EMP <- as.numeric(denue_data$FACTOR_EMP)

  # -------------------- FACTOR CLI ---------------
  
    denue_data$FACTOR_CLI <- ""
  
    for(i in 1:nrow(denue_data)){
      if(denue_data[i,43] == "ALIMENTOS"){denue_data[i,45] = 1}
      if(denue_data[i,43] == "ALOJAMIENTO"){denue_data[i,45] = 2}
      if(denue_data[i,43] == "COMERCIO AL POR MAYOR"){denue_data[i,45] = 3}
      if(denue_data[i,43] == "COMERCIO AL POR MENOR"){denue_data[i,45] = 3}
      if(denue_data[i,43] == "ESPARCIMIENTO"){denue_data[i,45] = 2}
      if(denue_data[i,43] == "SERVICIOS EDUCATIVOS"){denue_data[i,45] = 1}
      if(denue_data[i,43] == "OTRA ACTIVIDAD"){denue_data[i,45] = 0}
    }

  # -------------------- FACTOR TGE ---------------
  
    denue_data$FACTOR_TGE <- ""
  
    for(i in 1:nrow(denue_data)){
      if(denue_data[i,43] == "ALIMENTOS"){denue_data[i,46] = 3}
      if(denue_data[i,43] == "ALOJAMIENTO"){denue_data[i,46] = 2}
      if(denue_data[i,43] == "COMERCIO AL POR MAYOR"){denue_data[i,46] = 4}
      if(denue_data[i,43] == "COMERCIO AL POR MENOR"){denue_data[i,46] = 4}
      if(denue_data[i,43] == "ESPARCIMIENTO"){denue_data[i,46] = 3}
      if(denue_data[i,43] == "SERVICIOS EDUCATIVOS"){denue_data[i,46] = 1}
      if(denue_data[i,43] == "OTRA ACTIVIDAD"){denue_data[i,46] = 0}
    }
  
  # -------------------- FACTOR SIT ---------------
  
    denue_data$FACTOR_SIT <- ""

    for(i in 1:nrow(denue_data)){
      if(denue_data[i,43] == "ALIMENTOS"){denue_data[i,47] = 3}
      if(denue_data[i,43] == "ALOJAMIENTO"){denue_data[i,47] = 3}
      if(denue_data[i,43] == "COMERCIO AL POR MAYOR"){denue_data[i,47] = 1}
      if(denue_data[i,43] == "COMERCIO AL POR MENOR"){denue_data[i,47] = 2}
      if(denue_data[i,43] == "ESPARCIMIENTO"){denue_data[i,47] = 3}
      if(denue_data[i,43] == "SERVICIOS EDUCATIVOS"){denue_data[i,47] = 3}
      if(denue_data[i,43] == "OTRA ACTIVIDAD"){denue_data[i,47] = 0}
    }
  
    # denue_dataB <- denue_data # RESPALDO DE DATOS PROCESADOS

  # -------------------- CALCULO DE INDICES IRSM ---------------
  
    denue_data$IRSM_empleados <- as.numeric(denue_data$FACTOR_EMP) * as.numeric(denue_data$FACTOR_TGE)
    denue_data$IRSM_clientes <- as.numeric(denue_data$FACTOR_EMP) * as.numeric(denue_data$FACTOR_CLI) * as.numeric(denue_data$FACTOR_SIT) * as.numeric(denue_data$FACTOR_TGE)
    denue_data$IRSM <- denue_data$IRSM_empleados + denue_data$IRSM_clientes
    
# EXPORTAR RESULTADOS EN UN ARCHIVO RDATA
    setwd(directorio)
    setwd("./irsm/DATA/RData") 
    
    save(alcaldias, colonias, file = "spatial_data.RData")
    save(denue_data, file = "denue_data.RData")
    
# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
    setwd(directorio)
    setwd("./irsm/R")
    
# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())
    