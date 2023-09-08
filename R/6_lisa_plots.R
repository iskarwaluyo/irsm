library(ggplot2)
library(gridExtra)
library(plyr)
library(sf)

# CARGAR DATOS
directorio <- c("~/sigdata/archivos2/sigdata/PROYECTOS")
setwd(directorio)

setwd("./irsm/DATA") 
# LOAD DATA
load("./RData/stage5.RData")

# SET ENVIRONMENT TO WORKING DIRECTORY
setwd("../R")

# AUTOCORRELACION POR MUNICIPIO POR CATEGORIA

lisa_alcaldia_total <- ddply(st_drop_geometry(denue_data_hood_aggregate), .(alcaldia), summarise, Colonia = length(colonia),
                             No_sigificativo = 100*length(Todos_LISA[Todos_LISA==0])/length(colonia),
                             Alto_Alto = 100*length(Todos_LISA[Todos_LISA==1])/length(colonia),
                             Bajo_Bajo = 100*length(Todos_LISA[Todos_LISA==2])/length(colonia),
                             Bajo_Alto = 100*length(Todos_LISA[Todos_LISA==3])/length(colonia),
                             Alto_Bajo = 100*length(Todos_LISA[Todos_LISA==4])/length(colonia),
                             Sin_dato = 100*length(Todos_LISA[Todos_LISA==6])/length(colonia)
)

lisa_alcaldia_total$categoria <- "Todos"

lisa_alcaldia_alimentos <- ddply(st_drop_geometry(denue_data_hood_aggregate), .(alcaldia), summarise, Colonia = length(colonia),
                                 No_sigificativo = 100*length(Alimentos_LISA[Alimentos_LISA==0])/length(colonia),
                                 Alto_Alto = 100*length(Alimentos_LISA[Alimentos_LISA==1])/length(colonia),
                                 Bajo_Bajo = 100*length(Alimentos_LISA[Alimentos_LISA==2])/length(colonia),
                                 Bajo_Alto = 100*length(Alimentos_LISA[Alimentos_LISA==3])/length(colonia),
                                 Alto_Bajo = 100*length(Alimentos_LISA[Alimentos_LISA==4])/length(colonia),
                                 Sin_dato = 100*length(Alimentos_LISA[Alimentos_LISA==6])/length(colonia)
)

lisa_alcaldia_alimentos$categoria <- "Alimentos"


lisa_alcaldia_comenor <- ddply(st_drop_geometry(denue_data_hood_aggregate), .(alcaldia), summarise, Colonia = length(colonia),
                               No_sigificativo = 100*length(Comercio.al.por.menor_LISA[Comercio.al.por.menor_LISA==0])/length(colonia),
                               Alto_Alto = 100*length(Comercio.al.por.menor_LISA[Comercio.al.por.menor_LISA==1])/length(colonia),
                               Bajo_Bajo = 100*length(Comercio.al.por.menor_LISA[Comercio.al.por.menor_LISA==2])/length(colonia),
                               Bajo_Alto = 100*length(Comercio.al.por.menor_LISA[Comercio.al.por.menor_LISA==3])/length(colonia),
                               Alto_Bajo = 100*length(Comercio.al.por.menor_LISA[Comercio.al.por.menor_LISA==4])/length(colonia),
                               Sin_dato = 100*length(Comercio.al.por.menor_LISA[Comercio.al.por.menor_LISA==6])/length(colonia)
)

lisa_alcaldia_comenor$categoria <- "Comercio menor"

lisa_alcaldia_comayor <- ddply(st_drop_geometry(denue_data_hood_aggregate), .(alcaldia), summarise, Colonia = length(colonia),
                               No_sigificativo = 100*length(Comercio.al.por.mayor_LISA[Comercio.al.por.mayor_LISA==0])/length(colonia),
                               Alto_Alto = 100*length(Comercio.al.por.mayor_LISA[Comercio.al.por.mayor_LISA==1])/length(colonia),
                               Bajo_Bajo = 100*length(Comercio.al.por.mayor_LISA[Comercio.al.por.mayor_LISA==2])/length(colonia),
                               Bajo_Alto = 100*length(Comercio.al.por.mayor_LISA[Comercio.al.por.mayor_LISA==3])/length(colonia),
                               Alto_Bajo = 100*length(Comercio.al.por.mayor_LISA[Comercio.al.por.mayor_LISA==4])/length(colonia),
                               Sin_dato = 100*length(Comercio.al.por.mayor_LISA[Comercio.al.por.mayor_LISA==6])/length(colonia)
)

