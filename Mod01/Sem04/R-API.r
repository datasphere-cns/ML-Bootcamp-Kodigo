# Paso 0: Instalar y cargar los paquetes necesarios
# Descomenta y ejecuta estas líneas si no tienes los paquetes instalados
# install.packages(c("httr", "jsonlite", "dplyr", "ggplot2", "tidyr", "skimr"))

library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)
library(tidyr)
library(skimr) # Para un resumen estadístico más completo y legible

# --- Parte 1: Obtención de Datos de la API ---

message("--- Iniciando proceso de obtención de datos de la API ---")

# 1. Definir la URL de la API
api_url <- "https://api.unirateapi.com/api/rates"

# 2. Definir los parámetros de la consulta
# ¡IMPORTANTE! Reemplaza "TU_LLAVE_API_PERSONAL_AQUI" con tu llave API válida.
api_params <- list(
  api_key = "", # ¡Cambia esto con tu llave real!
  from = "USD"
)

# 3. Realizar la solicitud GET a la API
response <- GET(api_url, query = api_params)

# 4. Verificar el estado de la respuesta y procesar
if (http_status(response)$category == "Success") {
  message("La solicitud a la API fue exitosa. Procesando datos...")
  
  json_content <- content(response, "text", encoding = "UTF-8")
  data_list <- fromJSON(json_content)
  
  if (!is.null(data_list$rates)) {
    # 5. Transformar el data frame de formato "ancho" a "largo"
    rates_df_wide <- as.data.frame(data_list$rates)
    
    rates_long <- rates_df_wide %>%
      tibble::rownames_to_column(var = "dummy_col") %>%
      pivot_longer(
        cols = -dummy_col,
        names_to = "currency",
        values_to = "rate"
      ) %>%
      select(currency, rate) %>%
      mutate(base_currency = api_params$from) %>%
      select(base_currency, currency, rate) %>%
      mutate(rate = as.numeric(rate))
    
    message("Datos de tasas de cambio cargados en el data frame 'rates_long'.")
    
    # --- Parte 2: Transformaciones de Datos (Feature Engineering Básico) ---
    
    message("\n--- Realizando Transformaciones de Datos (Feature Engineering) ---")
    rates_transformed <- rates_long %>%
      mutate(
        # 1. Transformación Logarítmica: CRUCIAL para visualizar distribuciones sesgadas
        # Los valores logarítmicos hacen que las diferencias relativas sean más claras
        # y permiten que los boxplots y histogramas muestren mejor la forma de la distribución.
        log_rate = log(rate),
        # 2. Tasa Inversa: Cuánto de la moneda base obtienes por 1 unidad de la moneda objetivo
        inverse_rate = 1 / rate,
        # 3. Categorización de Monedas (ejemplo simple: cripto vs fiat)
        currency_type = case_when(
          currency %in% c("BTC", "ETH", "XRP", "LTC", "ADA", "SOL", "DOGE", "SHIB", "DOT", "LINK", "UNI", "BCH", "MATIC", "AVAX", "BNB", "TRX", "XLM", "ICP", "VET", "ETC", "FIL", "EOS", "ALGO", "ZEC", "DASH", "XMR", "NEO", "ONT", "QTUM", "AKT", "ALCX", "ALEO", "ALEPH", "AR", "ARB", "ARKM", "ARPA", "ASM", "AST", "ATA", "ATH", "ATOM", "ATS", "AUCTION", "AUDIO", "AURORA", "API3") ~ "Crypto", # Se han añadido más criptomonedas de tu imagen
          TRUE ~ "Fiat"
        )
      )
    
    message("Nuevas columnas 'log_rate', 'inverse_rate' y 'currency_type' añadidas al data frame 'rates_transformed'.")
    
    # --- Parte 3: Exploratory Data Analysis (EDA) ---
    
    message("\n--- Realizando Análisis Exploratorio de Datos (EDA) ---")
    
    message("\n### Estructura del Data Frame 'rates_transformed' ###")
    glimpse(rates_transformed)
    
    message("\n### Resumen Estadístico Detallado (Paquete skimr) ###")
    skim(rates_transformed)
    
    message("\n### Conteo de Valores Faltantes (NA) por Columna ###")
    print(colSums(is.na(rates_transformed)))
    
    message("\n### Resumen de Tasas por Tipo de Moneda ###")
    rates_transformed %>%
      group_by(currency_type) %>%
      summarise(
        count = n(),
        min_rate = min(rate, na.rm = TRUE),
        max_rate = max(rate, na.rm = TRUE),
        mean_rate = mean(rate, na.rm = TRUE),
        median_rate = median(rate, na.rm = TRUE),
        sd_rate = sd(rate, na.rm = TRUE),
        .groups = 'drop'
      ) %>%
      print()
    
    # --- Parte 4: Generación de Gráficos de EDA Mejorados ---
    
    message("\n--- Generando Visualizaciones de EDA Mejoradas ---")
    
    # Visualización 1: Histograma de la Tasa Original
    # Este gráfico muestra el sesgo extremo de los datos brutos.
    p_hist_rate <- ggplot(rates_transformed, aes(x = rate)) +
      geom_histogram(binwidth = 1, fill = "#3182bd", color = "white", alpha = 0.8) +
      labs(title = paste("Distribución de Tasas de Cambio (1", api_params$from, "a otras Monedas)"),
           subtitle = "La mayoría de las tasas se agrupan cerca de cero, con valores extremos.",
           x = "Tasa de Cambio",
           y = "Frecuencia") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5))
    print(p_hist_rate)
    message("Histograma de Tasa Original (p_hist_rate) generado.")
    
    # Visualización 2: Histograma de la Tasa Logarítmica (¡Crucial para ver la distribución real!)
    # Este histograma debería mostrar una distribución mucho más simétrica y clara.
    p_hist_log_rate <- ggplot(rates_transformed, aes(x = log_rate)) +
      geom_histogram(binwidth = 0.5, fill = "#de2d26", color = "white", alpha = 0.8) +
      labs(title = paste("Distribución de Log(Tasa de Cambio) (1", api_params$from, "a otras Monedas)"),
           subtitle = "La transformación logarítmica revela la forma de la distribución real.",
           x = "Logaritmo de la Tasa de Cambio",
           y = "Frecuencia") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5))
    print(p_hist_log_rate)
    message("Histograma de Tasa Logarítmica (p_hist_log_rate) generado.")
    
    # Visualización 3: Boxplot de las Tasas por Tipo de Moneda (¡Mejorado con log_rate!)
    # Este boxplot ahora será legible y mostrará la distribución de las tasas dentro de cada tipo.
    p_boxplot_type_log <- ggplot(rates_transformed, aes(x = currency_type, y = log_rate, fill = currency_type)) +
      geom_boxplot(alpha = 0.8, outlier.colour = "red", outlier.shape = 8) + # Outliers marcados
      labs(title = paste("Distribución de Log(Tasas) por Tipo de Moneda (desde", api_params$from, ")"),
           subtitle = "Usando logaritmo para visualizar mejor la dispersión y la centralidad.",
           x = "Tipo de Moneda",
           y = "Logaritmo de la Tasa de Cambio") +
      scale_fill_manual(values = c("Crypto" = "#fc9272", "Fiat" = "#a1d99b")) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "bottom")
    print(p_boxplot_type_log)
    message("Boxplot por Tipo de Moneda (p_boxplot_type_log) generado con logaritmo.")
    
    # Opcional: Violin Plot (muestra la densidad además del boxplot)
    # También utiliza log_rate para una visualización efectiva.
    p_violin_type_log <- ggplot(rates_transformed, aes(x = currency_type, y = log_rate, fill = currency_type)) +
      geom_violin(trim = TRUE, alpha = 0.7) +
      geom_boxplot(width = 0.1, color = "black", alpha = 0.7) +
      labs(title = paste("Distribución de Log(Tasas) por Tipo de Moneda (Violin Plot)"),
           subtitle = "La forma del 'violín' muestra la densidad de las tasas logarítmicas.",
           x = "Tipo de Moneda",
           y = "Logaritmo de la Tasa de Cambio") +
      scale_fill_manual(values = c("Crypto" = "#fed98e", "Fiat" = "#fe9929")) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "bottom")
    print(p_violin_type_log)
    message("Violin Plot por Tipo de Moneda (p_violin_type_log) generado con logaritmo.")
    
    # Visualización 4: Top 20 Tasas (gráfico de barras mejorado)
    top_20_rates <- rates_transformed %>%
      arrange(desc(rate)) %>%
      head(20)
    
    p_top_rates <- ggplot(top_20_rates, aes(x = reorder(currency, rate), y = rate, fill = currency_type)) +
      geom_col(color = "black") +
      coord_flip() +
      labs(title = paste("Top 20 Tasas de Cambio (1", api_params$from, "a otras Monedas)"),
           subtitle = "Las monedas con las tasas más altas, coloreadas por tipo.",
           x = "Moneda",
           y = paste("Tasa de Cambio (por 1", api_params$from, ")")) +
      scale_fill_manual(values = c("Crypto" = "#a6bddb", "Fiat" = "#0570b0")) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "bottom")
    print(p_top_rates)
    message("Gráfico de Top 20 Tasas (p_top_rates) generado.")
    
    # Visualización 5: Las 20 Tasas Más Bajas (gráfico de barras mejorado)
    bottom_20_rates <- rates_transformed %>%
      arrange(rate) %>%
      head(20)
    
    p_bottom_rates <- ggplot(bottom_20_rates, aes(x = reorder(currency, desc(rate)), y = rate, fill = currency_type)) +
      geom_col(color = "black") +
      coord_flip() +
      labs(title = paste("Las 20 Tasas de Cambio Más Bajas (1", api_params$from, "a otras Monedas)"),
           subtitle = "Las monedas con las tasas más bajas, coloreadas por tipo.",
           x = "Moneda",
           y = paste("Tasa de Cambio (por 1", api_params$from, ")")) +
      scale_fill_manual(values = c("Crypto" = "#ef6548", "Fiat" = "#67000d")) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "bottom")
    print(p_bottom_rates)
    message("Gráfico de Bottom 20 Tasas (p_bottom_rates) generado.")
    
    # Opcional: Gráfico de Tasas Inversas (para ver cuánto USD obtienes por 1 unidad de otra moneda)
    p_inverse_rates <- rates_transformed %>%
      arrange(desc(inverse_rate)) %>%
      head(20) %>%
      ggplot(aes(x = reorder(currency, inverse_rate), y = inverse_rate, fill = currency_type)) +
      geom_col(color = "black") +
      coord_flip() +
      labs(title = paste("Top 20 Tasas Inversas (cuánto", api_params$from, "por 1 de otra moneda)"),
           subtitle = "Útil para entender el valor de monedas con tasas muy pequeñas.",
           x = "Moneda",
           y = paste(api_params$from, "por 1 Moneda")) +
      scale_fill_manual(values = c("Crypto" = "#2ca25f", "Fiat" = "#6a51a3")) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"),
            plot.subtitle = element_text(hjust = 0.5),
            legend.position = "bottom")
    print(p_inverse_rates)
    message("Gráfico de Top 20 Tasas Inversas (p_inverse_rates) generado.")
    
    # --- Parte 5: Guardar Datos y Gráficos (Opcional) ---
    message("\n--- Proceso completado. Puedes guardar tus datos y gráficos ---")
    # Para guardar el data frame transformado a un archivo CSV
    # write.csv(rates_transformed, "tasas_de_cambio_transformadas.csv", row.names = FALSE)
    
    # Para guardar los gráficos (descomenta y ajusta las rutas/nombres si los necesitas)
    # ggsave("histograma_tasas_original.png", plot = p_hist_rate, width = 9, height = 6)
    # ggsave("histograma_tasas_log.png", plot = p_hist_log_rate, width = 9, height = 6)
    # ggsave("boxplot_tipo_moneda_log.png", plot = p_boxplot_type_log, width = 8, height = 6)
    # ggsave("violinplot_tipo_moneda_log.png", plot = p_violin_type_log, width = 8, height = 6)
    # ggsave("top_20_tasas.png", plot = p_top_rates, width = 10, height = 7)
    # ggsave("bottom_20_tasas.png", plot = p_bottom_rates, width = 10, height = 7)
    # ggsave("top_20_tasas_inversas.png", plot = p_inverse_rates, width = 10, height = 7)
    
    
  } else {
    message("Error: No se encontraron tasas de cambio válidas en la respuesta de la API.")
    print(data_list)
  }
  
} else {
  message("Error: Hubo un problema en la solicitud a la API.")
  print(http_status(response))
  print(content(response, "text", encoding = "UTF-8"))
  message("Por favor, verifica tu llave API y tu conexión a internet.")
}
