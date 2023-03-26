bootstrapPage(theme = shinytheme("flatly"),
  navbarPage("LP_DENUE",
  
  tabPanel("Mapa",
    basicPage("Mapa Índice de Residuos Sólidos Municipales",
      div(class="outer",
        tags$head(includeCSS("styles.css")),
        leafletOutput("mapa", width = "100%", height = "100%"), 
          absolutePanel(top = 10, right = 10, checkboxInput("leyenda", "Mostrar leyenda", TRUE),
          absolutePanel(id = "logo_tia_cony", class = "card", bottom = 20, left = 60, width = "100%", fixed=TRUE, draggable = FALSE, height = "auto", tags$a(href='https://', tags$img(src='https://raw.githubusercontent.com/iskarwaluyo/mapas_denue/main/R/html/logo_cliente_solo.png',height='40',width='40'))),
          absolutePanel(id = "logo_geo", class = "card", bottom = 20, left = 120, width = "100%", fixed=TRUE, draggable = FALSE, height = "auto", tags$a(href='https://www.iskarwaluyo.wordpress.com', tags$img(src='https://raw.githubusercontent.com/iskarwaluyo/mapas_denue/main/R/html/logo_cliente_solo.png',height='40',width='40'))),
          ))
          )
), # END MAPA TAB PANEL

  navbarMenu("Datos",
  tabPanel("ESTABLECIMIENTOS",
    h2("Visualización de establecimientos"),
    fluidRow(
    column(4,
      selectInput("municipio",
      "Municipio:",
      c("Todos", unique(as.character(denue_data_subset$municipio))))
    ), # END COLUMN 1
    column(4,
      selectInput("per_ocu",
      "Personas ocupadas:",
      c("Todos",
      unique(as.character(denue_data_subset$per_ocu))))
    ), # END COLUMN 2
    column(4,
    selectInput("CATEGORIA",
      "Categoría de actividad:",
      c("Todos",
      unique(as.character(denue_data_subset$CATEGORIA))))
    ) # END COLUMN 3
  ), # END FLUID ROW (MENU) START TABLE
    
    DT::dataTableOutput("tabla1"),
    ), # END TAB PANEL START NEW TABPANEL
    
  tabPanel("ALCALDIA",
    h2("Datos agregados por alcaldia"),
    DT::dataTableOutput("tabla2"),
    ), # END TABPANEL
  
  tabPanel("COLONIA",
    h2("Datos agregados por colonia"),
    DT::dataTableOutput("tabla3"),
  ) # END TABPANEL
  ), # END NAVBAR MENU PAGE

navbarMenu("Exploración de datos",
  tabPanel("Gráficas de dispersión",
    pageWithSidebar(
    headerPanel('Gráficas de dispersión de combinación de las variables.'),
    sidebarPanel(
      selectInput('A', 'Categoria', denue_data_categorias),
      selectInput('B', 'Alcaldia', denue_data_municipio),
      selectInput('C', 'Insitiu (1 bajo, 2 regular, 3, alto)', denue_data_insitu),
      selectInput('D', 'Alcaldia 2', denue_data_municipio, selected = denue_data_municipio[[2]]),
    ),
    mainPanel(
      plotOutput('grafica1')
      )
      )                                    
    )
  
), # END EXPLORACION DE DATOS

  navbarMenu("Proyecto",
    tabPanel("SOBRE EL PROYECTO",
      includeHTML("~/sigdata/archivos2/sigdata/PROYECTOS/foodwastemexicocity/html/introduccion.html")
      )
  )
) # END NAVBAR PAGE
) # END BOOTSTRAP PAGE