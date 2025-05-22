# Limpiar datos en Python y graficar en R

Este ejemplo muestra cómo realizar limpieza de datos usando `pandas` en Python desde R, y luego graficar el resultado con `ggplot2`.

```r
# Cargar librerías
library(reticulate)
library(ggplot2)

# Dataset en R
df <- data.frame(
  categoria = c("A", "B", "C", "A", "B", NA, "C", "B", "A", "C"),
  monto = c(100, 200, 150, 120, 180, 250, NA, 300, 90, 160)
)

# Enviar a Python
py$df <- df

# Limpiar datos en Python (quitar NAs y agrupar)
py_run_string("
import pandas as pd

# Eliminar filas con datos faltantes
df = df.dropna()

# Agrupar por categoría y sumar montos
df = df.groupby('categoria', as_index=False)['monto'].sum()
")

# Recuperar los datos limpios en R
df_limpio <- py$df

# Graficar con ggplot2
ggplot(df_limpio, aes(x = categoria, y = monto, fill = categoria)) +
  geom_bar(stat = 'identity') +
  theme_minimal() +
  labs(title = 'Total de Montos por Categoría (post-limpieza Python)',
       x = 'Categoría', y = 'Monto Total')
```

---

### ¿Qué hicimos?

- Python (`pandas`) limpió los datos: eliminó filas con `NA` y resumió por grupo.
- Luego, pasamos el resultado de vuelta a R.
- Finalmente, usamos `ggplot2` para visualizar.

---

### Ideas adicionales

- Usar `numpy` o `sklearn.preprocessing` para escalar variables antes de graficar.
- Aplicar `pandas.qcut()` para binning y luego graficar histogramas en R.
- Generar nuevos features o columnas en Python y visualizarlas con `facet_wrap()` en R.

---

## Conclusión

Este enfoque te permite:

- Automatizar limpieza o transformación con la versatilidad de Python
- Usar las poderosas capacidades gráficas de R
- Mantener un flujo limpio, reproducible y bien documentado

