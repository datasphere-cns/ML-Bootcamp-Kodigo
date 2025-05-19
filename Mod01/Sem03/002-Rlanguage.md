
# Visualizaciones con ggplot2 - Transacciones con Tarjeta

En este documento se utilizan datos simulados de transacciones de tarjeta de credito para crear visualizaciones funcionales usando `ggplot2`.

Pasos para instalar un paquete:
install.packages("ggplot2")

---

## Paso 1: Cargar paquetes y dataset

```r
library(ggplot2)
library(readr)
library(dplyr)
library(scales)

# Cargar dataset
df <- read_csv("transacciones_tarjetas.csv")
```

---

## Paso 2: Histograma del monto de transaccion

```r
ggplot(df, aes(x = monto)) +
  geom_histogram(bins = 30, fill = "#0073C2FF", color = "white") +
  labs(title = "Distribucion de monto de transacciones",
       x = "Monto", y = "Frecuencia") +
  theme_minimal()
```

---

## Paso 3: Boxplot por categoria

```r
ggplot(df, aes(x = categoria, y = monto, fill = categoria)) +
  geom_boxplot() +
  labs(title = "Boxplot de monto por categoria",
       x = "Categoria", y = "Monto") +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()
```

---

## Paso 4: Densidad de monto por genero

```r
ggplot(df, aes(x = monto, fill = genero)) +
  geom_density(alpha = 0.6) +
  labs(title = "Densidad de monto por genero",
       x = "Monto", y = "Densidad") +
  theme_minimal()
```

---

## Paso 5: Barras de conteo por ciudad

```r
ggplot(df, aes(x = ciudad, fill = ciudad)) +
  geom_bar() +
  labs(title = "Numero de transacciones por ciudad") +
  theme_minimal() +
  theme(legend.position = "none") +
  coord_flip()
```

---

## Paso 6: Barras apiladas de genero por categoria

```r
ggplot(df, aes(x = categoria, fill = genero)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Proporcion de genero por categoria",
       y = "Porcentaje", x = "Categoria") +
  theme_minimal()
```

---

## Paso 7: Scatterplot edad vs monto

```r
ggplot(df, aes(x = edad, y = monto, color = genero)) +
  geom_point(alpha = 0.7) +
  labs(title = "Relacion entre edad y monto de transaccion",
       x = "Edad", y = "Monto") +
  theme_minimal()
```

---

## Paso 8: Violin plot por hora del dia

```r
ggplot(df, aes(x = factor(hora), y = monto, fill = factor(hora))) +
  geom_violin() +
  labs(title = "Distribucion de monto por hora del dia",
       x = "Hora", y = "Monto") +
  theme_minimal() +
  theme(legend.position = "none")
```

---

## Paso 9: Line plot de transacciones en el tiempo

```r
df_dia <- df %>%
  mutate(fecha = as.Date(fecha)) %>%
  group_by(fecha) %>%
  summarise(monto_total = sum(monto))

ggplot(df_dia, aes(x = fecha, y = monto_total)) +
  geom_line(color = "#E69F00", size = 1) +
  labs(title = "Monto total diario de transacciones",
       x = "Fecha", y = "Monto total") +
  theme_minimal()
```

---

## Paso 10: Heatmap de monto medio por hora y categoria

```r
df_heat <- df %>%
  group_by(hora, categoria) %>%
  summarise(promedio = mean(monto))

ggplot(df_heat, aes(x = factor(hora), y = categoria, fill = promedio)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "#56B1F7", high = "#132B43") +
  labs(title = "Heatmap de monto medio por hora y categoria",
       x = "Hora", y = "Categoria") +
  theme_minimal()
```

---

Estas visualizaciones aprovechan la estetica y flexibilidad de `ggplot2` para descubrir patrones y comportamientos en datos de transacciones con tarjetas de credito.

