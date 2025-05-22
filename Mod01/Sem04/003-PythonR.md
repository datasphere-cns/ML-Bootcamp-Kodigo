# Visualización con R desde Python: Compras con tarjeta de crédito

Este ejemplo muestra cómo construir un dataset en Python, transferirlo a R, y generar una visualización con `ggplot2` usando la librería `rpy2`.

## Requisitos

Asegúrate de tener instalado:

- R (`R --version`)
- Python (`python --version`)
- `rpy2`: instalar con `pip install rpy2`
- Los siguientes paquetes de R: `ggplot2`, `dplyr`

Puedes instalarlos desde una terminal R:

```r
install.packages("ggplot2")
install.packages("dplyr")
```

---

## Script completo en Python

```python
import pandas as pd
import rpy2.robjects as robjects
from rpy2.robjects import pandas2ri

# Activar conversión automática entre pandas DataFrame y R data.frame
pandas2ri.activate()

# Crear dataset de compras con tarjeta
data = {
    'categoria': ['Supermercado', 'Gasolina', 'Restaurante', 'Restaurante', 'Supermercado', 'Farmacia'],
    'monto': [45.60, 30.10, 60.00, 22.50, 90.00, 18.25],
    'fecha': ['2025-05-01', '2025-05-02', '2025-05-02', '2025-05-03', '2025-05-03', '2025-05-04']
}

df = pd.DataFrame(data)

# Pasar DataFrame de pandas a R
robjects.globalenv["df_compras"] = pandas2ri.py2rpy(df)

# Código R para graficar usando ggplot2
codigo_r = """
library(ggplot2)
library(dplyr)

# Asegurar que fecha esté como Date
df_compras$fecha <- as.Date(df_compras$fecha)

# Sumar montos por categoría
df_summary <- df_compras %>%
  group_by(categoria) %>%
  summarise(total = sum(monto))

# Gráfica de barras
ggplot(df_summary, aes(x = categoria, y = total, fill = categoria)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Total de Compras por Categoría", x = "Categoría", y = "Monto Total ($)")
"""

# Ejecutar el código R desde Python
robjects.r(codigo_r)
```

---

## ¿Qué hace este código?

- Define un DataFrame de compras con Python (pandas)
- Lo convierte automáticamente en un `data.frame` de R
- Agrupa por categoría y suma montos con `dplyr`
- Grafica los totales por categoría con `ggplot2`
- La ventana gráfica de R se abrirá automáticamente si estás en un entorno local

---

## Sugerencia

Si estás usando Jupyter Notebook o VS Code con soporte gráfico, asegúrate de que tu entorno permita la visualización de gráficos generados por R.

---

## Conclusión

Con `rpy2` puedes:
- Generar y procesar datos en Python
- Aprovechar el poder visual y estadístico de R
- Integrar análisis y visualización en un mismo flujo de trabajo mixto
