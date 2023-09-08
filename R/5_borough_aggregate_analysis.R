library(gridExtra)
library(plyr)
library(data.table)
library(sf)
library(ggplot2)
library(forcats)
library(dplyr)
library(classInt)

# CARGAR DATOS DE ALCALDIAS Y COLONIAS
directorio <- c("~/sigdata/archivos2/sigdata/PROYECTOS")
setwd(directorio)

setwd("./irsm/DATA") 

load("./RData/stage4.RData")
 
# REGRESAR AL AMBIENTE DE TRABAJO
setwd("../R")

# COROPLETICOS IRSM

# CLASIFICACIONES

irsm_map <- function(irsm_select, intervalo, breaks){
  
  x <- st_drop_geometry(denue_data_hood_aggregate[,c(irsm_select)])
  min <- min(x)
  max <- max(x)
  diff <- max - min
  std <- sd(unlist(x))
  
  equal.interval <<- unique(seq(min, max, by = diff/breaks))
  
  quantile.interval <- unique(quantile(x[,c(irsm_select)], probs=seq(0, 1, by = 1/breaks)))

  std.interval <- unique(c(seq(min, max, by=std), max))
  natural.interval <<- unique(classIntervals(x[,c(irsm_select)], n = breaks, style = 'jenks')$brks)
  
  denue_data_hood_aggregate$population.equal <- cut(x[,c(irsm_select)], breaks=equal.interval, include.lowest = TRUE)
  denue_data_hood_aggregate$population.quantile <- cut(x[,c(irsm_select)], breaks=quantile.interval, include.lowest = TRUE)
  denue_data_hood_aggregate$population.std <- cut(x[,c(irsm_select)], breaks=std.interval, include.lowest = TRUE)
  denue_data_hood_aggregate$population.natural <- cut(x[,c(irsm_select)], breaks=natural.interval, include.lowest = TRUE)
  
  comando1 <- paste0(irsm_select, "_hist <<- ggplot(denue_data_hood_aggregate, aes(x =",irsm_select,")) + geom_histogram(breaks=", intervalo,")")
  eval(parse(text = comando1))

  comando2 <- paste0(irsm_select, "_coro <<- ggplot(denue_data_hood_aggregate, aes(fill =", irsm_select, ")) + 
  scale_fill_stepsn(colours = c('white', 'pink', 'red', 'red2', 'red3', 'red4'), breaks =", intervalo, ")  + 
  labs(title='IRSM Total ", irsm_select, "',
       subtitle='Índice de riesgo de acumulación de RSM') + theme(legend.position = 'bottom', legend.title=element_blank(), axis.text.x = element_text(angle = 30, vjust = 0.5, hjust=1)) +
  geom_sf()")
  
  eval(parse(text = comando2))
  
}

irsm_map("IRSM", "natural.interval", 3)
irsm_map("Alimentos_IRSM", "natural.interval", 3)
irsm_map("Comercio.al.por.menor_IRSM", "natural.interval", 3)
irsm_map("Comercio.al.por.mayor_IRSM", "natural.interval", 3)
irsm_map("Alojamiento_IRSM", "natural.interval", 3)
irsm_map("Esparcimiento_IRSM", "natural.interval", 3)
irsm_map("Servicios.educativos_IRSM", "natural.interval", 3)

grid.arrange(Alimentos_IRSM_coro, Comercio.al.por.menor_IRSM_coro, Comercio.al.por.mayor_IRSM_coro, Alojamiento_IRSM_coro, Esparcimiento_IRSM_coro, Servicios.educativos_IRSM_coro, ncol=3)


# ANÁLISIS POR ALCALDÍA

denue_data_melt <- denue_data_subset %>%
  group_by(municipio, CATEGORIA, per_ocu) %>%
  dplyr::summarise(count = n(),
                   IRSM_total = sum(IRSM),
                   IRSM_prom = mean(IRSM)) %>%
  mutate(perc = count/nrow(denue_data_subset),
         cumulativo_count = cumsum(count),
         cumulativo_perc = cumsum(perc))

denue_data_melt <- as.data.frame(denue_data_melt)

etiquetas_mun <- denue_data_subset %>%
  group_by(municipio) %>%
  dplyr::summarise(count = n(),
                   IRSM_total = sum(IRSM),
                   IRSM_prom = mean(IRSM)) %>%
  mutate(perc = count/sum(count),
         cumulativo_count = cumsum(count))

p1 <- ggplot(denue_data_melt, aes(x = reorder(municipio, -count), y = perc, fill = CATEGORIA)) +
  geom_bar(stat='identity', width = .7, position = position_fill(reverse = TRUE)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) + 
  geom_line(aes(x = municipio, y = perc*5), linewidth = 7, color = 'tomato') +
  geom_text(aes(municipio, label = count, fill = NULL), data = etiquetas_mun, angle = 90, color = 'black') +
  labs(title="Establecimientos totales", subtitle = "Establecimientos por alcaldía por tipo de establecimiento",
       y="Porcentaje por actividad / Establecimientos totales",
       x="Alcaldía",
       caption = "Fuente de datos DENUE/INEGI 2021") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = 12, angle = 30),
        axis.text.y = element_text(size = 12), 
        axis.title = element_text(size = 18, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 14)) +
  scale_fill_brewer(palette = "Accent", name = "Tipo")

