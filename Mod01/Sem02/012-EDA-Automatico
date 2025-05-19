
# Analisis Exploratorio de Datos Automatizado - EnergyDataSet

En este documento usaremos 3 librerias para generar EDA automatizado sobre el dataset `EnergyDataSet.csv`.

---

## Paso 1: Instalar las librerias necesarias

```bash
pip install ydata-profiling sweetviz dtale
```

---

## Parte 1: Usar ydata-profiling (antes llamado pandas-profiling)

```python
import pandas as pd
from ydata_profiling import ProfileReport

# Cargar dataset
df = pd.read_csv("EnergyDataSet.csv")

# Crear el reporte
profile = ProfileReport(df, title="Reporte EDA - EnergyDataSet", explorative=True)

# Mostrar en el notebook
profile.to_notebook_iframe()

# O exportar a HTML
profile.to_file("reporte_ydata_profiling.html")
```

Este reporte incluye:
- Estadisticas generales
- Correlaciones
- Valores faltantes
- Alertas
- Distribuciones individuales

---

## Parte 2: Usar Sweetviz

```python
import sweetviz as sv

# Crear reporte
reporte = sv.analyze(df)

# Mostrar HTML
reporte.show_html("reporte_sweetviz.html")
```

Este reporte visual contiene:
- Comparacion entre variables
- Grafico de balance de clases
- Distribuciones detalladas
- Relacion entre variables

---

## Parte 3: Usar D-Tale

```python
import dtale

# Lanzar interfaz interactiva
dtale.show(df).open_browser()
```

D-Tale proporciona:
- Edicion de datos en tabla tipo hoja de calculo
- Filtros y agrupaciones
- Estadisticas por columna
- Edicion y exportacion desde interfaz web

---

## Conclusiones

Cada una de estas herramientas te permite realizar un EDA completo de forma automatica o visual sin necesidad de escribir decenas de lineas de codigo:

| Herramienta      | Ideal para                                 |
|------------------|---------------------------------------------|
| ydata-profiling  | Informes rapidos y exportables              |
| Sweetviz         | Analisis visual llamativo                   |
| D-Tale           | Exploracion interactiva en tiempo real      |

Puedes combinarlas o elegir la que mejor se adapte a tu flujo de trabajo.

