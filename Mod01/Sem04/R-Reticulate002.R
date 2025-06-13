# Paso 0: Cargar paquetes de R
library(reticulate) # Para la interoperabilidad R <-> Python
library(dplyr)      # Para manipulación de datos en R
library(ggplot2)    # Para visualización en R

# --- Parte 1: Configurar el Entorno de Python ---
message("--- Configurando entorno de Python con reticulate ---")

# ¡IMPORTANTE! Reemplaza esta ruta con la ruta a tu entorno virtual de Python
# que reticulate puede inicializar correctamente (ej. el 'r_python_env' que creamos).
python_env_path <- "C:/virtual_environment/r_python_env" 

# Intenta usar el entorno virtual
tryCatch({
  use_virtualenv(virtualenv = python_env_path, required = TRUE)
  message(paste("Usando el entorno de Python:", py_config()$python))
  
  # Opcional: Instalar paquetes Python si no están en el entorno
  # Este paso solo es necesario la primera vez para asegurar que tienes los paquetes Python necesarios
  py_install(packages = c("pandas", "numpy", "scikit-learn"), envname = python_env_path)
  message("Paquetes Python (pandas, numpy, scikit-learn) verificados/instalados.")
  
}, error = function(e) {
  message("Error al inicializar el entorno Python:")
  message(e$message)
  message("Por favor, asegúrate de que la ruta al entorno virtual sea correcta y que esté funcional.")
  stop("El script se detiene debido a un error de configuración de Python.")
})


# --- Parte 2: Generar Datos de Ejemplo en R ---
message("\n--- Generando datos de ejemplo en R ---")

# Crear un data frame simple para un ejemplo de regresión lineal
set.seed(123) # Para reproducibilidad
data_r <- data.frame(
  X = runif(100, 0, 10), # Variable independiente
  error = rnorm(100, 0, 1.5) # Ruido aleatorio
) %>%
  mutate(Y = 2.5 * X + 5 + error) # Variable dependiente (Y = 2.5*X + 5 + ruido)

print(head(data_r))

# --- Parte 3: Pasar Datos de R a Python y Realizar Análisis con scikit-learn ---
message("\n--- Pasando datos a Python y realizando análisis con scikit-learn ---")

# 1. Importar módulos de Python
pd <- import("pandas")
np <- import("numpy")
sklearn_linear_model <- import("sklearn.linear_model")
sklearn_model_selection <- import("sklearn.model_selection") # Para train_test_split

# 2. Convertir el data frame de R a un DataFrame de Pandas
df_py <- r_to_py(data_r)
message("DataFrame de R convertido a Pandas DataFrame.")
# print(df_py$head()) # Puedes imprimir los primeros elementos del DataFrame de Pandas

# 3. Preparar los datos para el modelo de Machine Learning en Python
# Reshape X para que scikit-learn lo acepte (necesita un array 2D para X)
X_py <- df_py$X$values$reshape(c(-1L, 1L)) # Convierte a NumPy array y reshape
Y_py <- df_py$Y$values # Convierte a NumPy array

message("Datos preparados para scikit-learn.")

# 4. Dividir los datos en conjuntos de entrenamiento y prueba (opcional, buena práctica)
# Train_test_split devuelve una tupla de NumPy arrays
split_data <- sklearn_model_selection$train_test_split(X_py, Y_py, test_size = 0.2, random_state = 42L)
X_train <- split_data[[1]]
X_test <- split_data[[2]]
Y_train <- split_data[[3]]
Y_test <- split_data[[4]]
message("Datos divididos en entrenamiento y prueba.")


# 5. Inicializar y entrenar un modelo de Regresión Lineal de scikit-learn
model_py <- sklearn_linear_model$LinearRegression()
model_py$fit(X_train, Y_train)
message("Modelo de Regresión Lineal entrenado en Python.")

# 6. Obtener predicciones y coeficientes del modelo en Python
predictions_py <- model_py$predict(X_py) # Predicciones sobre todos los datos originales
coefficients_py <- model_py$coef_ # Coeficientes (pendiente)
intercept_py <- model_py$intercept_ # Intercepto

message("Predicciones y coeficientes obtenidos de Python.")
message(paste("Coeficiente (pendiente):", round(py_to_r(coefficients_py), 3)))
message(paste("Intercepto:", round(py_to_r(intercept_py), 3)))


# --- Parte 4: Obtener Resultados de Python de Vuelta a R ---
message("\n--- Obteniendo resultados de Python de vuelta a R ---")

# Convertir las predicciones de NumPy array a un vector de R
predictions_r <- py_to_r(predictions_py)

# Añadir las predicciones a nuestro data frame original de R
data_r_with_predictions <- data_r %>%
  mutate(Y_predicted = predictions_r)

print(head(data_r_with_predictions))


# --- Parte 5: Visualizar los Resultados en R con ggplot2 ---
message("\n--- Visualizando los resultados en R con ggplot2 ---")

p <- ggplot(data_r_with_predictions, aes(x = X, y = Y)) +
  geom_point(alpha = 0.6, color = "darkblue", size = 2) + # Puntos de datos originales
  geom_line(aes(y = Y_predicted), color = "red", linetype = "dashed", size = 1) + # Línea de regresión de Python
  labs(title = "Regresión Lineal: Datos de R, Modelo de Python, Gráfico de R",
       subtitle = paste("Y =", round(py_to_r(coefficients_py), 2), "* X +", round(py_to_r(intercept_py), 2)),
       x = "Variable Independiente (X)",
       y = "Variable Dependiente (Y)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(hjust = 0.5))

print(p)
message("Gráfico final generado.")

message("\n--- Ejemplo completo de R con Python finalizado ---")
