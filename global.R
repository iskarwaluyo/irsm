# CARGAR LIBRERIAS
library(plyr) # CARGAR LIBRER?A plyr
library(readr) # CARGAR LIBRER?A readr
library(rgdal)
library(dplyr)
library(ggplot2)
library(DT)
library(leaflet)
library(shiny)
library(shinythemes)
library(sf)
library(grDevices)
library(plotly)

# LOAD DATA

# setwd("~/sigdata/archivos2/sigdata/PROYECTOS/foodwastemexicocity/R/residuos_cdmx_app/DATA")
#LOCAL RUN
#load("denue_data_aggregate.RData")
#denue_data_subset <- read.csv("denue_data_subset.csv")

# REMOTE RUN
 load(url("https://raw.githubusercontent.com/iskarwaluyo/residuos_cdmx_app/main/DATA/denue_data_aggregate.RData"))

denue_data_subset <- read.csv("https://raw.githubusercontent.com/iskarwaluyo/residuos_cdmx_app/main/DATA/denue_data_subset.csv")

# ONLY FOR LOCAL RUN
# setwd("~/sigdata/archivos2/sigdata/PROYECTOS/foodwastemexicocity/R/residuos_cdmx_app")

# VARIABLES FOR REACTIVE PLOTS
denue_data_categorias <- unique(denue_data_subset$CATEGORIA)
denue_data_municipio <- unique(denue_data_subset$municipio)
denue_data_insitu <- unique(denue_data_subset$FACTOR_SIT)
denue_data_perocu <- unique(denue_data_subset$per_ocu)

grupos_variables <- c("municipio", "CATEGORIA", "per_ocu")

bins_uecs_tot <- c(0, 10, 20, 50, 100, 150, 200, Inf)
bins_irsm_promedio <- c(1, 2, 3, 4, 5, 6, 7)
bins_irsm_total <- c(0, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200, Inf)
bins_hab_uecs <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
bins_autocorr <- c(0,1,2,3,4)

# PALETA DE COLORES
palWR <- colorRamp(c("white", "red"))


pal_lisa <- colorFactor(c("white", "red", "blue", "lightblue2", "grey"), 0:4)
palb <- colorFactor( palette="Spectral", 1:7)

pal_0 <- colorBin( palette="viridis", domain = denue_data_hood_aggregate$PobTot2020, bins = bins_irsm_total)
pal_irsm <- colorBin( palette= palWR, domain = denue_data_hood_aggregate$IRSM, bins = bins_irsm_total)

# POP UPS

pop_todos <- paste0("<b><br/> Colonia: </b>", denue_data_hood_aggregate$colonia,
                       "<b><br/> Población total (2020): </b>", denue_data_hood_aggregate$PobTot2020,
                       "<b><br/> Superficie total: </b>", denue_data_hood_aggregate$Area_ha, " ha")