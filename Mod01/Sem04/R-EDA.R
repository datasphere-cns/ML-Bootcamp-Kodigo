# Paso 0: Instalar y cargar los paquetes necesarios
# Descomenta y ejecuta estas líneas si no tienes los paquetes instalados
# install.packages(c("dplyr", "ggplot2", "lubridate", "skimr", "rstatix", "car"))

#remove.packages("rlang")
#remove.packages("dplyr")

#install.packages("rlang", dependencies = TRUE)
#install.packages("tidyverse", dependencies = TRUE)


library(dplyr)      # Manipulación de datos
library(ggplot2)    # Visualización de datos
library(lubridate)  # Transformaciones de fecha
library(skimr)      # Resúmenes estadísticos detallados
library(rstatix)    # Para algunas pruebas estadísticas como normalidad y outliers (opcional, pero útil)
library(car)        # Para la prueba de Levene (homocedasticidad, no varianza cero)
library(forcats)    # Manipulación de factores, incluye fct_infreq()
# --- Parte 1: Creación de Datos Ficticios de Transacciones con Tarjeta de Crédito ---

message("--- Creando DataFrame con Datos Ficticios de Transacciones ---")

set.seed(123) # Para reproducibilidad de los datos aleatorios

n_transactions <- 20 # Número de transacciones
start_date <- as.Date("2024-01-01")
end_date <- as.Date("2024-03-31")

transactions_df <- tibble(
  transaction_id = 1001:(1000 + n_transactions),
  transaction_date = sample(seq(start_date, end_date, by = "day"), n_transactions, replace = TRUE),
  amount = round(c(
    runif(n_transactions - 3, min = 5, max = 200), # Mayoría de transacciones normales
    5000, # Un outlier grande (por ejemplo, compra de un electrodoméstico grande)
    1,    # Un outlier pequeño (por ejemplo, compra de un chicle)
    1000  # Otro outlier (por ejemplo, viaje)
  ), 2),
  category = sample(c("Groceries", "Entertainment", "Utilities", "Dining", "Shopping", "Travel"),
                    n_transactions, replace = TRUE, prob = c(0.3, 0.15, 0.1, 0.2, 0.15, 0.1)),
  card_type = sample(c("Visa", "Mastercard", "Amex"), n_transactions, replace = TRUE, prob = c(0.5, 0.4, 0.1)),
  location = sample(c("San Salvador", "Santa Tecla", "Antiguo Cuscatlán", "Suchitoto", "La Libertad"),
                    n_transactions, replace = TRUE)
)

message("DataFrame 'transactions_df' creado con", n_transactions, "transacciones ficticias.")
print(head(transactions_df))

# --- Parte 2: Transformaciones de Fecha ---

message("\n--- Realizando Transformaciones de Fecha ---")

transactions_df <- transactions_df %>%
  mutate(
    year = year(transaction_date),
    month = month(transaction_date, label = TRUE, abbr = FALSE), # Nombre completo del mes
    day = day(transaction_date),
    weekday = wday(transaction_date, label = TRUE, abbr = FALSE), # Nombre completo del día de la semana
    day_of_year = yday(transaction_date),
    quarter = quarter(transaction_date)
  )

message("Columnas de fecha (año, mes, día, día de la semana, día del año, trimestre) generadas.")
print(head(transactions_df))

# --- Parte 3: Análisis Exploratorio de Datos (EDA) ---

message("\n--- Iniciando Análisis Exploratorio de Datos (EDA) ---")

# 3.1. Visión General de los Datos
message("\n### Visión General de la Estructura del DataFrame ###")
glimpse(transactions_df)

message("\n### Resumen Estadístico Detallado (Paquete skimr) ###")
skim(transactions_df)

message("\n### Conteo de Valores Faltantes (NA) por Columna ###")
print(colSums(is.na(transactions_df)))

# 3.2. Análisis de Variables Numéricas

message("\n### Análisis de Variables Numéricas ###")

# Identificación de Outliers (Método IQR - Rango Intercuartílico)
# Una transacción es un outlier si está por debajo de Q1 - 1.5*IQR o por encima de Q3 + 1.5*IQR
message("\n--- Identificación de Outliers en 'amount' (Método IQR) ---")
amount_iqr <- IQR(transactions_df$amount)
q1_amount <- quantile(transactions_df$amount, 0.25)
q3_amount <- quantile(transactions_df$amount, 0.75)
lower_bound <- q1_amount - 1.5 * amount_iqr
upper_bound <- q3_amount + 1.5 * amount_iqr

outliers_amount <- transactions_df %>%
  filter(amount < lower_bound | amount > upper_bound)

