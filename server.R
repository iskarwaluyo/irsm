function(input, output, session) {
  
  # GENERAR TABLAS PARA VISUALIZAR DATOS
  # VISUALIZACIÓN DE DATOS 1
  
  output$tabla1 = DT::renderDataTable({
    data <- denue_data_subset
    DT::datatable(
      extensions = 'Buttons',
      filter = 'top',
      options = list(
        pageLength = 50, autoWidth = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      ),
      {
        if (input$municipio != "Todos") {
          data <- data[data$municipio == input$municipio,]
        }
        if (input$per_ocu != "Todos") {
          data <- data[data$per_ocu == input$per_ocu,]
        }
        if (input$CATEGORIA != "Todos") {
          data <- data[data$CATEGORIA == input$CATEGORIA,]
        }
        data
      }
    )
  })
  
  output$tabla2 = DT::renderDataTable({
    data <- denue_data_borough_aggregate
    DT::datatable(
      filter = 'top', 
      options = list(
        pageLength = 16, autoWidth = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
      ),
      {
        data
      }
    )
  })

  output$tabla3 = DT::renderDataTable({
    data <- denue_data_hood_aggregate
    DT::datatable(
      filter = 'top', 
      options = list(
        pageLength = 16, autoWidth = TRUE,
        buttons = c('csv')
      ),
      {
        data
      }
    )
  })
  

# VISUALIZACIONES 1
  
  selectedData1 <<- reactive({
    cmd_paste <- paste0("denue_data_subset %>% group_by(",input$CAT1,") %>% dplyr::summarise(count = n()) %>% mutate(perc = count/sum(count)*100)")
    as.data.frame(eval(parse(text = cmd_paste)))
  })
  
  output$grafica1 <- renderPlot({
    x <- selectedData1()
    plot_attributes <- paste0("labs(title='Número de establecimientos por ",input$CAT1, "', y='Establecimientos Totales', x='Variable 1', caption = 'Fuente de datos DENUE/INEGI 2021') + coord_flip() + theme(legend.position = 'bottom', axis.text.x = element_text(size = 16, angle = 30), axis.text.y = element_text(size = 16), axis.title = element_text(size = 18, face = 'bold', vjust = -0.00001), title = element_text(size = 20, face = 'bold'),legend.text = element_text(size = 14))")
      
    cmd_paste <- paste("ggplot(x, aes(x=",input$CAT1,", y=count)) +
      geom_bar(stat='identity',  width = .7) +",plot_attributes, sep ="", collapse = "")
    eval(parse(text = cmd_paste))
  })
  
# VISUALIZACIONES 2
  
  selectedData2 <<- reactive({
    cmd_paste <- paste0("denue_data_subset %>% group_by(",input$CAT1,",",input$CAT2,") %>% dplyr::summarise(count = n()) %>% mutate(perc = count/sum(count)*100)")
    as.data.frame(eval(parse(text = cmd_paste)))
  })
  
  output$tabla4 <- renderTable(
    selectedData2()
  ) 
  
  
# VISUALIZACIONES 3
  
  selectedData3 <<- reactive({
    denue_data_subset[, c(input$CAT3)]
  })
  
  # GENERAR MAPA 1
  output$mapa <- renderLeaflet({
    
    m <-leaflet(denue_data_hood_aggregate) %>%
      addMapPane("A", zIndex = 490) %>% #
      addMapPane("B", zIndex = 480) %>% # 
      addMapPane("C", zIndex = 470) %>% # 
      addMapPane("D", zIndex = 460) %>% # 
      addMapPane("E", zIndex = 450) %>% #
      addMapPane("F", zIndex = 440) %>% # 
      addMapPane("G", zIndex = 430) %>% # 
      addMapPane("H", zIndex = 420) %>% # 
      addMapPane("I", zIndex = 410) %>% # 
      addMapPane("J", zIndex = 410) %>% # 
      
      addTiles(group = "Open Street Map") %>%
      addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite")
    
    # CARGAR CAPA DE PUNTOS CON UECES FILTRADOS
    m <- m %>%  addMarkers(data = denue_data_subset, ~longitud, ~latitud, 
                           popup = ~pop_todos, label = ~as.character(nom_estab),
                           options = pathOptions(pane = "A"),
                           group = "UECS",
                           clusterOptions = markerClusterOptions()) 
    
    # CARGAR CAPAS DE UECS
    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "B"),
                            fillOpacity = .7,
                            fillColor = ~pal_0(as.numeric(PobTot2020)),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "UECS por colonia",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))
    # CARGAR CAPAS DE IRSM
    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "C"),
                            fillOpacity = .7,
                            fillColor = ~pal_irsm(IRSM),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "IRSM Total",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))
    
    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "D"),
                            fillOpacity = .7,
                            fillColor = ~pal_irsm(Alimentos_IRSM),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "IRSM Alimentos",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))
    
    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "E"),
                            fillOpacity = .7,
                            fillColor = ~pal_irsm(Alojamiento_IRSM),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "IRSM Alojamiento",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))
    
    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "F"),
                            fillOpacity = .7,
                            fillColor = ~pal_irsm(Comercio.al.por.mayor_IRSM),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "IRSM Comercio al por mayor",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))
    
    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "G"),
                            fillOpacity = .7,
                            fillColor = ~pal_irsm(Comercio.al.por.menor_IRSM),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "IRSM Comercio al por menor",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))
    
    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "H"),
                            fillOpacity = .7,
                            fillColor = ~pal_irsm(Esparcimiento_IRSM),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "IRSM Esparcimiento",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))

    m <- m %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "J"),
                            fillOpacity = .7,
                            fillColor = ~pal_irsm(Servicios.educativos_IRSM),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "IRSM Educación",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))    
    # CONTROL DE CAPAS
    m <- m %>% addLayersControl(
      baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
      overlayGroups = c("UECS", "UECS por colonia", "IRSM Total", "IRSM Alimentos", "IRSM Alojamiento", "IRSM Comercio al por mayor", "IRSM Comercio al por menor", "IRSM Esparcimiento", "IRSM Educación", "LISA Todos"), options = layersControlOptions(collapsed = TRUE)
    )
    
  })
  
    # GENERAR MAPA 2
    output$mapa2 <- renderLeaflet({
      
      m2 <-leaflet(denue_data_hood_aggregate) %>%
        addMapPane("A", zIndex = 490) %>% #
        addMapPane("B", zIndex = 480) %>% # 
        addMapPane("C", zIndex = 470) %>% # 
        addMapPane("D", zIndex = 460) %>% # 
        addMapPane("E", zIndex = 450) %>% #
        addMapPane("F", zIndex = 440) %>% # 
        addMapPane("G", zIndex = 430) %>% # 
        addMapPane("H", zIndex = 420) %>% # 
        addMapPane("I", zIndex = 410) %>% # 
        addMapPane("J", zIndex = 410) %>% # 
        
        addTiles(group = "Open Street Map") %>%
        addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
        addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite")
    # CAPAS AUTOCORRELACION
    
    m2 <- m2 %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                            options = pathOptions(pane = "A"),
                            fillOpacity = .7,
                            fillColor = ~pal_lisa(Todos_LISA),
                            opacity = .3,
                            weight = 1,
                            color = "#4D4D4D",
                            dashArray = "2",
                            highlight = highlightOptions(
                              weight = 1,
                              color = "#4D4D4D",
                              fillOpacity = 0.1,
                              dashArray = "2",
                              bringToFront = TRUE),
                            group = "LISA Todos",
                            labelOptions = labelOptions(
                              style = list("font-weight" = "normal", padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto"))
    
    m2 <- m2 %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                              options = pathOptions(pane = "B"),
                              fillOpacity = .7,
                              fillColor = ~pal_lisa(Alimentos_LISA),
                              opacity = .3,
                              weight = 1,
                              color = "#4D4D4D",
                              dashArray = "2",
                              highlight = highlightOptions(
                                weight = 1,
                                color = "#4D4D4D",
                                fillOpacity = 0.1,
                                dashArray = "2",
                                bringToFront = TRUE),
                              group = "LISA Alimentos",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"))
    
    m2 <- m2 %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                              options = pathOptions(pane = "C"),
                              fillOpacity = .7,
                              fillColor = ~pal_lisa(Comercio.al.por.menor_LISA),
                              opacity = .3,
                              weight = 1,
                              color = "#4D4D4D",
                              dashArray = "2",
                              highlight = highlightOptions(
                                weight = 1,
                                color = "#4D4D4D",
                                fillOpacity = 0.1,
                                dashArray = "2",
                                bringToFront = TRUE),
                              group = "LISA Comercio al por menor",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"))
    
    m2 <- m2 %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                              options = pathOptions(pane = "C"),
                              fillOpacity = .7,
                              fillColor = ~pal_lisa(Comercio.al.por.mayor_LISA),
                              opacity = .3,
                              weight = 1,
                              color = "#4D4D4D",
                              dashArray = "2",
                              highlight = highlightOptions(
                                weight = 1,
                                color = "#4D4D4D",
                                fillOpacity = 0.1,
                                dashArray = "2",
                                bringToFront = TRUE),
                              group = "LISA Comercio al por mayor",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"))
    
    m2 <- m2 %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                              options = pathOptions(pane = "C"),
                              fillOpacity = .7,
                              fillColor = ~pal_lisa(Alojamiento_LISA),
                              opacity = .3,
                              weight = 1,
                              color = "#4D4D4D",
                              dashArray = "2",
                              highlight = highlightOptions(
                                weight = 1,
                                color = "#4D4D4D",
                                fillOpacity = 0.1,
                                dashArray = "2",
                                bringToFront = TRUE),
                              group = "LISA Alojamiento",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"))
    
    m2 <- m2 %>%  addPolygons(data = denue_data_hood_aggregate, stroke = TRUE, smoothFactor = 0.3,
                              options = pathOptions(pane = "C"),
                              fillOpacity = .7,
                              fillColor = ~pal_lisa(Esparcimiento_LISA),
                              opacity = .3,
                              weight = 1,
                              color = "#4D4D4D",
                              dashArray = "2",
                              highlight = highlightOptions(
                                weight = 1,
                                color = "#4D4D4D",
                                fillOpacity = 0.1,
                                dashArray = "2",
                                bringToFront = TRUE),
                              group = "LISA Esparcimiento",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"))

    # CONTROL DE CAPAS
    m2 <- m2 %>% addLayersControl(
      baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
      overlayGroups = c("LISA Todos", "LISA Alimentos", "LISA Comercio al por menor", "LISA Comercio al por mayor", "LISA Alojamiento", "LISA Esparcimiento"), options = layersControlOptions(collapsed = TRUE)
    )

  })
  
  observe({
    proxy <- leafletProxy("mapa", data = denue_data_hood_aggregate)
    proxy %>% clearControls()
    if (input$leyenda) {
      proxy %>% 
        addLegend("topleft", group = "UECS por colonia", title = "Establecimientos totales", pal = pal_0, values = ~as.numeric(PobTot2020), opacity = 1.0)
    }
  })
  
  observe({
    proxy <- leafletProxy("mapa", data = denue_data_hood_aggregate)
    proxy %>% clearControls()
    if (input$leyenda) {
      proxy %>% 
        addLegend("topleft", group = "IRSM Total", pal = pal_irsm, values = ~IRSM, opacity = 1.0) %>%
        addLegend("topleft", group = "IRSM Alimentos", pal = pal_irsm, values = ~IRSM, opacity = 1.0) %>%
        addLegend("topleft", group = "IRSM Alojamiento", pal = pal_irsm, values = ~IRSM, opacity = 1.0) %>%
        addLegend("topleft", group = "IRSM Comercio al por mayor", pal = pal_irsm, values = ~IRSM, opacity = 1.0)
    }
  })

}