lisa_alcaldia_comayor$categoria <- "Comercio mayor"

lisa_alcaldia_alojamiento <- ddply(st_drop_geometry(denue_data_hood_aggregate), .(alcaldia), summarise, Colonia = length(colonia),
                                   No_sigificativo = 100*length(Alojamiento_LISA[Alojamiento_LISA==0])/length(colonia),
                                   Alto_Alto = 100*length(Alojamiento_LISA[Alojamiento_LISA==1])/length(colonia),
                                   Bajo_Bajo = 100*length(Alojamiento_LISA[Alojamiento_LISA==2])/length(colonia),
                                   Bajo_Alto = 100*length(Alojamiento_LISA[Alojamiento_LISA==3])/length(colonia),
                                   Alto_Bajo = 100*length(Alojamiento_LISA[Alojamiento_LISA==4])/length(colonia),
                                   Sin_dato = 100*length(Alojamiento_LISA[Alojamiento_LISA==6])/length(colonia)
)

lisa_alcaldia_alojamiento$categoria <- "Alojamiento"

lisa_alcaldia_esparcimiento <- ddply(st_drop_geometry(denue_data_hood_aggregate), .(alcaldia), summarise, Colonia = length(colonia),
                                     No_sigificativo = 100*length(Esparcimiento_LISA[Esparcimiento_LISA==0])/length(colonia),
                                     Alto_Alto = 100*length(Esparcimiento_LISA[Esparcimiento_LISA==1])/length(colonia),
                                     Bajo_Bajo = 100*length(Esparcimiento_LISA[Esparcimiento_LISA==2])/length(colonia),
                                     Bajo_Alto = 100*length(Esparcimiento_LISA[Esparcimiento_LISA==3])/length(colonia),
                                     Alto_Bajo = 100*length(Esparcimiento_LISA[Esparcimiento_LISA==4])/length(colonia),
                                     Sin_dato = 100*length(Esparcimiento_LISA[Esparcimiento_LISA==6])/length(colonia)
)

lisa_alcaldia_esparcimiento$categoria <- "Esparcimiento"

lisa_alcaldia_educacion <- ddply(st_drop_geometry(denue_data_hood_aggregate), .(alcaldia), summarise, Colonia = length(colonia),
                                 No_sigificativo = 100*length(Educacion_LISA[Educacion_LISA==0])/length(colonia),
                                 Alto_Alto = 100*length(Educacion_LISA[Educacion_LISA==1])/length(colonia),
                                 Bajo_Bajo = 100*length(Educacion_LISA[Educacion_LISA==2])/length(colonia),
                                 Bajo_Alto = 100*length(Educacion_LISA[Educacion_LISA==3])/length(colonia),
                                 Alto_Bajo = 100*length(Educacion_LISA[Educacion_LISA==4])/length(colonia),
                                 Sin_dato = 100*length(Educacion_LISA[Educacion_LISA==6])/length(colonia)
)

lisa_alcaldia_educacion$categoria <- "Educacion"

lisa_resumen <- rbind(lisa_alcaldia_total, lisa_alcaldia_alimentos, lisa_alcaldia_comenor,
                      lisa_alcaldia_comayor, lisa_alcaldia_alojamiento, lisa_alcaldia_esparcimiento, lisa_alcaldia_educacion)

is.num <- sapply(lisa_resumen, is.numeric)
lisa_resumen[is.num] <- lapply(lisa_resumen[is.num], round, 2)

lisa_melt <- reshape2::melt(lisa_resumen[,c(1,4,5,6,7,9)], level = 2)