if (nrow(outliers_amount) > 0) {
  message("Outliers detectados en la columna 'amount':")
  print(outliers_amount)
} else {
  message("No se detectaron outliers en 'amount' usando el método IQR.")
}
# Visualización de Outliers con Boxplot (se hará en la sección de gráficas)

# Prueba de Normalidad (Shapiro-Wilk Test) para 'amount'
# H0: Los datos se distribuyen normalmente.
# Ha: Los datos no se distribuyen normalmente.
# NOTA: Para n pequeño (como 20), Shapiro-Wilk es más adecuado. Si p-valor < 0.05, rechazamos H0.
message("\n--- Prueba de Normalidad (Shapiro-Wilk) para 'amount' ---")
shapiro_test_result <- shapiro.test(transactions_df$amount)
print(shapiro_test_result)
if (shapiro_test_result$p.value < 0.05) {
  message("Con un p-valor de", round(shapiro_test_result$p.value, 4), ", la variable 'amount' NO parece seguir una distribución normal.")
} else {
  message("Con un p-valor de", round(shapiro_test_result$p.value, 4), ", la variable 'amount' parece seguir una distribución normal.")
}


# Prueba de Varianza Cero en Variables Numéricas
message("\n--- Prueba de Varianza Cero en Variables Numéricas ---")
numeric_cols <- transactions_df %>% select_if(is.numeric) %>% names()

for (col in numeric_cols) {
  if (var(transactions_df[[col]], na.rm = TRUE) == 0) {
    message("La columna '", col, "' tiene varianza cero. Todos sus valores son iguales.")
  } else {
    message("La columna '", col, "' tiene varianza diferente de cero.")
  }
}
# La varianza cero indica que todos los valores en la columna son idénticos.

# Correlaciones entre Variables Numéricas
# Usamos `cor()` para calcular la matriz de correlación.
# Solo aplicable a variables numéricas con varianza.
message("\n--- Matriz de Correlación entre Variables Numéricas ---")
# Selecciona solo las columnas numéricas que tienen varianza (no todas son relevantes para correlación)
cor_data <- transactions_df %>%
  select(amount, year, day, day_of_year) # Seleccionamos las que tienen sentido para correlacionar

# Calculamos la matriz de correlación
correlation_matrix <- cor(cor_data, use = "pairwise.complete.obs") # Ignora NAs
print(correlation_matrix)
# Interpretación: Valores cercanos a 1 o -1 indican correlación fuerte positiva o negativa.
# Valores cercanos a 0 indican poca o ninguna correlación lineal.
# Para N=20, las correlaciones deben interpretarse con mucha cautela.

# 3.3. Análisis de Variables Categóricas
message("\n### Análisis de Variables Categóricas ###")

message("\n--- Frecuencia de 'category' ---")
transactions_df %>% count(category) %>% arrange(desc(n)) %>% print()

message("\n--- Frecuencia de 'card_type' ---")
transactions_df %>% count(card_type) %>% arrange(desc(n)) %>% print()

message("\n--- Frecuencia de 'location' ---")
transactions_df %>% count(location) %>% arrange(desc(n)) %>% print()

message("\n--- Frecuencia de 'month' ---")
transactions_df %>% count(month) %>% print() # Ya viene ordenado por factor de lubridate

message("\n--- Frecuencia de 'weekday' ---")
transactions_df %>% count(weekday) %>% print() # Ya viene ordenado por factor de lubridate

# --- Parte 4: Generación de Gráficas de EDA ---

message("\n--- Generando Gráficas de EDA ---")

# Gráfica 1: Histograma de 'amount' (para ver la distribución y el impacto de outliers)
p1_hist_amount <- ggplot(transactions_df, aes(x = amount)) +
  geom_histogram(binwidth = 50, fill = "steelblue", color = "black", alpha = 0.7) +
  labs(title = "Distribución de los Montos de Transacción",
       subtitle = "La presencia de outliers afecta la visualización de la mayoría de datos.",
       x = "Monto de Transacción",
       y = "Frecuencia") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5))
print(p1_hist_amount)

# Gráfica 2: Histograma de log(amount) (si 'amount' es sesgado)
# Una transformación logarítmica suele mejorar la visualización de datos sesgados.
# Solo transformamos si no hay montos <= 0 para evitar infinitos/NaN.
if (min(transactions_df$amount) > 0) {
  p2_hist_log_amount <- ggplot(transactions_df, aes(x = log(amount))) +
    geom_histogram(binwidth = 0.5, fill = "darkgreen", color = "black", alpha = 0.7) +
    labs(title = "Distribución de Log(Montos de Transacción)",
         subtitle = "Mejora la visualización para datos muy sesgados.",
         x = "Logaritmo del Monto de Transacción",
         y = "Frecuencia") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          plot.subtitle = element_text(hjust = 0.5))
  print(p2_hist_log_amount)
} else {
  message("Advertencia: No se generó el histograma de log(amount) porque hay montos <= 0.")
}


