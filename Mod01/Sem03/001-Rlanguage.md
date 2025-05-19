
# Introduccion al Lenguaje R

Este documento es una introduccion practica al lenguaje de programacion **R**, ampliamente utilizado en estadistica, ciencia de datos y visualizacion.

---

## Que es R

**R** es un lenguaje de programacion y un entorno de software libre para computacion estadistica y grafica. Fue desarrollado originalmente por estadisticos y es muy usado en:

- Analisis de datos
- Visualizacion estadistica
- Modelado matematico
- Investigacion cientifica
- Bioinformatica y econometria

---

## En que se diferencia de Python

| Caracteristica         | R                                       | Python                                 |
|------------------------|-----------------------------------------|----------------------------------------|
| Enfoque principal      | Estadistica y visualizacion             | Generalista (IA, web, datos, automatizacion) |
| Librerias populares    | ggplot2, dplyr, tidyr                   | pandas, matplotlib, scikit-learn       |
| Comunidad              | Investigadores, academicos              | Desarrolladores, cientificos de datos  |
| Visualizacion          | Excelente con ggplot2                   | Flexible con matplotlib, seaborn       |
| Aprendizaje            | Mas facil para estadistica pura         | Mas versatil para tareas generales     |

Ambos lenguajes son poderosos y se usan en la ciencia de datos moderna. Muchos profesionales combinan ambos.

---

## Como instalar R

Puedes descargar R desde su sitio oficial:

https://cran.r-project.org/

Selecciona tu sistema operativo (Windows, macOS o Linux) y sigue las instrucciones.

---

## Como instalar RStudio

RStudio es el entorno de desarrollo (IDE) mas usado para escribir y ejecutar codigo en R.

https://posit.co/download/rstudio-desktop/

Descarga la version gratuita de RStudio Desktop y asegurate de instalar R primero.

---

## Primer ejercicio basico en R

Una vez que abras RStudio, puedes escribir este codigo en el script o directamente en la consola:

```r
# Crear un vector
numeros <- c(10, 20, 30, 40, 50)

# Calcular promedio
promedio <- mean(numeros)

# Mostrar resultado
print(promedio)
```

---

## Otros ejemplos utiles

```r
# Crear un data frame
datos <- data.frame(
  nombre = c("Ana", "Luis", "Pedro"),
  edad = c(25, 30, 28)
)

# Ver el data frame
print(datos)

# Histograma
hist(datos$edad)
```

---

## Conclusiones

- R es ideal para trabajos estadisticos, modelado y visualizacion.
- Se complementa muy bien con Python.
- Con RStudio, el trabajo se vuelve mas simple y productivo.

Puedes continuar aprendiendo sobre R explorando paquetes como `tidyverse`, `ggplot2`, `shiny`, y `caret`.

