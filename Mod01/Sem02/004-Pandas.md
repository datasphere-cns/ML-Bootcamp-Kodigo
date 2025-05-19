
# Ejemplo 4: Leer archivos desde un bucket de Amazon S3 con Pandas

En este ejemplo aprenderás a conectar tu entorno de Python con un bucket de Amazon S3 para **leer un archivo CSV directamente** y trabajar con él usando `pandas`.

---

## 🧰 Requisitos previos

Debes tener instalados los siguientes paquetes en tu entorno de Jupyter:

```bash
pip install pandas boto3 s3fs
```

---

## Llaves de acceso

Debes tener las siguientes credenciales:

```python
AWS_ACCESS_KEY_ID = 'TU_ACCESS_KEY'
AWS_SECRET_ACCESS_KEY = 'TU_SECRET_KEY'
```

⚠️ **Nunca compartas estas claves públicamente.**

---

## Paso 1: Leer archivo CSV desde S3

Supongamos que tu archivo se encuentra en el bucket `snow.workshop.198303` y se llama `products.csv`.

```python
import pandas as pd
import s3fs

# Reemplaza con tus llaves
aws_access_key_id = 'TU_ACCESS_KEY'
aws_secret_access_key = 'TU_SECRET_KEY'

# Configuración del sistema de archivos S3
fs = s3fs.S3FileSystem(key=aws_access_key_id, secret=aws_secret_access_key)

# Leer el archivo directamente desde S3
file_path = 's3://snow.workshop.198303/products.csv'
df = pd.read_csv(fs.open(file_path, mode='rb'))

print(df.head())
```

---

## Operaciones básicas con el DataFrame

### 1. Información general

```python
print(df.info())
```

### 2. Ordenar por nombre de producto

```python
df_sorted = df.sort_values('product_name')
print(df_sorted.head())
```

### 3. Buscar productos con cierta palabra

```python
df[df['product_name'].str.contains('tea', case=False, na=False)]
```

### 4. Agrupar por department_id

```python
df.groupby('department_id').size().reset_index(name='n_productos')
```

---

## Transformaciones

### Agregar columna con longitud del nombre del producto

```python
df['nombre_largo'] = df['product_name'].apply(lambda x: len(x))
```

### Clasificar productos como 'Corto' o 'Largo'

```python
def clasificar_nombre(nombre):
    return 'Largo' if len(nombre) > 20 else 'Corto'

df['clasificacion'] = df['product_name'].apply(clasificar_nombre)
```

---

## Visualizaciones básicas

```python
import matplotlib.pyplot as plt

# Gráfico de barras
df['clasificacion'].value_counts().plot(kind='bar', title='Clasificación de nombres')
plt.grid()
plt.show()

# Gráfico de pastel
df['department_id'].value_counts().plot(kind='pie', autopct='%1.1f%%', title='Distribución por departamento')
plt.ylabel('')
plt.show()

# Boxplot: longitud de nombres por departamento
df.boxplot(column='nombre_largo', by='department_id', figsize=(12, 6))
plt.title('Longitud de nombres por departamento')
plt.suptitle('')
plt.grid()
plt.show()
```

---
