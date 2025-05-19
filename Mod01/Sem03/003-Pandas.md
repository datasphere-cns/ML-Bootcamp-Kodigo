
# Ejemplo 3: Lectura de archivos CSV y análisis de productos

En este ejemplo vamos a trabajar con un archivo real: **products.csv**, que contiene información sobre productos, sus pasillos (aisles) y departamentos.

---

## Paso 1: Descarga del archivo

Descarga el archivo `products.csv` desde el siguiente enlace:

🔗 [Descargar products.csv](https://drive.google.com/drive/folders/1veDv3nrXkbVRM2T3N7hFIJhfe4j3jRwY?usp=sharing)

Luego, súbelo a tu entorno de Jupyter Notebook.

---

## Paso 2: Leer el archivo en un DataFrame

```python
import pandas as pd

# Leer archivo CSV
df = pd.read_csv('products.csv')
print(df.head())
```

---

## Paso 3: Información general del DataFrame

```python
print(df.info())
print(df.describe(include='all'))
```

---

## Paso 4: Ordenar los productos por nombre

```python
df_sorted = df.sort_values(by='product_name')
print(df_sorted.head())
```

---

## Paso 5: Buscar productos que contienen una palabra clave

```python
# Buscar productos que contienen "chocolate"
df_chocolate = df[df['product_name'].str.contains('chocolate', case=False, na=False)]
print(df_chocolate.head())
```

---

## Paso 6: Agrupar productos por departamento

```python
productos_por_departamento = df.groupby('department_id').size().reset_index(name='cantidad_productos')
print(productos_por_departamento)
```

---

## Paso 7: Transformar columnas – Normalizar nombres a minúsculas

```python
df['product_name_normalized'] = df['product_name'].str.lower()
```

---

## Paso 8: Crear y aplicar una función personalizada

Vamos a definir una función que clasifica los productos en "Largo" o "Corto" según la longitud de su nombre.

```python
def clasificar_nombre(nombre):
    return 'Largo' if len(nombre) > 20 else 'Corto'

df['nombre_clasificado'] = df['product_name'].apply(clasificar_nombre)
print(df[['product_name', 'nombre_clasificado']].head())
```

---

## Paso 9: Gráfica de barras – Productos por categoría (clasificación de nombre)

```python
import matplotlib.pyplot as plt

df['nombre_clasificado'].value_counts().plot(kind='bar', title='Clasificación de nombres de producto')
plt.xlabel('Tipo de nombre')
plt.ylabel('Cantidad')
plt.grid(True)
plt.show()
```

---

## Paso 10: Gráfica de pastel – Distribución por departamento

```python
productos_por_departamento.set_index('department_id').plot(kind='pie', y='cantidad_productos', autopct='%1.1f%%', legend=False)
plt.title('Distribución de productos por departamento')
plt.ylabel('')
plt.show()
```

---

## Paso 11: Boxplot – Longitud de nombres por departamento

Primero, creamos una nueva columna con la longitud de cada nombre de producto.

```python
df['longitud_nombre'] = df['product_name'].apply(len)

# Boxplot de la longitud de nombres por departamento
df.boxplot(column='longitud_nombre', by='department_id', figsize=(12,6))
plt.title('Distribución de longitud de nombre por departamento')
plt.suptitle('')
plt.xlabel('Departamento')
plt.ylabel('Longitud del nombre')
plt.grid(True)
plt.show()
```

---

