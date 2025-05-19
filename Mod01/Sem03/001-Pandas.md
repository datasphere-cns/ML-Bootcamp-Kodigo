# Introducción a Pandas en Python
## Instructor: Nelson Zepeda
### Kodigo.org

## ¿Qué es Pandas?

**Pandas** es una biblioteca de Python especializada en el análisis y manipulación de datos. Su nombre proviene de *Panel Data*, un término estadístico que describe conjuntos de datos multidimensionales.

Fue diseñada para trabajar con **estructuras de datos tabulares** (similares a hojas de cálculo o tablas SQL) y ofrece potentes herramientas para **limpiar, explorar, transformar, y analizar** datos con facilidad.

---

## ¿Por qué usar Pandas?

Pandas es una herramienta **esencial** para cualquier persona que trabaje con datos debido a sus múltiples ventajas:

- ✅ Lectura y escritura de archivos en formatos comunes (CSV, Excel, SQL, JSON, Parquet).
- ✅ Operaciones rápidas y expresivas sobre datos tabulares.
- ✅ Limpieza, filtrado, transformación y resumen de grandes volúmenes de datos.
- ✅ Preparación eficiente de datos para Machine Learning o visualización.
- ✅ Comunidad activa y documentación robusta.

---

## Estructuras clave en Pandas

Pandas trabaja principalmente con dos estructuras:

### 1. `Series`:  
Un arreglo unidimensional etiquetado.

```python
import pandas as pd

s = pd.Series([10, 20, 30])
print(s)
