# Integración de R en Python con `rpy2`

## Introducción: ¿Por qué combinar Python con R?

Python y R son dos de los lenguajes más utilizados en ciencia de datos, cada uno con sus propias fortalezas. Combinarlos puede permitirte construir soluciones más sólidas, especializadas y eficientes.

### Fortalezas de cada lenguaje

**Python destaca por:**
- Su versatilidad para desarrollo de software, automatización y backend
- Manejo eficiente de datos con `pandas` y `numpy`
- Gran ecosistema para Machine Learning (`scikit-learn`, `TensorFlow`, `PyTorch`)
- Integración sencilla con APIs, pipelines y dashboards

**R destaca por:**
- Estadística avanzada y modelado clásico
- Visualizaciones de alta calidad con `ggplot2`, `lattice`
- Herramientas interactivas como `shiny`
- Facilidad para análisis exploratorio con `dplyr`, `tidyr`

### ¿Cuándo es útil usar ambos?

- Tienes un flujo en Python y necesitas análisis estadístico específico en R
- Quieres aprovechar la visualización avanzada de R (`ggplot2`)
- Estás migrando código o deseas reutilizar análisis existentes en R
- Quieres integrar resultados de R en una solución automatizada en Python

---

## PASO 1 – Instalar `rpy2`

Necesitas instalar `rpy2`, el puente entre Python y R.

```bash
pip install rpy2