p2 <- ggplot(data=denue_data_subset, aes(x = fct_infreq(municipio), fill = per_ocu)) +
  geom_bar() + 
  geom_text(aes(municipio, count+1000, label = count, fill = NULL), size = 6, data = etiquetas_mun) +
  labs(title = "Establecimientos por municipio y personas ocupadas",
       y="Número de Establecimientos",
       x="Alcaldía") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = 18, angle = 0),
        axis.text.y = element_text(size = 18), 
        axis.title = element_text(size = 22, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 18)) +
  scale_fill_brewer(palette = "YlOrRd", name = "Personas ocupadas") + coord_flip()

# ANÁLISIS POR CATEGORÍA

denue_data_melt_cat <- denue_data_subset %>%
  group_by(CATEGORIA) %>%
  dplyr::summarise(count = n(),
                   IRSM_total = sum(IRSM),
                   IRSM_prom = mean(IRSM)) %>%
  arrange(desc(count)) %>%
  mutate(perc = count/nrow(denue_data_subset),
         cumulativo_count = cumsum(count),
         cumulativo_perc = cumsum(perc),
         cumulativo_irsm = cumsum(IRSM_total),
         irsm_perc = cumsum(IRSM_total)/sum(IRSM_total))

etiquetas_cat <- denue_data_subset %>%
  group_by(CATEGORIA) %>%
  dplyr::summarise(count = n(),
                   IRSM_total = sum(IRSM),
                   IRSM_prom = mean(IRSM)) %>%
  mutate(perc = count/sum(count),
         cumulativo_count = cumsum(count))

p3 <- ggplot(denue_data_melt_cat)  + 
  geom_bar(aes(x=reorder(CATEGORIA, -count), y=count), stat="identity", fill = "lightblue") + 
  geom_text(aes(x=reorder(CATEGORIA, -count), count+2000, label = count, fill = NULL), size = 6, data = etiquetas_cat) +
  geom_line(aes(x=reorder(CATEGORIA, cumulativo_count), y=cumulativo_perc*(max(count))), 
            linewidth = 1, linetype = 1, stat="identity", group = 1) +
  geom_text(aes(label= scales::percent(cumulativo_perc), x=CATEGORIA, y=cumulativo_perc*(max(count))), colour="blue", vjust = -1.25, size = 6) +
  scale_y_continuous(sec.axis = sec_axis(~./max(denue_data_melt_cat$count)*100)) +
  labs(title="A) Establecimientos por categoría",
       y="Número de Establecimientos",
       x="Categoría") +
  theme(legend.position = "none",
        axis.text.x = element_text(size = 18, angle = 20),
        axis.text.y = element_text(size = 18), 
        axis.title = element_text(size = 22, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 14)) 

p4 <- ggplot(denue_data_melt, aes(x=reorder(CATEGORIA, -count), y = perc, fill = per_ocu)) +
  geom_bar(stat='identity', width = .7, position = position_fill(reverse = TRUE)) + 
  geom_text(aes(x=reorder(CATEGORIA, -count), 1.025, label = count, fill = NULL), size = 6, data = etiquetas_cat) +
  labs(title = "B) Establecimientos por categoría y personas ocupadas",
       y="Porcentaje de Establecimientos",
       x="Categoría") +
  theme(legend.position = "right",
        axis.text.x = element_text(size = 18, angle = 20),
        axis.text.y = element_blank(), 
        axis.title = element_text(size = 18, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 14)) +
  scale_fill_brewer(palette = "BuPu", name = "Personas ocupadas") 

grid.arrange(p3, p4, ncol=2)

denue_data_melt_cat <- denue_data_melt_cat %>%
  arrange(desc(IRSM_total)) %>%
  mutate(perc = count/nrow(denue_data_subset),
         cumulativo_count = cumsum(count),
         cumulativo_perc = cumsum(perc),
         cumulativo_irsm = cumsum(IRSM_total),
         irsm_perc = cumsum(IRSM_total)/sum(IRSM_total))

p5 <- ggplot(denue_data_melt_cat)  + 
  geom_bar(aes(x=reorder(CATEGORIA, -IRSM_total), y=IRSM_total), stat="identity", fill = "pink") + 
  geom_text(aes(x=reorder(CATEGORIA, -IRSM_total), IRSM_total+200, label = IRSM_total, fill = NULL), size = 6, data = denue_data_melt_cat) +
  geom_line(aes(x=reorder(CATEGORIA, -cumulativo_irsm), y=irsm_perc*(max(IRSM_total))), 
            linewidth = 1, linetype = 1, stat="identity", group = 1) +
  geom_text(aes(label= scales::percent(irsm_perc), x=CATEGORIA, y=irsm_perc*(max(IRSM_total))), colour="blue", vjust = -1.25, size = 6) +
  scale_y_continuous(sec.axis = sec_axis(~./max(denue_data_melt_cat$IRSM_total)*100)) +
  labs(title="A) IRSM acumulado por categoría",
       y="Riesgo de acumulación",
       x="Categoría") +
  theme(legend.position = "none",
        axis.text.x = element_text(size = 18, angle = 20),
        axis.text.y = element_text(size = 18), 
        axis.title = element_text(size = 22, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 14)) 

