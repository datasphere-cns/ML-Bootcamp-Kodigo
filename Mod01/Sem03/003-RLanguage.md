
# Analisis Exploratorio de Datos (EDA) en R - 60 pasos

Este cuaderno en R contiene 60 pasos para realizar un Analisis Exploratorio de Datos completo sobre un dataset de transacciones con tarjeta de credito.

---

## Paso 1: Cargar paquetes necesarios

```r
library(tidyverse)
library(readr)
library(ggplot2)
library(skimr)
library(DataExplorer)
library(dplyr)
```

---

## Paso 2: Leer el dataset

```r
df <- read_csv("transacciones_tarjetas.csv")
```

---

## Paso 3: Ver primeras filas

```r
head(df)
```

## Paso 4: Ver ultimas filas

```r
tail(df)
```

## Paso 5: Dimensiones

```r
dim(df)
```

## Paso 6: Nombres de columnas

```r
colnames(df)
```

## Paso 7: Ver estructura del dataset

```r
str(df)
```

## Paso 8: Ver resumen estadistico

```r
summary(df)
```

## Paso 9: Tipo de variables

```r
sapply(df, class)
```

## Paso 10: Ver valores unicos

```r
sapply(df, function(x) length(unique(x)))
```

## Paso 11: Verificar valores NA

```r
colSums(is.na(df))
```

## Paso 12: Porcentaje de NA

```r
mean(is.na(df)) * 100
```

## Paso 13: Ver filas completas

```r
sum(complete.cases(df))
```

## Paso 14: Ver duplicados

```r
sum(duplicated(df))
```

## Paso 15: Eliminar duplicados

```r
df <- df %>% distinct()
```

## Paso 16: Usar skimr para resumen detallado

```r
skim(df)
```

## Paso 17: Usar DataExplorer para overview

```r
plot_intro(df)
```

## Paso 18: Distribucion de variable numerica (monto)

```r
ggplot(df, aes(x = monto)) + geom_histogram(bins = 30, fill = "skyblue", color = "white")
```

## Paso 19: Boxplot de monto

```r
ggplot(df, aes(y = monto)) + geom_boxplot(fill = "orange")
```

## Paso 20: Densidad de monto

```r
ggplot(df, aes(x = monto)) + geom_density(fill = "purple", alpha = 0.5)
```

## Paso 21: Histograma de edad

```r
ggplot(df, aes(x = edad)) + geom_histogram(bins = 30, fill = "steelblue", color = "white")
```

## Paso 22: Conteo por ciudad

```r
ggplot(df, aes(x = ciudad)) + geom_bar(fill = "tomato") + coord_flip()
```

## Paso 23: Conteo por categoria

```r
ggplot(df, aes(x = categoria)) + geom_bar(fill = "seagreen") + coord_flip()
```

## Paso 24: Proporcion de genero

```r
ggplot(df, aes(x = genero, fill = genero)) + geom_bar()
```

## Paso 25: Relacion edad vs monto

```r
ggplot(df, aes(x = edad, y = monto)) + geom_point(alpha = 0.6)
```

## Paso 26: Densidad de monto por genero

```r
ggplot(df, aes(x = monto, fill = genero)) + geom_density(alpha = 0.5)
```

## Paso 27: Boxplot de monto por categoria

```r
ggplot(df, aes(x = categoria, y = monto, fill = categoria)) + geom_boxplot() + coord_flip()
```

## Paso 28: Scatterplot por ciudad

```r
ggplot(df, aes(x = ciudad, y = monto)) + geom_boxplot()
```

## Paso 29: Violin plot por hora

```r
ggplot(df, aes(x = factor(hora), y = monto, fill = factor(hora))) + geom_violin()
```

## Paso 30: Group by ciudad

```r
df %>% group_by(ciudad) %>% summarise(promedio_monto = mean(monto))
```

## Paso 31: Group by categoria

```r
df %>% group_by(categoria) %>% summarise(transacciones = n())
```

## Paso 32: Promedio de monto por genero

```r
df %>% group_by(genero) %>% summarise(prom_monto = mean(monto))
```

## Paso 33: Agregar columna edad_grupo

```r
df <- df %>% mutate(edad_grupo = cut(edad, breaks = c(0, 25, 40, 60, 100), labels = c("Joven", "Adulto", "Maduro", "Mayor")))
```

## Paso 34: Conteo por edad_grupo

```r
table(df$edad_grupo)
```

## Paso 35: Correlacion numerica

```r
df %>% select_if(is.numeric) %>% cor()
```

## Paso 36: Mapa de calor de correlaciones

