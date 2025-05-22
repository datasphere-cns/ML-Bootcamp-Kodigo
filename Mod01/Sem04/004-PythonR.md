# Análisis de Correlaciones combinando Python y R

Este ejemplo demuestra cómo crear datos en Python, analizarlos en R y visualizar una matriz de correlaciones usando `ggcorrplot`.

## Requisitos

Instala los paquetes necesarios:

### En Python:
```bash
pip install rpy2 pandas numpy
```

### En R (dentro de la consola de R):
```r
install.packages("ggcorrplot")
install.packages("ggplot2")
```

---

## Script completo

```python
import pandas as pd
import numpy as np
import rpy2.robjects as robjects
from rpy2.robjects import pandas2ri

# Activar conversión entre pandas y R
pandas2ri.activate()

# Crear dataset simulado con datos numéricos de compras
np.random.seed(42)
data = {
    'monto_compra': np.random.normal(100, 25, 50),
    'frecuencia_semanal': np.random.poisson(3, 50),
    'edad_cliente': np.random.normal(35, 10, 50),
    'descuento_usado': np.random.normal(10, 5, 50)
}

df = pd.DataFrame(data)

# Pasar a R
robjects.globalenv["df_corr"] = pandas2ri.py2rpy(df)

# Código R para calcular y visualizar correlaciones
codigo_r = """
library(ggcorrplot)

# Calcular matriz de correlación
matriz <- cor(df_corr, use = "complete.obs")

# Graficar la matriz
ggcorrplot(matriz,
           method = "circle",
           type = "lower",
           lab = TRUE,
           title = "Matriz de Correlación")
"""

# Ejecutar código R desde Python
robjects.r(codigo_r)
```

---

## ¿Qué hace este código?

1. **Python** genera un DataFrame con 4 variables numéricas relevantes en un contexto de compras.
2. El DataFrame se transfiere a **R** como `df_corr`.
3. En **R**:
   - Se calcula la matriz de correlación con `cor()`.
   - Se visualiza con `ggcorrplot`.

---

## Resultado esperado

Una **gráfica de matriz de correlaciones** donde:
- Los valores cercanos a +1 o -1 indican correlación fuerte.
- Los valores cercanos a 0 indican poca o ninguna correlación.
- El método `"circle"` muestra la intensidad con círculos de distinto tamaño y color.

---

## Consejo adicional

Puedes cambiar `method = "circle"` por `"square"` o `"number"` para variar la visualización.

---

## Conclusión

Este flujo demuestra cómo:

- Simular y estructurar datos con Python,
- Usar el poder estadístico de R para análisis,
- Y crear visualizaciones avanzadas sin salir del mismo script.

La integración entre `pandas` y `ggcorrplot` vía `rpy2` permite un entorno mixto ideal para científicos de datos que quieren lo mejor de ambos lenguajes.
