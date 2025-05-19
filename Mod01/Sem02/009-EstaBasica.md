
# Conceptos Básicos de Probabilidad y Estadística con Pandas

En este archivo aprenderás a aplicar conceptos fundamentales de estadística usando un `DataFrame` sencillo en Python con `pandas`.

---

## Requisitos

Instala pandas si aún no lo tienes:

```bash
pip install pandas
```

---

## Paso 1: Crear un DataFrame de ejemplo

Supongamos que tenemos las calificaciones de 10 estudiantes en un examen:

```python
import pandas as pd

data = {
    'estudiante': ['Ana', 'Luis', 'Carlos', 'Laura', 'Sofía', 'Tomás', 'Valeria', 'Mario', 'Julia', 'José'],
    'nota': [85, 90, 78, 92, 88, 76, 95, 89, 84, 91]
}

df = pd.DataFrame(data)
print(df)
```

---

## Media (Promedio)

La **media** es el promedio aritmético: la suma de los valores dividida entre la cantidad total.

```python
media = df['nota'].mean()
print("Media:", media)
```

✅ Útil para obtener una medida central, aunque es sensible a valores extremos.

---

## Mediana

La **mediana** es el valor que se encuentra en el medio del conjunto ordenado.

```python
mediana = df['nota'].median()
print("Mediana:", mediana)
```

✅ No se ve afectada por valores extremos (outliers).

---

## Moda

La **moda** es el valor que más se repite.

```python
moda = df['nota'].mode()
print("Moda:", moda.values)
```

✅ Puede haber más de una moda.

---

## Desviación estándar

La **desviación estándar** mide la dispersión de los datos respecto a la media.

```python
desviacion = df['nota'].std()
print("Desviación estándar:", desviacion)
```

✅ Cuanto más alta, más dispersos están los datos.

---

## Varianza

La **varianza** es el cuadrado de la desviación estándar.

```python
varianza = df['nota'].var()
print("Varianza:", varianza)
```

---

## Cuartiles

Los **cuartiles** dividen los datos ordenados en 4 partes iguales.

```python
q1 = df['nota'].quantile(0.25)
q2 = df['nota'].quantile(0.50)  # Mediana
q3 = df['nota'].quantile(0.75)

print("Q1 (25%):", q1)
print("Q2 (50%):", q2)
print("Q3 (75%):", q3)
```

✅ Útiles para ver la distribución de los datos.

---

## Percentiles

Los **percentiles** indican el valor bajo el cual cae un porcentaje de observaciones.

```python
p10 = df['nota'].quantile(0.10)
p90 = df['nota'].quantile(0.90)

print("Percentil 10:", p10)
print("Percentil 90:", p90)
```

---

## Rango

El **rango** es la diferencia entre el valor máximo y el mínimo.

```python
rango = df['nota'].max() - df['nota'].min()
print("Rango:", rango)
```

---

## Resumen estadístico completo

```python
print(df['nota'].describe())
```

---

## ✅ Conclusión

| Concepto       | ¿Qué mide?                                       |
|----------------|--------------------------------------------------|
| Media          | Valor promedio de los datos                      |
| Mediana        | Valor central al ordenar los datos               |
| Moda           | Valor que más se repite                          |
| Varianza       | Dispersión respecto a la media (en cuadrado)     |
| Desviación Est.| Dispersión respecto a la media                   |
| Cuartiles      | División del conjunto en 4 partes iguales        |
| Percentiles    | Posición relativa de un valor en el conjunto     |
| Rango          | Diferencia entre máximo y mínimo                 |

Estos conceptos son clave para cualquier análisis exploratorio de datos, y te permitirán entender el comportamiento general de una variable cuantitativa.

