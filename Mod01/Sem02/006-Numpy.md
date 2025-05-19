
# Introducción a NumPy en Python

## ¿Qué es NumPy?

**NumPy** (Numerical Python) es una biblioteca fundamental para la computación científica en Python. Proporciona soporte para:

- Arreglos multidimensionales (ndarray)
- Operaciones vectorizadas eficientes
- Funciones matemáticas y estadísticas
- Álgebra lineal y transformadas
- Generación de números aleatorios

---

## 🎯 ¿Para qué se usa NumPy?

NumPy se usa en tareas donde se necesita **alto rendimiento numérico**, como:

- Análisis numérico y computación científica
- Álgebra lineal y manipulación de matrices
- Simulaciones físicas o modelos matemáticos
- Machine Learning (como backend de bibliotecas como TensorFlow y PyTorch)

---

## 🆚 ¿En qué se diferencia de Pandas?

| Característica        | NumPy                            | Pandas                             |
|-----------------------|----------------------------------|------------------------------------|
| Estructura principal  | Arreglo (ndarray)                | Tabla (DataFrame, Series)         |
| Ideal para            | Cálculos numéricos, vectores     | Datos tabulares (filas y columnas)|
| Rendimiento           | Más rápido en operaciones numéricas | Más completo en manipulación de datos |
| Indexación            | Por posición (índices enteros)   | Por etiquetas o posición          |

---

## Beneficios de NumPy

- Velocidad: mucho más rápido que las listas de Python nativas.
- Eficiencia de memoria.
- Soporte para operaciones vectorizadas (sin loops).
- Integración con bibliotecas científicas como SciPy, Matplotlib, scikit-learn.

---

## Primeros pasos con NumPy

### Instalar la biblioteca (si no está instalada)

```bash
pip install numpy
```

### Importar la biblioteca

```python
import numpy as np
```

---

## Crear arreglos (arrays)

```python
# Arreglo unidimensional
a = np.array([1, 2, 3])
print(a)

# Arreglo bidimensional
b = np.array([[1, 2], [3, 4]])
print(b)
```

---

## Propiedades básicas

```python
print(a.shape)      # (3,)
print(b.shape)      # (2, 2)
print(a.dtype)      # int64 (puede variar)
print(b.ndim)       # 2
```

---

## Funciones útiles para crear arreglos

```python
np.zeros((2, 3))         # Matriz 2x3 de ceros
np.ones((3, 3))          # Matriz 3x3 de unos
np.eye(4)                # Matriz identidad 4x4
np.arange(0, 10, 2)      # [0 2 4 6 8]
np.linspace(0, 1, 5)     # 5 números espaciados entre 0 y 1
```

---

## Operaciones matemáticas elementales

```python
x = np.array([1, 2, 3])
y = np.array([4, 5, 6])

print(x + y)
print(x * y)
print(np.dot(x, y))   # Producto escalar
print(np.mean(x))     # Promedio
print(np.std(x))      # Desviación estándar
```

---

## Indexado y slicing

```python
z = np.array([10, 20, 30, 40, 50])
print(z[0])         # 10
print(z[1:4])       # [20 30 40]
z[0] = 99           # Asignación
```

---

## Operaciones con matrices

```python
M = np.array([[1, 2], [3, 4]])
print(np.transpose(M))   # Transpuesta
print(np.linalg.inv(M))  # Inversa (si existe)
```

---

## Números aleatorios

```python
np.random.seed(0)
print(np.random.rand(3))         # 3 números aleatorios uniformes
print(np.random.randn(2, 2))     # Distribución normal
```

---

## Conclusión

NumPy es una herramienta poderosa para trabajar con arreglos y operaciones numéricas. A diferencia de pandas, **no se enfoca en datos tabulares, sino en cálculos vectorizados y matrices**. Es la base sobre la que se construyen muchas otras bibliotecas de ciencia de datos y machine learning en Python.