p6 <- ggplot(denue_data_melt, aes(x=reorder(CATEGORIA, -IRSM_total), y = perc, fill = per_ocu)) +
  geom_bar(stat='identity', width = .7, position = position_fill(reverse = TRUE)) + 
  geom_text(aes(x=reorder(CATEGORIA, -IRSM_total), 1.025, label = IRSM_total, fill = NULL), size = 6, data = etiquetas_cat) +
  labs(title = "B) IRSM acumulado por categoría y personas ocupadas",
       y="Riesgo de acumulación",
       x="Categoría") +
  theme(legend.position = "right",
        axis.text.x = element_text(size = 18, angle = 20),
        axis.text.y = element_blank(), 
        axis.title = element_text(size = 18, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 14)) +
  scale_fill_brewer(palette = "Reds", name = "Personas ocupadas") 

grid.arrange(p5, p6, ncol=2)

p7 <- ggplot(data=denue_data_melt, aes(x = (municipio), y = perc, fill = per_ocu)) +
  geom_bar(stat='identity', width = .7, position = position_fill(reverse = TRUE)) + 
  geom_text(aes(municipio, 1.025, label = count, fill = NULL), size = 4, data = etiquetas_mun) +
  labs(title = "Establecimientos por municipio y personas ocupadas",
       y="Número de Establecimientos",
       x="Alcaldía") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = 18, angle = 0),
        axis.text.y = element_text(size = 18), 
        axis.title = element_text(size = 22, face = "bold", vjust = -0.00001),
        title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 18)) +
  scale_fill_brewer(palette = "YlOrRd", name = "Personas ocupadas") + coord_flip() + 
  facet_wrap(~CATEGORIA)


perocu_select <- function(categoria){
  
  melt_select <- subset(denue_data_melt, denue_data_melt$CATEGORIA == categoria)
  
  p8 <- ggplot(melt_select, aes(x = reorder(municipio, -count), y = perc, fill = per_ocu)) +
    geom_bar(stat='identity', width = .7, position = position_fill(reverse = TRUE)) +
    geom_text(aes(municipio, 1.025, label = count, fill = NULL), size = 6, data = etiquetas_mun) +
    labs(title = paste0('Establecimientos por municipio y personas ocupadas (', categoria,')'),
         y='Número de Establecimientos',
         x='Alcaldía') +
    theme(legend.position = 'bottom',
          axis.text.x = element_text(size = 18, angle = 0),
          axis.text.y = element_text(size = 18), 
          axis.title = element_text(size = 22, face = 'bold', vjust = -0.00001),
          title = element_text(size = 20, face = 'bold'),
          legend.text = element_text(size = 18)) +
    scale_fill_brewer(palette = 'YlOrRd', name = 'Personas ocupadas') + coord_flip()

  p8
}




# EXPORTAR RESULTADOS EN UN ARCHIVO RDATA
setwd(directorio)
setwd("./irsm/DATA/RData") 
save.image("./stage5.RData")

# EXPORTAR DATOS EN RDATA PARA LA APP DE SHINY

# NOTA: PARA PODER SUBIR AL SERVIDOR SHINY, SE DIVIDEN LOS DATOS DEL DENUE EN 4 PARTES
# DEFINIR NUMERO DE PARTES PARA DIVIDIR SUBSET
n <- 4
denue_data_subset_split <- split(denue_data_subset, factor(sort(rank(row.names(denue_data_subset))%%n)))
denue_data_subset.A <- denue_data_subset_split[['0']]
denue_data_subset.B <- denue_data_subset_split[['1']]
denue_data_subset.C <- denue_data_subset_split[['2']]
denue_data_subset.D <- denue_data_subset_split[['3']]


setwd(directorio)
setwd("./irsm/R/residuos_cdmx_app/DATA") 
save(denue_data_borough_aggregate, denue_data_hood_aggregate, file = "app_aggregate_data.RData") 
save(alcaldias, colonias, file = "app_reference_data.RData")
save(denue_data_subset.A, file = "app_denue_data_A.RData")
save(denue_data_subset.B, file = "app_denue_data_B.RData")
save(denue_data_subset.C, file = "app_denue_data_C.RData")
save(denue_data_subset.D, file = "app_denue_data_D.RData")


# REGRESAR CONSOLA A AMBIENTE DE TRABAJO PRINCIPAL
setwd(directorio)
setwd("./irsm/R") 

# LIMPIAR EL AMBIENTE DE TRABAJO DE LA CONSOLA R
#    rm(list = ls())

