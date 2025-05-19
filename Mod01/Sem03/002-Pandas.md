
# Ejemplo 2: Operaciones con DataFrames en Pandas

En este ejemplo, crearemos un `DataFrame` manualmente con información simulada de **transacciones con tarjetas de crédito**. Exploraremos operaciones clave de manipulación, análisis y visualización usando `pandas` y `matplotlib`.

---

## Paso 1: Crear el DataFrame

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Crear un DataFrame con datos simulados
data = {
    'transaction_id': range(1, 16),
    'cardholder': ['Alice', 'Bob', 'Charlie', 'Alice', 'Eve', 'Frank', 'Alice', 'Bob', 'Eve', 'Charlie', 'Frank', 'Alice', 'Eve', 'Bob', 'Charlie'],
    'amount': [120.5, 250.0, 89.99, 145.0, 320.0, 87.0, 99.5, 180.0, 275.0, 110.0, 60.5, 210.0, 150.0, 300.0, 130.0],
    'category': ['Food', 'Electronics', 'Travel', 'Food', 'Clothing', 'Food', 'Entertainment', 'Clothing', 'Electronics', 'Travel', 'Food', 'Clothing', 'Food', 'Electronics', 'Travel'],
    'transaction_date': pd.date_range(start='2024-01-01', periods=15, freq='D'),
    'successful': [True, True, False, True, True, False, True, True, False, True, True, True, True, False, True]
}

df = pd.DataFrame(data)
print(df)
```

---

## Paso 2: Verificación de tipos de datos

```python
print(df.dtypes)
```

---

## Paso 3: Conteo de transacciones por categoría

```python
print(df['category'].value_counts())
```

---

## Paso 4: Ordenar por monto de transacción

```python
df_sorted = df.sort_values(by='amount', ascending=False)
print(df_sorted)
```

---

## Paso 5: Partir el DataFrame por columnas

```python
# Solo columnas numéricas
df_numeric = df[['amount', 'transaction_id']]
print(df_numeric)
```

---

## Paso 6: Partir el DataFrame por filas

```python
df_part1 = df.iloc[:8]
df_part2 = df.iloc[8:]
```

---

## Paso 7: Unir los DataFrames nuevamente

```python
df_reunido = pd.concat([df_part1, df_part2], ignore_index=True)
```

---

## Paso 8: Editar una columna (aumentar 10% a todas las transacciones de la categoría Food)

```python
df.loc[df['category'] == 'Food', 'amount'] *= 1.1
```

---

## Paso 9: Agrupación por categoría y suma de montos

```python
resumen_categoria = df.groupby('category')['amount'].sum().reset_index()
print(resumen_categoria)
```

---

## Paso 10: Gráfica de línea – Monto total por día

```python
df_fecha = df.groupby('transaction_date')['amount'].sum()
df_fecha.plot(kind='line', title='Monto total por día')
plt.xlabel('Fecha')
plt.ylabel('Monto')
plt.grid(True)
plt.show()
```

---

## Paso 11: Gráfica de barras – Total gastado por categoría

```python
resumen_categoria.plot(kind='bar', x='category', y='amount', legend=False, title='Total por categoría')
plt.ylabel('Monto')
plt.grid(axis='y')
plt.show()
```

---

## Paso 12: Gráfica de pastel – Proporción de transacciones por categoría

```python
df['category'].value_counts().plot(kind='pie', autopct='%1.1f%%', title='Distribución de categorías')
plt.ylabel('')
plt.show()
```

---

## Paso 13: Guardar un nuevo DataFrame

```python
df_resumen = df[['cardholder', 'amount', 'category']]
df_resumen.to_csv('resumen_transacciones.csv', index=False)
```

---

Este ejemplo muestra cómo Pandas puede ayudarte a construir un flujo de trabajo completo: desde la creación de datos, su manipulación y análisis, hasta la generación de gráficos útiles para análisis de comportamiento.


---

## ¿Qué es `.iloc` y `.loc` en Pandas?

Pandas proporciona dos formas muy comunes de seleccionar datos: **`iloc`** y **`loc`**. Es esencial entender la diferencia.

---

### `.iloc[]` – Selección por posición

`.iloc` se usa para acceder a filas y columnas **por su posición numérica** (como una matriz).

#### Sintaxis:
```python
df.iloc[filas, columnas]
```

#### Ejemplos:
```python
df.iloc[0]           # Primera fila
df.iloc[0:2]         # Primeras dos filas
df.iloc[0, 1]        # Fila 0, columna 1
df.iloc[-1]          # Última fila
df.iloc[:, 0:2]      # Todas las filas, dos primeras columnas
```

---

### `.loc[]` – Selección por etiqueta

`.loc` se usa para acceder a filas y columnas **por nombre de índice o etiqueta de columna**.

#### Sintaxis:
```python
df.loc[fila, columna]
```

#### Ejemplos:
```python
df.loc[0, 'amount']          # Monto de la transacción con índice 0
df.loc[df['category'] == 'Food']  # Todas las transacciones de tipo 'Food'
df.loc[:, ['cardholder', 'amount']]  # Todas las filas, solo dos columnas
```

---

### 🆚 Comparación rápida

| Atributo | `.iloc[]`                          | `.loc[]`                            |
|----------|------------------------------------|-------------------------------------|
| Basado en | Posiciones numéricas (enteros)    | Nombres de etiquetas (índices/columnas) |
| Ejemplo | `df.iloc[0, 1]`                     | `df.loc[0, 'amount']`               |
| Uso común | Indexación estilo matriz           | Filtrado por condiciones o nombres  |

---

