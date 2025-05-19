
# Distribuciones de Probabilidad: Conceptos y Aplicaciones

La probabilidad nos permite modelar la incertidumbre. Una distribucion de probabilidad describe como se distribuyen los valores posibles de una variable aleatoria.

---

## Que es una distribucion de probabilidad

Una distribucion de probabilidad es una funcion matematica que indica la probabilidad de ocurrencia de cada valor posible de una variable aleatoria.

Hay dos grandes tipos:

- Distribuciones discretas: valores contables (como lanzar un dado).
- Distribuciones continuas: valores en un rango continuo (como alturas o tiempos).

---

## Distribuciones Discretas

### 1. Distribucion Bernoulli

- Descripcion: Solo dos posibles resultados: exito (1) o fracaso (0).
- Parametro: p = probabilidad de exito.
- Ejemplo: Lanzar una moneda justa: cara = 1, cruz = 0.

```python
from scipy.stats import bernoulli
import matplotlib.pyplot as plt

p = 0.7
x = [0, 1]
y = bernoulli.pmf(x, p)

plt.bar(x, y)
plt.title("Distribucion Bernoulli (p=0.7)")
plt.xticks(x)
plt.ylabel("Probabilidad")
plt.show()
```

Usos: Modelar resultados binarios (aprobado/reprobado, clic/no clic)

---

### 2. Distribucion Binomial

- Descripcion: Numero de exitos en n pruebas independientes con probabilidad p.
- Ejemplo: Numero de caras al lanzar una moneda 10 veces.

```python
from scipy.stats import binom

n, p = 10, 0.5
x = range(0, n+1)
y = binom.pmf(x, n, p)

plt.bar(x, y)
plt.title("Distribucion Binomial (n=10, p=0.5)")
plt.xlabel("Exitos")
plt.ylabel("Probabilidad")
plt.show()
```

Usos: Numero de clics, conversiones, errores en paquetes de datos

---

### 3. Distribucion Poisson

- Descripcion: Numero de eventos que ocurren en un intervalo fijo, si ocurren a una tasa constante.
- Parametro: lambda = tasa de ocurrencia.
- Ejemplo: Numero de llamadas a un call center por minuto.

```python
from scipy.stats import poisson

lam = 3
x = range(0, 10)
y = poisson.pmf(x, lam)

plt.bar(x, y)
plt.title("Distribucion Poisson (lambda=3)")
plt.xlabel("Eventos")
plt.ylabel("Probabilidad")
plt.show()
```

Usos: Modelar llegadas, fallos, llamadas, visitas web

---

## Distribuciones Continuas

### 4. Distribucion Normal (Gaussiana)

- Descripcion: La famosa curva de campana. La mayoria de los valores estan cerca de la media.
- Parametros: media (mu) y desviacion estandar (sigma).

```python
from scipy.stats import norm
import numpy as np

mu, sigma = 0, 1
x = np.linspace(-4, 4, 100)
y = norm.pdf(x, mu, sigma)

plt.plot(x, y)
plt.title("Distribucion Normal (mu=0, sigma=1)")
plt.xlabel("Valor")
plt.ylabel("Densidad de probabilidad")
plt.grid()
plt.show()
```

Usos: Modelar alturas, calificaciones, rendimientos financieros

---

### 5. Distribucion Exponencial

- Descripcion: Tiempo entre eventos en un proceso de Poisson.
- Parametro: lambda = tasa de ocurrencia.

```python
from scipy.stats import expon

x = np.linspace(0, 10, 100)
y = expon.pdf(x, scale=1)

plt.plot(x, y)
plt.title("Distribucion Exponencial")
plt.xlabel("Tiempo entre eventos")
plt.ylabel("Densidad")
plt.grid()
plt.show()
```

Usos: Tiempo hasta proxima llamada, vida util de dispositivos

---

### 6. Distribucion Uniforme

- Descripcion: Todos los valores dentro de un intervalo tienen la misma probabilidad.
- Ejemplo: Numero aleatorio entre 0 y 1.

```python
from scipy.stats import uniform

x = np.linspace(0, 1, 100)
y = uniform.pdf(x)

plt.plot(x, y)
plt.title("Distribucion Uniforme (0,1)")
plt.xlabel("Valor")
plt.ylabel("Densidad")
plt.grid()
plt.show()
```

Usos: Simulaciones, aleatorizacion, modelos simples

---

## Como distinguirlas

| Distribucion    | Tipo      | Indicadores comunes                         |
|----------------|-----------|---------------------------------------------|
| Bernoulli      | Discreta  | Dos resultados (exito/fracaso)              |
| Binomial       | Discreta  | Conteo de exitos en ensayos                 |
| Poisson        | Discreta  | Conteo de eventos por unidad de tiempo      |
| Normal         | Continua  | Forma de campana, simetrica                 |
| Exponencial    | Continua  | Tiempo entre eventos                        |
| Uniforme       | Continua  | Todos los valores igual de probables        |

---

## Por que son importantes

Las distribuciones de probabilidad:

- Permiten simular comportamientos reales
- Son base de pruebas estadisticas e inferencias
- Se usan en machine learning, finanzas, biologia, logistica, etc.

Comprenderlas es clave para elegir modelos adecuados y hacer analisis confiables.
