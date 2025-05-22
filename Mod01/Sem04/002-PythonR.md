# Ejecutar código R desde Python con `rpy2`

Este documento explica cómo integrar código R en tus scripts de Python usando la librería `rpy2`, incluyendo cómo ejecutar código directamente y cómo intercambiar datos entre ambos lenguajes.

## Requisitos previos

Antes de comenzar:

- Asegúrate de tener **Python** y **R** instalados en tu sistema.
- Verifica que R esté disponible desde la terminal con:

```bash
R --version
```

- Instala la librería `rpy2` con:

```bash
pip install rpy2
```

## Ejecutar código R directamente desde Python

Una vez instalado `rpy2`, puedes usar `robjects.r()` para ejecutar cualquier comando R como string desde Python.

### Ejemplo: generar números aleatorios en R

```python
import rpy2.robjects as robjects

# Ejecutar una instrucción R desde Python
robjects.r('x <- rnorm(5)')   # Genera 5 números aleatorios con distribución normal
robjects.r('print(x)')        # Imprime el vector generado
```

Esto funciona como si escribieras directamente en una consola R, pero dentro de tu script Python.

## Pasar datos de Python a R y obtener resultados

Además de ejecutar instrucciones, puedes enviar datos desde Python hacia R, utilizarlos en funciones estadísticas y recuperar los resultados.

### Ejemplo: calcular la media en R de una lista Python

```python
import rpy2.robjects as robjects

# Lista en Python
valores_py = [5, 10, 15, 20, 25]

# Convertir a vector R
vector_r = robjects.FloatVector(valores_py)

# Asignar el vector a una variable en R llamada 'valores'
robjects.r.assign("valores", vector_r)

# Ejecutar código R que usa la variable
robjects.r('media <- mean(valores)')

# Obtener el valor calculado en R desde Python
resultado = robjects.r('media')
print("Media calculada en R:", resultado[0])
```

### ¿Qué ocurre en este ejemplo?

- Se crea un vector en Python.
- Se convierte y se envía a R.
- R calcula la media con su propia función `mean()`.
- El resultado es devuelto a Python como un objeto accesible.

## Conclusión

Usar `rpy2` te permite:

- Integrar funciones estadísticas o visuales de R en pipelines Python.
- Automatizar análisis complejos escritos en R.
- Enviar y recibir datos de forma transparente entre ambos lenguajes.

Esta técnica es ideal cuando trabajas en entornos mixtos o cuando quieres aprovechar lo mejor de R sin salir del ecosistema Python.
