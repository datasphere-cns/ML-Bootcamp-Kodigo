
# Dashboard Interactivo en R con Shiny

Este documento es una introduccion practica al uso de **Shiny**, una libreria de R que permite construir aplicaciones web interactivas sin salir del ecosistema R.

---

## ¿Que es Shiny?

**Shiny** es un paquete de R desarrollado por RStudio que permite construir aplicaciones web reactivas directamente desde scripts de R. No requiere conocimientos de HTML, JavaScript o CSS (aunque se puede extender con ellos si se desea).

**Con Shiny puedes:**

- Crear dashboards interactivos
- Filtrar datos en tiempo real
- Mostrar graficos, tablas y resumenes con inputs del usuario
- Compartir analisis de datos de forma accesible y profesional

---

## Ejemplo: Dashboard de Transacciones con Tarjetas

Este ejemplo usa un dataset simulado de transacciones con tarjetas de credito.

### Requisitos

Antes de ejecutar este dashboard, instala los paquetes necesarios:

```r
install.packages(c("shiny", "tidyverse", "readr"))
```

---

### Codigo completo del dashboard

```r
library(shiny)
library(tidyverse)
library(readr)
library(ggplot2)

# Cargar el dataset
df <- read_csv("C:/virtual_environment/Mod01/R-Lang/transacciones_tarjetas.csv")

# UI
ui <- fluidPage(
  titlePanel("Dashboard de Transacciones con Tarjetas"),
  sidebarLayout(
    sidebarPanel(
      selectInput("categoria", "Categoria:",
                  choices = c("Todas", unique(df$categoria))),
      sliderInput("edad", "Rango de Edad:",
                  min = min(df$edad), max = max(df$edad),
                  value = c(min(df$edad), max(df$edad))),
      selectInput("genero", "Genero:",
                  choices = c("Todos", unique(df$genero))),
      checkboxInput("log_scale", "Usar escala logaritmica en montos", FALSE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Resumen", 
                 verbatimTextOutput("resumen")),
        tabPanel("Grafico de Montos", 
                 plotOutput("plot_montos")),
        tabPanel("Distribucion por Ciudad", 
                 plotOutput("plot_ciudad")),
        tabPanel("Relacion Edad - Monto", 
                 plotOutput("plot_edad_monto"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  data_filtrada <- reactive({
    datos <- df %>%
      filter(edad >= input$edad[1], edad <= input$edad[2])
    if (input$categoria != "Todas") {
      datos <- datos %>% filter(categoria == input$categoria)
    }
    if (input$genero != "Todos") {
      datos <- datos %>% filter(genero == input$genero)
    }
    return(datos)
  })

  output$resumen <- renderPrint({
    summary(data_filtrada())
  })

  output$plot_montos <- renderPlot({
    ggplot(data_filtrada(), aes(x = monto)) +
      geom_histogram(bins = 30, fill = "#0073C2FF", color = "white") +
      scale_x_continuous(trans = ifelse(input$log_scale, "log10", "identity")) +
      labs(title = "Distribucion de montos", x = "Monto", y = "Frecuencia") +
      theme_minimal()
  })

  output$plot_ciudad <- renderPlot({
    ggplot(data_filtrada(), aes(x = ciudad, fill = ciudad)) +
      geom_bar() +
      theme_minimal() +
      theme(legend.position = "none") +
      coord_flip() +
      labs(title = "Numero de transacciones por ciudad", x = "Ciudad", y = "Conteo")
  })

  output$plot_edad_monto <- renderPlot({
    ggplot(data_filtrada(), aes(x = edad, y = monto, color = genero)) +
      geom_point(alpha = 0.6) +
      theme_minimal() +
      labs(title = "Relacion entre edad y monto", x = "Edad", y = "Monto")
  })
}

# Ejecutar app
shinyApp(ui = ui, server = server)
```

---

## Como ejecutar este dashboard

1. Guarda este codigo en un archivo llamado `app.R`
2. Abre RStudio
3. Usa el boton **Run App** o ejecuta:

```r
shiny::runApp("app.R")
```

El dashboard se abrira en tu navegador, permitiendote filtrar los datos y explorar visualmente las transacciones.

---

## Que incluye este dashboard

- **Filtros interactivos**: edad, categoria, genero
- **Escala logaritmica** opcional en montos
- **Resumen estadistico** del dataset filtrado
- **Graficos dinamicos**: histogramas, scatterplots, barras

