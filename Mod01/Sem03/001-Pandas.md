# Kodigo.org
## Autor: Nelson Zepeda
# Introducción a Pandas en Python

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
```

### 2. `DataFrame`:  
Una tabla bidimensional con filas y columnas etiquetadas.

```python
data = {
    'Nombre': ['Ana', 'Luis', 'Carlos'],
    'Edad': [23, 35, 29]
}

df = pd.DataFrame(data)
print(df)
```

---

## ¿Qué puedes hacer con Pandas?

- **Leer archivos**: `read_csv`, `read_excel`, `read_sql`, `read_json`, etc.
- **Explorar datos**: `head()`, `info()`, `describe()`
- **Filtrar y seleccionar**: `loc[]`, `iloc[]`, condiciones booleanas
- **Limpiar datos**: eliminar nulos, convertir tipos, reemplazar valores
- **Transformar columnas**: funciones lambda, operaciones vectorizadas
- **Agrupar y resumir**: `groupby()`, `pivot_table()`
- **Unir datasets**: `merge()`, `concat()`
- **Guardar resultados**: `to_csv()`, `to_excel()`, `to_sql()`

---

## ¿Y si tengo Big Data?

Pandas **no está diseñado para datos que superan la memoria RAM** disponible, pero:

### ✅ Puedes usar pandas si:
- Tus datos **caben en memoria (RAM)**.
- Trabajas con **muestras representativas** de un dataset grande.
- Procesas datos por **lotes pequeños o segmentados**.

### ❌ Limitaciones con Big Data:
- No es paralelo ni distribuido por defecto.
- Se vuelve ineficiente o falla con datasets muy grandes.

### 🔁 Alternativas para Big Data:
- **Dask**: divide el trabajo en múltiples núcleos, mantiene la sintaxis de pandas.
- **PySpark**: para procesamiento distribuido sobre clústeres grandes.
- **Vaex**: ideal para datasets grandes, usando lectura diferida (lazy evaluation).

---

## Ejemplo básico de análisis con Pandas

Supongamos que tienes un archivo CSV llamado `products.csv` con esta estructura:

```csv
product_id,product_name,aisle_id,department_id
1,Chocolate Sandwich Cookies,61,19
2,All-Seasons Salt,104,13
3,Robust Golden Unsweetened Oolong Tea,94,7
```

### Leer el archivo:

```python
import pandas as pd

df = pd.read_csv('products.csv')
```

### Ver los primeros registros:

```python
print(df.head())
```

### Consultar cuántos productos hay por departamento:

```python
print(df['department_id'].value_counts())
```

---

## Beneficios clave de usar Pandas

| Beneficio                 | Descripción                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| Productividad             | Permite hacer análisis complejos en pocas líneas de código.                |
| Flexibilidad              | Soporta muchos formatos de entrada y salida de datos.                      |
| Compatibilidad            | Se integra con scikit-learn, matplotlib, seaborn, numpy y SQLAlchemy.      |
| Curva de aprendizaje baja| Su sintaxis es legible y se parece mucho al trabajo con hojas de cálculo.  |

---

## Próximos pasos

En el siguiente ejercicio, empezaremos a trabajar **directamente con el archivo `products.csv`** y realizaremos tareas prácticas de inspección, filtrado, limpieza y agrupación para entender cómo Pandas facilita el análisis de datos reales.
