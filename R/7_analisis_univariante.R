library(summarytools)
library(DescTools)
library(rcompanion)
library(FSA)
library(sf)
library(ggplot2)
library(plyr)

# CARGAR DATOS
directorio <- c("~/sigdata/archivos2/sigdata/PROYECTOS")
setwd(directorio)

setwd("./irsm/DATA") 
# LOAD DATA
load("./RData/stage5.RData")

# SET ENVIRONMENT TO WORKING DIRECTORY
setwd(directorio)
setwd("./irsm/R") 

# ANALISIS EXPLORATORIO DE DATOS Y RESULTADOS

# UECS
ggplot(data=denue_data_subset, aes(x=IRSM, fill=CATEGORIA)) + 
  geom_density(alpha=0.7, linewidth = 0.1) + 
  labs(title="Distribución de IRSM", subtitle = "IRSM por establecimiento",
       y="Density",
       x="Index Score") +
  scale_fill_brewer(palette = "Set3") +
  facet_grid(rows = vars(CATEGORIA), cols = vars(municipio))

# IRSM

IRSM_stats_mun <- ddply(denue_data_subset, .(municipio), summarise,
                        Establecimientos = length(IRSM),
                        Promedio = mean(IRSM),
                        Acumulado = sum(IRSM),
                        Min = min(IRSM),
                        Max = max(IRSM),
                        SD = sd(IRSM),
                        I95_bajo = MeanCI(IRSM)[2],
                        I95_alto = MeanCI(IRSM)[3],
                        Curtosis = Kurt(IRSM),
                        Asimetria = Skew(IRSM)
)

is.num <- sapply(IRSM_stats_mun, is.numeric)
IRSM_stats_mun[is.num] <- lapply(IRSM_stats_mun[is.num], round, 2)


IRSM_stats_categoria <- ddply(denue_data_subset, .(CATEGORIA), summarise,
                              Establecimientos = length(IRSM),
                              Promedio = mean(IRSM),
                              Acumulado = sum(IRSM),
                              Min = min(IRSM),
                              Max = max(IRSM),
                              SD = sd(IRSM),
                              I95_bajo = MeanCI(IRSM)[2],
                              I95_alto = MeanCI(IRSM)[3],
                              Curtosis = Kurt(IRSM),
                              Asimetria = Skew(IRSM)
)

is.num <- sapply(IRSM_stats_categoria, is.numeric)
IRSM_stats_categoria[is.num] <- lapply(IRSM_stats_categoria[is.num], round, 2)


# PRUEBA DE NORMALIDAD

sample <- sample(c(TRUE, FALSE), nrow(denue_data_subset), replace=TRUE, prob=c(0.99, 0.01))
test_data   <- denue_data_subset[!sample, ]

shapiro.test(test_data$IRSM)

# COMPARACION DE MEDIAS


kruskal.test(IRSM_total ~ municipio, data = denue_data_melt)

kruskal.test(IRSM_total ~ CATEGORIA, data = denue_data_melt)

irsm_dunn_alcaldia <- DunnTest(IRSM_total~municipio, data=denue_data_melt)
irsm_dunn_alcaldiaB <- dunnTest(IRSM_total~municipio, data=denue_data_melt)

cldList(P.adj ~ Comparison,
        data = irsm_dunn_alcaldiaB$res,
        threshold = 0.05)

irsm_dunn_categoria <- DunnTest(IRSM_total~CATEGORIA, data=denue_data_melt)
irsm_dunn_mun <- DunnTest(IRSM_total~municipio, data=denue_data_melt)

# EXPORTA RESULTADOS A UN ARCHIVO .CSV Y GEOJSON
setwd(directorio)
setwd("./irsm/DATA/RESULTS") 

write.csv(IRSM_stats_mun, file = "irsm_analisis_univariante_mun.csv")
write.csv(IRSM_stats_categoria, file = "irsm_analisis_univariante_cat.csv")

sink(file = "prueba_dunn_mun.txt")
print(irsm_dunn_alcladia)
sink()

sink(file = "prueba_dunn_cat.txt")
print(irsm_dunn_categoria)
sink()

# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd(directorio)
setwd("./irsm/R") 

# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())

