
# Ejemplo Avanzado: Álgebra Lineal con NumPy

En este ejemplo realizaremos operaciones fundamentales de **álgebra lineal** usando la biblioteca **NumPy**. Veremos cómo crear vectores y matrices, aplicar transformaciones, resolver sistemas de ecuaciones y más.

---

## Requisitos

Asegúrate de tener NumPy instalado:

```bash
pip install numpy
```

---

## 1. Vectores y matrices

```python
import numpy as np

# Vectores
v = np.array([2, 3])
w = np.array([5, 1])

# Matriz 2x2
A = np.array([[4, 1],
              [2, 2]])
```

---

## 2. Operaciones con vectores

```python
print("Suma:", v + w)
print("Resta:", v - w)
print("Producto escalar:", np.dot(v, w))
print("Norma del vector v:", np.linalg.norm(v))
```

---

## 3. Operaciones con matrices

```python
B = np.array([[1, 2],
              [3, 4]])

print("Multiplicación de matrices:
", np.dot(A, B))
print("Transpuesta de A:
", A.T)
```

---

## 4. Inversa y determinante

```python
# Determinante
print("Determinante de A:", np.linalg.det(A))

# Inversa (si existe)
if np.linalg.det(A) != 0:
    A_inv = np.linalg.inv(A)
    print("Inversa de A:
", A_inv)
else:
    print("La matriz A no es invertible.")
```

---

## 5. Resolver sistema de ecuaciones lineales

Queremos resolver:

\[
Ax = b
\]

Donde:

```python
A = np.array([[3, 1],
              [1, 2]])
b = np.array([9, 8])
```

```python
x = np.linalg.solve(A, b)
print("Solución del sistema Ax = b:", x)
```

---

## 6. Eigenvalores y Eigenvectores

Los eigenvalores y eigenvectores son fundamentales en reducción de dimensiones (como PCA) y estabilidad de sistemas dinámicos.

```python
eig_vals, eig_vecs = np.linalg.eig(A)
print("Eigenvalores:", eig_vals)
print("Eigenvectores:
", eig_vecs)
```

---

## Aplicación práctica: Rotación de un vector en 2D

```python
# Ángulo de rotación
theta = np.radians(45)

# Matriz de rotación 2D
R = np.array([
    [np.cos(theta), -np.sin(theta)],
    [np.sin(theta),  np.cos(theta)]
])

# Vector original
v = np.array([1, 0])

# Vector rotado
v_rotado = R @ v
print("Vector rotado 45°:", v_rotado)
```

---

## Conclusión

Estas operaciones te permiten resolver una gran variedad de problemas en ciencia de datos, ingeniería y machine learning. NumPy proporciona una interfaz rápida y eficiente para trabajar con álgebra lineal, transformaciones y optimizaciones.