resumen_autocorrelacion_alcaldia <- ggplot(lisa_melt, aes(x = categoria, y = alcaldia, fill = value)) + geom_tile(color = "black") +
  geom_text(aes(label = value), color = "black", size = 4) + scale_fill_gradient(low = "white", high = "gold") + 
  labs(title="Aglomeración de Riesgo de Acumulación de RSM",
       subtitle="Porcentaje de colonias aglomeradas",
       y="Alcaldía",
       x="Categoría") +
  facet_wrap(~variable, labeller = labeller(variable = 
                                             c("Alto_Alto" = "Aglomeración de colonias con alto riesgo",
                                               "Bajo_Bajo" = "Aglomeracion de colonias con bajo riesgo",
                                               "Bajo_Alto" = "Colonias con bajo riesgo rodeadas de colonias con alto riesgo",
                                               "Alto_Bajo" = "Colonias con alto riesgo rodeadas de colonias con bajo riesgo"))) + 
  theme(legend.position = "none", 
        axis.text.x = element_text(size = 10, angle = 20),
        axis.text.y = element_text(size = 10),
        axis.title = element_text(size = 18, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 14),
        strip.text = element_text(size=12))

etiquetas <- c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")

cols <- c("0" = "lightgrey", "1" = "red", "2" = "blue", "3" = "pink", "4" = "skyblue", "6" = "white")


ac1 <- ggplot(denue_data_hood_aggregate) + geom_sf(aes(fill = as.factor(Todos_LISA))) +
  scale_fill_manual(values=cols,
                    name="Clasificacion LISA",
                    labels=c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")) + 
  labs(title="LISA Todos los establecimientos") + 
  theme(legend.position="none", axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))

ac2 <- ggplot(denue_data_hood_aggregate) + geom_sf(aes(fill = as.factor(Alimentos_LISA))) +
  scale_fill_manual(values=cols,
                    name="Clasificacion LISA",
                    labels=c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")) + 
  labs(title="LISA Alimentos") + 
  theme(legend.position="none", axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))

ac3 <- ggplot(denue_data_hood_aggregate) + geom_sf(aes(fill = as.factor(Comercio.al.por.menor_LISA))) +
  scale_fill_manual(values=cols,
                    name="Clasificacion LISA",
                    labels=c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")) + 
  labs(title="LISA Comercio al por menor") + 
  theme(legend.position="none", axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))

ac4 <- ggplot(denue_data_hood_aggregate) + geom_sf(aes(fill = as.factor(Comercio.al.por.mayor_LISA))) +
  scale_fill_manual(values=cols,
                    name="Clasificacion LISA",
                    labels=c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")) + 
  labs(title="LISA Comercio al por mayor") + 
  theme(legend.position="none", axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))

ac5 <- ggplot(denue_data_hood_aggregate) + geom_sf(aes(fill = as.factor(Alojamiento_LISA))) +
  scale_fill_manual(values=cols,
                    name="Clasificacion LISA",
                    labels=c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")) + 
  labs(title="LISA Alojamiento") + 
  theme(legend.position="none", axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))

ac6 <- ggplot(denue_data_hood_aggregate) + geom_sf(aes(fill = as.factor(Esparcimiento_LISA))) +
  scale_fill_manual(values=cols,
                    name="Clasificacion LISA",
                    labels=c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")) + 
  labs(title="LISA Esparcimiento") + 
  theme(legend.position="none", axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))

ac7 <- ggplot(denue_data_hood_aggregate) + geom_sf(aes(fill = as.factor(Educacion_LISA))) +
  scale_fill_manual(values=cols,
                    name="Clasificacion LISA",
                    labels=c("No significativo", "Alto-Alto", "Bajo-Bajo", "Bajo-Alto", "Alto-Bajo", "No definido", "Aislado")) + 
  labs(title="LISA Educacion") + 
  theme(legend.position="none", axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1))

grid.arrange(ac2, ac3, ac4, ac5, ac6, ac7, ncol=3)

# ACUMULADO DE TODAS LAS ACTIVIDADES
ac1

# EXPORTA RESULTADOS A UN ARCHIVO .CSV
setwd(directorio)
setwd("./irsm/DATA/RESULTS") 

write.csv(lisa_resumen, file = "lisa_resumen.csv")

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd(directorio)
setwd("./irsm/R") 

# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())

