# Análisis de Sentimientos combinando Python y R

Este ejercicio muestra cómo generar datos textuales en Python, analizarlos con R utilizando el paquete `syuzhet`, y visualizar los sentimientos en un gráfico de barras.

---

## Requisitos

### En Python:

```bash
pip install rpy2 pandas
```

### En R (ejecutar en consola de R):

```r
install.packages("syuzhet")
install.packages("ggplot2")
```

---

## Script completo: Comentarios + Sentimientos

```python
import pandas as pd
from rpy2.robjects import pandas2ri
import rpy2.robjects as robjects

# Activar conversión automática
pandas2ri.activate()

# Simular comentarios de clientes
comentarios = pd.DataFrame({
    "texto": [
        "Me encantó el servicio, todo fue excelente.",
        "Muy mala atención, no vuelvo nunca más.",
        "El producto llegó tarde pero era de buena calidad.",
        "Rápido y eficiente, recomendado.",
        "Demasiado caro para lo que ofrece.",
        "Increíble experiencia, volveré pronto.",
        "Atención deficiente, pero el producto es bueno.",
        "No me gustó la calidad del empaque.",
        "Excelente atención al cliente.",
        "Nada que destacar, fue una compra promedio."
    ]
})

# Enviar a R
robjects.globalenv["df_texto"] = pandas2ri.py2rpy(comentarios)

# Código R para análisis de sentimientos
codigo_r = """
library(syuzhet)
library(ggplot2)

# Extraer los textos
textos <- df_texto$texto

# Calcular sentimientos
sentimientos <- get_nrc_sentiment(textos)

# Sumar por tipo de emoción
resumen <- data.frame(
  emocion = colnames(sentimientos),
  total = colSums(sentimientos)
)

# Graficar
ggplot(resumen, aes(x = emocion, y = total, fill = emocion)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Análisis de Sentimientos NRC", x = "Emoción", y = "Frecuencia") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
"""

# Ejecutar desde Python
robjects.r(codigo_r)
```

---

## ¿Qué se analiza?

- Se usa el **lexicón NRC** para clasificar palabras en 8 emociones básicas (como "joy", "anger", "fear") y 2 polaridades ("positive", "negative").
- Se obtienen conteos por tipo de emoción para todos los comentarios.
- Se visualiza la distribución emocional de los textos en un gráfico de barras.

---

## Extensiones posibles

- Incluir comentarios reales desde un CSV o API.
- Analizar emociones por cliente o tipo de producto.
- Visualizar nubes de palabras con `wordcloud`.
- Hacer seguimiento emocional en el tiempo.

---

## Conclusión

Este ejercicio demuestra cómo puedes:
- Generar datos textuales con Python,
- Aplicar análisis lingüístico en R con `syuzhet`,
- Y visualizar los resultados con `ggplot2`.

Una poderosa combinación para analizar opiniones de clientes de forma automatizada.
