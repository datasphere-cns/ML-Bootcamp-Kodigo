# app.R (Guarda este código como 'app.R' en una carpeta vacía)

# Cargar las librerías necesarias
library(shiny)
library(ggplot2)
library(dplyr)

# Definición de la Interfaz de Usuario (UI) de Shiny
ui <- fluidPage(
  # Título de la aplicación
  titlePanel("Detector de Anomalías de Transacciones (Basado en Regla Sigma)"),
  
  # Diseño con una barra lateral para controles y un panel principal para la salida
  sidebarLayout(
    sidebarPanel(
      h4("Configuración del Patrón 'Normal'"),
      # Entrada numérica para la media del patrón
      numericInput("mean_val",
                   "Media esperada de las transacciones (€):",
                   value = 70, min = 1),
      # Entrada numérica para la desviación estándar del patrón
      numericInput("sd_val",
                   "Desviación estándar esperada (€):",
                   value = 15, min = 0.1),
      # Entrada numérica para el umbral de desviación (cuántas sigmas)
      numericInput("sigma_threshold",
                   "Umbral de anomalía (N sigmas):",
                   value = 3, min = 1, max = 5, step = 0.5),
      
      hr(), # Línea horizontal para separar secciones
      
      h4("Nueva Transacción para Evaluar"),
      # Entrada numérica para el monto de la nueva transacción
      numericInput("new_transaction_amount",
                   "Monto de la nueva transacción (€):",
                   value = 100, min = 0),
      
      # Botón para activar el análisis
      actionButton("analyze_button", "Analizar Transacción"),
      
      hr(),
      
      # Salida de texto para el estado de la anomalía
      h4("Resultado del Análisis:"),
      textOutput("anomaly_status"),
      br(), # Salto de línea
      textOutput("z_score_output"),
      textOutput("limits_output")
    ),
    
    # Panel principal para el gráfico
    mainPanel(
      h4("Visualización de la Transacción vs. Patrón"),
      plotOutput("anomaly_plot")
    )
  )
)

# Definición de la Lógica del Servidor de Shiny
server <- function(input, output) {
  
  # Definir un valor reactivo para almacenar los resultados del análisis
  # Solo se actualiza cuando se presiona el botón
  analysis_results <- eventReactive(input$analyze_button, {
    # Obtener los valores de entrada
    mean_pattern <- input$mean_val
    sd_pattern <- input$sd_val
    threshold <- input$sigma_threshold
    transaction_amount <- input$new_transaction_amount
    
    # Calcular los límites de control (UCL = Upper Control Limit, LCL = Lower Control Limit)
    ucl <- mean_pattern + threshold * sd_pattern
    lcl <- mean_pattern - threshold * sd_pattern
    # Asegurarse de que el límite inferior no sea negativo
    lcl <- max(0, lcl)
    
    # Calcular la puntuación Z (Z-score)
    z_score <- (transaction_amount - mean_pattern) / sd_pattern
    
    # Determinar si es una anomalía
    is_anomaly <- transaction_amount > ucl || transaction_amount < lcl
    
    # Devolver una lista con todos los resultados
    list(
      amount = transaction_amount,
      mean = mean_pattern,
      sd = sd_pattern,
      ucl = ucl,
      lcl = lcl,
      z_score = z_score,
      is_anomaly = is_anomaly
    )
  })
  
  # Salida de texto para el estado de la anomalía
  output$anomaly_status <- renderText({
    results <- analysis_results()
    if (results$is_anomaly) {
      paste0("¡ANOMALÍA DETECTADA! El monto de ", results$amount, "€ está fuera del patrón.")
    } else {
      paste0("Transacción NORMAL. El monto de ", results$amount, "€ está dentro del patrón.")
    }
  })
  
  # Salida de texto para el Z-score
  output$z_score_output <- renderText({
    results <- analysis_results()
    paste0("Puntuación Z (Z-score): ", round(results$z_score, 2))
  })
  
  # Salida de texto para los límites
  output$limits_output <- renderText({
    results <- analysis_results()
    paste0("Límites de Control (", results$mean, " ± ", results$sd, " x ", results$threshold, "σ): ",
           round(results$lcl, 2), "€ - ", round(results$ucl, 2), "€")
  })
  
  # Gráfico de visualización
  output$anomaly_plot <- renderPlot({
    results <- analysis_results()
    
    # Generar datos simulados para mostrar la distribución histórica
    set.seed(42) # Para reproducibilidad del gráfico
    simulated_data <- data.frame(
      amount = rnorm(1000, results$mean, results$sd)
    ) %>%
      # Asegurar que los montos simulados no sean negativos si LCL es 0
      filter(amount >= 0)
    
    # Crear el gráfico
    ggplot(simulated_data, aes(x = amount)) +
      geom_histogram(aes(y = after_stat(density)), binwidth = results$sd / 3, fill = "lightblue", color = "darkblue", alpha = 0.7) +
      geom_density(color = "darkgreen", linetype = "dashed", size = 1) +
      
      # Línea para la media
      geom_vline(xintercept = results$mean, color = "purple", linetype = "solid", size = 1, alpha = 0.8) +
      annotate("text", x = results$mean, y = max(density(simulated_data$amount)$y) * 0.95,
               label = paste("Media:", round(results$mean, 2)), color = "purple", hjust = -0.1) +
      
      # Líneas para los límites de control superior e inferior
      geom_vline(xintercept = results$ucl, color = "red", linetype = "dashed", size = 1, alpha = 0.8) +
      annotate("text", x = results$ucl, y = max(density(simulated_data$amount)$y) * 0.85,
               label = paste("UCL:", round(results$ucl, 2)), color = "red", hjust = -0.1) +
      
      geom_vline(xintercept = results$lcl, color = "red", linetype = "dashed", size = 1, alpha = 0.8) +
      annotate("text", x = results$lcl, y = max(density(simulated_data$amount)$y) * 0.85,
               label = paste("LCL:", round(results$lcl, 2)), color = "red", hjust = 1.1) +
      
      # Punto para la nueva transacción
      geom_point(aes(x = results$amount, y = 0),
                 color = ifelse(results$is_anomaly, "darkred", "darkgreen"),
                 size = 8, shape = 18) + # Forma de diamante para el punto de la transacción
      annotate("text", x = results$amount, y = max(density(simulated_data$amount)$y) * 0.05,
               label = paste("Nueva Transacción:", results$amount, "€"),
               color = ifelse(results$is_anomaly, "darkred", "darkgreen"), vjust = -1) +
      
      # Títulos y etiquetas del gráfico
      labs(title = "Posición de la Nueva Transacción Respecto al Patrón",
           x = "Monto de Transacción (€)",
           y = "Densidad") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5))
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui = ui, server = server)