# Gráfica 3: Boxplot de 'amount' por 'category' (identificación de outliers por grupo)
# Este boxplot también podría necesitar una escala logarítmica si los outliers son muy extremos.
p3_boxplot_category <- ggplot(transactions_df, aes(x = category, y = amount, fill = category)) +
  geom_boxplot(alpha = 0.7, outlier.colour = "red", outlier.shape = 8) +
  labs(title = "Montos de Transacción por Categoría",
       subtitle = "Se muestran los outliers en rojo. Considera una escala logarítmica si el gráfico es ilegible.",
       x = "Categoría",
       y = "Monto de Transacción") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), # Rotar etiquetas del eje X
        plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5),
        legend.position = "none") # Quitar leyenda si el color es el mismo que el eje X
print(p3_boxplot_category)

# Gráfica 4: Boxplot de log(amount) por 'category' (si p3_boxplot_category es ilegible)
if (min(transactions_df$amount) > 0) {
  p4_boxplot_log_category <- ggplot(transactions_df, aes(x = category, y = log(amount), fill = category)) +
    geom_boxplot(alpha = 0.7, outlier.colour = "red", outlier.shape = 8) +
    labs(title = "Log(Montos de Transacción) por Categoría",
         subtitle = "Transformación logarítmica para una mejor visualización de la distribución.",
         x = "Categoría",
         y = "Logaritmo del Monto de Transacción") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          plot.title = element_text(hjust = 0.5, face = "bold"),
          plot.subtitle = element_text(hjust = 0.5),
          legend.position = "none")
  print(p4_boxplot_log_category)
}


# Gráfica 5: Gráfica de Puntos (Scatter Plot) - Monto vs. Día del Mes
# Muestra si hay un patrón en los montos según el día de la transacción.
p5_scatter_day <- ggplot(transactions_df, aes(x = day, y = amount, color = category)) +
  geom_point(size = 3, alpha = 0.7) +
  labs(title = "Monto de Transacción vs. Día del Mes",
       subtitle = "Color por categoría para identificar patrones.",
       x = "Día del Mes",
       y = "Monto de Transacción") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5))
print(p5_scatter_day)

# Gráfica 6: Gráfica de Barras de Frecuencia por Categoría
p6_bar_category <- ggplot(transactions_df, aes(x = fct_infreq(category), fill = category)) + # fct_infreq ordena por frecuencia
  geom_bar(alpha = 0.8) +
  labs(title = "Frecuencia de Transacciones por Categoría",
       x = "Categoría",
       y = "Número de Transacciones") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, face = "bold"),
        legend.position = "none")
print(p6_bar_category)

# Gráfica 7: Gráfica de Barras de Monto Total por Tipo de Tarjeta
p7_bar_card_type <- transactions_df %>%
  group_by(card_type) %>%
  summarise(total_amount = sum(amount)) %>%
  ggplot(aes(x = reorder(card_type, total_amount), y = total_amount, fill = card_type)) +
  geom_col(alpha = 0.8) +
  labs(title = "Monto Total de Transacciones por Tipo de Tarjeta",
       x = "Tipo de Tarjeta",
       y = "Monto Total") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        legend.position = "none")
print(p7_bar_card_type)

message("\n--- Proceso de EDA Completado ---")

# --- Parte 5: Guardar Datos y Gráficos (Opcional) ---
# Puedes guardar tu dataframe y tus gráficos si lo deseas

# write.csv(transactions_df, "transacciones_analizadas.csv", row.names = FALSE)

# ggsave("hist_amount.png", plot = p1_hist_amount, width = 8, height = 6)
# if (min(transactions_df$amount) > 0) {
#   ggsave("hist_log_amount.png", plot = p2_hist_log_amount, width = 8, height = 6)
# }
# ggsave("boxplot_category.png", plot = p3_boxplot_category, width = 9, height = 6)
# if (min(transactions_df$amount) > 0) {
#   ggsave("boxplot_log_category.png", plot = p4_boxplot_log_category, width = 9, height = 6)
# }
# ggsave("scatter_day.png", plot = p5_scatter_day, width = 9, height = 6)
# ggsave("bar_category_freq.png", plot = p6_bar_category, width = 8, height = 6)
# ggsave("bar_card_type_total.png", plot = p7_bar_card_type, width = 8, height = 6)