```r
library(reshape2)
library(ggplot2)

cor_data <- round(cor(df %>% select_if(is.numeric)), 2)
melted_cor <- melt(cor_data)

ggplot(melted_cor, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = value)) +
  theme_minimal()
```

## Paso 37: Transacciones por hora

```r
ggplot(df, aes(x = hora)) + geom_bar(fill = "coral")
```

## Paso 38: Monto promedio por hora

```r
df %>% group_by(hora) %>% summarise(monto_prom = mean(monto)) %>%
  ggplot(aes(x = hora, y = monto_prom)) + geom_line() + geom_point()
```

## Paso 39: Scatter edad vs monto por genero

```r
ggplot(df, aes(x = edad, y = monto, color = genero)) + geom_point(alpha = 0.5)
```

## Paso 40: Crear columna monto_log

```r
df$monto_log <- log1p(df$monto)
```

## Paso 41: Histograma de monto_log

```r
ggplot(df, aes(x = monto_log)) + geom_histogram(bins = 30, fill = "darkgreen")
```

## Paso 42: Top 10 categorias con mayor gasto

```r
df %>% group_by(categoria) %>% summarise(total = sum(monto)) %>% arrange(desc(total)) %>% head(10)
```

## Paso 43: Barplot de top 5 ciudades

```r
df %>% count(ciudad) %>% top_n(5) %>%
  ggplot(aes(x = reorder(ciudad, n), y = n)) + geom_col(fill = "skyblue") + coord_flip()
```

## Paso 44: Ver datos faltantes con visdat

```r
# install.packages("visdat") si no esta instalado
library(visdat)
vis_dat(df)
```

## Paso 45: Comparar promedio por ciudad y genero

```r
df %>% group_by(ciudad, genero) %>% summarise(mean_monto = mean(monto)) %>%
  ggplot(aes(x = ciudad, y = mean_monto, fill = genero)) + geom_col(position = "dodge")
```

## Paso 46: Promedio por edad_grupo y categoria

```r
df %>% group_by(edad_grupo, categoria) %>% summarise(prom = mean(monto)) %>%
  ggplot(aes(x = categoria, y = prom, fill = edad_grupo)) + geom_col(position = "dodge")
```

## Paso 47: Facet grid por genero

```r
ggplot(df, aes(x = monto)) + geom_histogram(bins = 30) + facet_wrap(~ genero)
```

## Paso 48: Facet por ciudad

```r
ggplot(df, aes(x = monto)) + geom_density(fill = "orange", alpha = 0.6) + facet_wrap(~ ciudad)
```

## Paso 49: Recuento de transacciones por dia

```r
df %>% group_by(fecha = as.Date(fecha)) %>%
  summarise(n = n()) %>%
  ggplot(aes(x = fecha, y = n)) + geom_line()
```

## Paso 50: Gasto total diario

```r
df %>% group_by(fecha = as.Date(fecha)) %>%
  summarise(total = sum(monto)) %>%
  ggplot(aes(x = fecha, y = total)) + geom_line(color = "steelblue")
```

## Paso 51: Gasto total por edad_grupo

```r
df %>% group_by(edad_grupo) %>% summarise(total = sum(monto)) %>%
  ggplot(aes(x = edad_grupo, y = total)) + geom_col(fill = "navy")
```

## Paso 52: Agrupar por hora y categoria

```r
df %>% group_by(hora, categoria) %>% summarise(media = mean(monto)) %>%
  ggplot(aes(x = factor(hora), y = media, fill = categoria)) + geom_col(position = "dodge")
```

## Paso 53: Pie chart (opcional)

```r
df %>% count(categoria) %>%
  ggplot(aes(x = "", y = n, fill = categoria)) + geom_bar(stat = "identity", width = 1) + coord_polar("y")
```

## Paso 54: Exportar CSV limpio

```r
write_csv(df, "transacciones_limpio.csv")
```

## Paso 55: Ver nombres con mutate y case_when

```r
df <- df %>% mutate(segmento = case_when(
  edad < 30 ~ "Joven",
  edad >= 30 & edad < 50 ~ "Adulto",
  TRUE ~ "Senior"
))
```

## Paso 56: Promedio por segmento

```r
df %>% group_by(segmento) %>% summarise(prom = mean(monto))
```

## Paso 57: Grafico de barras por segmento

```r
ggplot(df, aes(x = segmento, fill = segmento)) + geom_bar()
```

## Paso 58: Analizar horas de mayor actividad

```r
df %>% count(hora) %>% ggplot(aes(x = hora, y = n)) + geom_col(fill = "darkred")
```

## Paso 59: Mediana por ciudad

```r
df %>% group_by(ciudad) %>% summarise(mediana = median(monto))
```

## Paso 60: Resumen final

```r
summary(df)
```
