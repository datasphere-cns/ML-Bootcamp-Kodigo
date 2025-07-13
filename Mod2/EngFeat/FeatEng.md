# Ingeniería de Features en Machine Learning

La **ingeniería de features** (o *feature engineering*) en Machine Learning es el proceso de **transformar los datos brutos en variables** que un modelo pueda entender y aprovechar para hacer **mejores predicciones**.

Es uno de los pasos más importantes del flujo de trabajo en ML, y puede marcar la diferencia entre un modelo **mediocre** y uno de **alto rendimiento**.

Nelson Zepeda, Julio 2025

---

## ¿Qué es exactamente una "feature"?

Una **feature** (o característica) es una **columna o variable** que representa una propiedad de tus datos.

### Ejemplos:

- En un modelo de predicción de precios de casas:
  - `tamaño_m2`, `nro_habitaciones`, `ubicación`, `año_construcción`

- En un modelo de clasificación de texto:
  - `longitud_del_texto`, `frecuencia_de_palabras`, `presencia_de_palabra_clave`

---

## ¿Qué incluye la ingeniería de features?

Aquí algunas tareas típicas:

| Técnica                      | Descripción                                      | Ejemplo                                      |
|-----------------------------|--------------------------------------------------|----------------------------------------------|
| Selección de features       | Elegir solo las variables más útiles             | Eliminar columnas redundantes o irrelevantes |
| Transformación de variables | Cambiar la forma de una variable                 | Aplicar logaritmo a una variable sesgada     |
| Codificación categórica     | Convertir texto en números                       | One-hot encoding para columna `color`        |
| Escalado/Normalización      | Poner todas las variables en la misma escala     | `StandardScaler`, `MinMaxScaler`             |
| Generación de nuevas features | Crear variables derivadas                    | `edad = 2025 - año_nacimiento`               |
| Tratamiento de fechas       | Extraer información útil de fechas              | Día de la semana, mes, feriado, etc.         |
| Manejo de valores faltantes | Imputar o eliminar `NaN`                         | Reemplazar con media o modelo predictivo     |
| Interacciones               | Combinar variables entre sí                      | `precio_unitario = total / cantidad`         |

---

## ¿Por qué es importante?

- Un modelo **simple con buenas features** puede superar a un modelo **complejo con malas features**.
- Mejora la **interpretabilidad**, **precisión** y **robustez** del modelo.
- Permite **incorporar conocimiento del dominio** en el proceso de aprendizaje.

---

## Ejemplo práctico

Supón que estás trabajando con **datos de transacciones de tarjetas de crédito**. En lugar de usar solo el monto (`amount`), podrías crear:

- `is_weekend`: si la transacción fue en fin de semana  
- `hour_of_day`: hora de la transacción  
- `log_amount`: logaritmo del monto (para reducir sesgo)  
- `avg_amount_user_30d`: gasto promedio del usuario en 30 días  

Estas nuevas features pueden capturar **patrones más complejos** y mejorar el rendimiento del modelo.

---

##  Ejemplo de Codificación Categórica

###  Objetivo
Convertir una columna categórica (`color`) en variables numéricas que un modelo de Machine Learning pueda procesar.


### Datos Originales

| id | color   |
|----|---------|
| 1  | rojo    |
| 2  | azul    |
| 3  | verde   |
| 4  | rojo    |



### Aplicando One-Hot Encoding

One-hot encoding crea **una nueva columna por cada categoría** posible y marca con `1` si esa fila pertenece a esa categoría, y `0` en caso contrario.

| id | color_rojo | color_azul | color_verde |
|----|------------|------------|-------------|
| 1  | 1          | 0          | 0           |
| 2  | 0          | 1          | 0           |
| 3  | 0          | 0          | 1           |
| 4  | 1          | 0          | 0           |



### ¿Por qué se hace esto?

- Los modelos como regresión logística, redes neuronales y árboles **no pueden procesar texto directamente**.
- One-hot encoding evita que el modelo **asuma un orden inexistente** (como lo haría el Label Encoding).



### En Python con pandas

