
# Ejemplo 5: Lectura de datos desde MySQL con Pandas

En este ejemplo aprenderás a conectarte a una base de datos pública de **MySQL** usando `pandas` y `pymysql`, y consultar la tabla `family` de la base **Rfam**, una base de datos sobre familias de ARN no codificante.

---

## Fuente de datos

La base de datos está documentada en:

🔗 [https://www.ebi.ac.uk/ebisearch/metadata.ebi?db=rfam](https://www.ebi.ac.uk/ebisearch/metadata.ebi?db=rfam)

---

## Dependencias

Asegúrate de tener instaladas las siguientes bibliotecas:

```bash
pip install pandas pymysql sqlalchemy
```

---

## Conectarse a la base de datos y consultar la tabla `family`

```python
import pandas as pd
import pymysql
from sqlalchemy import create_engine

# Conectarse a la base de datos
engine = create_engine("mysql+pymysql://rfamro@mysql-rfam-public.ebi.ac.uk:4497/Rfam")

# Leer solo los primeros 1000 registros de la tabla 'family'
query = "SELECT * FROM family LIMIT 1000"
df = pd.read_sql(query, engine)

# Ver las primeras filas
print(df.head())
```

---

## ¿Qué contiene esta tabla?

La tabla `family` contiene información sobre distintas familias de ARN. Algunos campos clave son:

- `rfam_acc`: código de acceso
- `rfam_id`: identificador de la familia
- `description`: descripción de la familia
- `author`: autor de la anotación
- `num_seed`: número de secuencias en el conjunto "seed"
- `num_full`: número total de secuencias
- `type`: tipo de familia
- `created` y `updated`: fechas de creación y última actualización

---

## Ejemplos de análisis

### 1. Revisar tipos de datos y nulos

```python
print(df.dtypes)
print(df.isnull().sum())
```

---

### 2. Contar cuántas familias hay por tipo

```python
df['type'].value_counts()
```

---

### 3. Ordenar por número total de secuencias (num_full)

```python
df_sorted = df.sort_values('num_full', ascending=False)
print(df_sorted[['rfam_id', 'num_full']].head())
```

---

### 4. Agregar columna con ratio entre secuencias seed y totales

```python
df['ratio_seed_full'] = df['num_seed'] / df['num_full']
```

---

### 5. Gráfico de barras: top 10 familias con más secuencias

```python
import matplotlib.pyplot as plt

top_10 = df.nlargest(10, 'num_full')
top_10.plot(kind='bar', x='rfam_id', y='num_full', title='Top 10 familias con más secuencias')
plt.ylabel('Número total de secuencias')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()
```

---
