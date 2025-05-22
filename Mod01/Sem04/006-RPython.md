# Ejecutar código Python desde R con `reticulate`

Este documento muestra cómo puedes ejecutar código Python dentro de R usando el paquete `reticulate`. Combinamos la capacidad de manipulación de datos de `pandas` con la estructura y visualización de R.

---

## Requisitos

Instalar el paquete `reticulate` desde R:

```r
install.packages("reticulate")
```

También debes tener Python instalado y asegurarte de que `pandas` esté disponible:

```bash
pip install pandas
```

Puedes verificar qué versión de Python usa R con:

```r
library(reticulate)
py_config()
```

---

## Ejemplo completo: análisis con pandas desde R

```r
# Cargar reticulate
library(reticulate)

# Crear un data.frame en R
df_r <- data.frame(
  monto = c(100, 150, 120, 130, 110),
  descuento = c(5, 10, 7, 8, 6),
  visitas = c(2, 3, 4, 1, 2)
)

# Enviar el data.frame a Python
py$df <- df_r

# Ejecutar código Python desde R
py_run_string("
import pandas as pd
df = pd.DataFrame(df)
resumen = df.describe()
")

# Ver resultado en R
py$resumen
```

---

## ¿Qué hace este código?

1. Se define un `data.frame` R (`df_r`).
2. Se transfiere a Python como `df` con `py$df <- df_r`.
3. Se ejecuta un bloque de Python con `py_run_string()`.
4. Python usa `pandas.describe()` para resumir las columnas.
5. El resultado (`resumen`) es devuelto a R como `py$resumen`.

---

## Resultado esperado

Un resumen estadístico estilo `pandas.describe()` con:

- count
- mean
- std
- min
- 25%, 50%, 75%
- max

de las columnas numéricas.

---

## Extensiones posibles

- Usar `sklearn` para modelado desde R
- Hacer limpieza avanzada con `pandas`
- Llamar funciones Python almacenadas en archivos `.py`
- Visualizar con `matplotlib` y mostrar en RStudio Viewer

---

## Conclusión

El paquete `reticulate` permite usar la potencia de Python desde R:

- Integración sin fricciones con objetos `pandas`, `numpy` y más
- Permite construir soluciones mixtas altamente productivas
- Ideal para proyectos donde se combinan visualización estadística (R) y manipulación moderna (Python)