```python
import pandas as pd

df = pd.DataFrame({ 'color': ['rojo', 'azul', 'verde', 'rojo'] })
encoded = pd.get_dummies(df, columns=['color'])
print(encoded)
```
---

##  Ejemplo de Generación de Nuevas Features

###  Objetivo
Crear variables nuevas que **no existen directamente en los datos**, pero que pueden capturar relaciones importantes y mejorar el rendimiento del modelo.



###  Datos Originales

| id | fecha_nacimiento | fecha_transaccion | total | cantidad |
|----|------------------|-------------------|-------|----------|
| 1  | 1990-06-15       | 2025-07-09        | 100   | 4        |
| 2  | 1985-02-01       | 2025-07-09        | 60    | 2        |
| 3  | 2000-10-23       | 2025-07-09        | 150   | 3        |



###  Nuevas Features Generadas

| id | edad_usuario | precio_unitario | dia_semana_transaccion |
|----|--------------|-----------------|-------------------------|
| 1  | 35           | 25.0            | martes                  |
| 2  | 40           | 30.0            | martes                  |
| 3  | 24           | 50.0            | martes                  |

- `edad_usuario`: calculada como diferencia entre año de transacción y año de nacimiento
- `precio_unitario`: total / cantidad
- `dia_semana_transaccion`: día de la semana extraído de la fecha



###  En Python con pandas

```python
import pandas as pd

df = pd.DataFrame({
    'fecha_nacimiento': ['1990-06-15', '1985-02-01', '2000-10-23'],
    'fecha_transaccion': ['2025-07-09'] * 3,
    'total': [100, 60, 150],
    'cantidad': [4, 2, 3]
})

df['fecha_nacimiento'] = pd.to_datetime(df['fecha_nacimiento'])
df['fecha_transaccion'] = pd.to_datetime(df['fecha_transaccion'])

# Nueva feature: edad del usuario
df['edad_usuario'] = df['fecha_transaccion'].dt.year - df['fecha_nacimiento'].dt.year

# Nueva feature: precio por unidad
df['precio_unitario'] = df['total'] / df['cantidad']

# Nueva feature: día de la semana
df['dia_semana_transaccion'] = df['fecha_transaccion'].dt.day_name()

print(df)
```
---

## Ejemplo de Tratamiento de Fechas

### Objetivo
Extraer **información útil y estructurada** a partir de variables de tipo fecha para enriquecer el dataset y mejorar las predicciones del modelo.


### Datos Originales

| id | fecha_transaccion     |
|----|------------------------|
| 1  | 2025-07-09             |
| 2  | 2025-12-24             |
| 3  | 2025-01-01             |



### Features Derivadas

| id | año | mes | dia | dia_semana | es_fin_de_semana |
|----|-----|-----|-----|------------|------------------|
| 1  | 2025|  7  |  9  | miércoles  | False            |
| 2  | 2025| 12  | 24  | miércoles  | False            |
| 3  | 2025|  1  |  1  | miércoles  | False            |



### En Python con pandas

```python
import pandas as pd

df = pd.DataFrame({
    'fecha_transaccion': ['2025-07-09', '2025-12-24', '2025-01-01']
})

df['fecha_transaccion'] = pd.to_datetime(df['fecha_transaccion'])

# Extraer componentes de fecha
df['año'] = df['fecha_transaccion'].dt.year
df['mes'] = df['fecha_transaccion'].dt.month
df['dia'] = df['fecha_transaccion'].dt.day
df['dia_semana'] = df['fecha_transaccion'].dt.day_name()
df['es_fin_de_semana'] = df['fecha_transaccion'].dt.dayofweek >= 5  # sábado=5, domingo=6

print(df)
```
---
## Bonus: ¿Dónde ocurre la ingeniería de features?

La ingeniería de features suele hacerse **antes del entrenamiento del modelo**, como parte del **pipeline de preprocesamiento**. En proyectos más avanzados, se incluyen pasos automáticos con herramientas como:

- `scikit-learn` Pipelines
- `FeatureUnion`
- `Featuretools`
- `dbt` o herramientas de orquestación de datos

