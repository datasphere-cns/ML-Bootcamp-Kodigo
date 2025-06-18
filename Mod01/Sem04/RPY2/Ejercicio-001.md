"""
Ejemplo Práctico: Análisis de Transacciones con Tarjeta de Crédito usando RPy2
=============================================================================

Este ejemplo demuestra cómo usar RPy2 para combinar:
- Manipulación de datos en Python (pandas)
- Análisis estadístico avanzado en R
- Visualización especializada con ggplot2

Caso de uso: Detección de patrones fraudulentos y análisis de comportamiento de compras
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Configuración de RPy2
import rpy2.robjects as ro
from rpy2.robjects import pandas2ri, numpy2ri
from rpy2.robjects.packages import importr
from rpy2.robjects.conversion import localconverter

# Activar conversiones automáticas
pandas2ri.activate()
numpy2ri.activate()

# Importar paquetes R necesarios
print(" Importando paquetes R...")
try:
    base = importr('base')
    stats = importr('stats')
    utils = importr('utils')
    
    # Instalar y cargar paquetes R si no existen
    r_packages = ['ggplot2', 'dplyr', 'lubridate', 'plotly']
    for pkg in r_packages:
        try:
            importr(pkg)
            print(f" {pkg} cargado correctamente")
        except:
            print(f" Instalando {pkg}...")
            utils.install_packages(pkg)
            print(f" {pkg} instalado y cargado")
    
    ggplot2 = importr('ggplot2')
    dplyr = importr('dplyr')
    lubridate = importr('lubridate')
    
except Exception as e:
    print(f" Error con paquetes R: {e}")
    print(" Asegúrate de tener R instalado correctamente")

# ==========================================
# 1. GENERACIÓN DE DATOS FICTICIOS
# ==========================================

def generar_transacciones_ficticias(n_transacciones=5000):
    """
    Genera un dataset ficticio de transacciones con tarjeta de crédito
    """
    print(f" Generando {n_transacciones} transacciones ficticias...")
    
    # Semilla para reproducibilidad
    np.random.seed(42)
    random.seed(42)
    
    # Configuración de parámetros
    n_usuarios = 500
    inicio_fecha = datetime(2024, 1, 1)
    fin_fecha = datetime(2024, 12, 31)
    
    # Categorías de comercios
    categorias = [
        'Supermercado', 'Gasolina', 'Restaurante', 'Ropa', 'Farmacia',
        'Electrónicos', 'Online', 'Entretenimiento', 'Salud', 'Educación'
    ]
    
    # Generar transacciones
    transacciones = []
    
    for _ in range(n_transacciones):
        # Usuario aleatorio
        usuario_id = f"USER_{random.randint(1000, 1000 + n_usuarios):04d}"
        
        # Fecha aleatoria
        dias_diff = (fin_fecha - inicio_fecha).days
        fecha_random = inicio_fecha + timedelta(days=random.randint(0, dias_diff))
        
        # Hora del día (patrones realistas)
        if random.random() < 0.7:  # 70% durante horas normales
            hora = random.randint(6, 22)
        else:  # 30% durante horas inusuales
            hora = random.randint(23, 5) % 24
        
        fecha_completa = fecha_random.replace(
            hour=hora, 
            minute=random.randint(0, 59),
            second=random.randint(0, 59)
        )
        
        # Categoría y monto (correlacionados)
        categoria = random.choice(categorias)
        
        # Montos realistas por categoría
        montos_base = {
            'Supermercado': (20, 150),
            'Gasolina': (30, 80),
            'Restaurante': (15, 120),
            'Ropa': (25, 300),
            'Farmacia': (10, 60),
            'Electrónicos': (50, 1500),
            'Online': (10, 200),
            'Entretenimiento': (20, 100),
            'Salud': (50, 500),
            'Educación': (100, 800)
        }
        
        min_monto, max_monto = montos_base[categoria]
        monto = round(np.random.gamma(2, (max_monto - min_monto) / 6) + min_monto, 2)
        
        # Ubicación geográfica
        ciudades = ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao', 
                   'Málaga', 'Zaragoza', 'Murcia', 'Palma', 'Las Palmas']
        ciudad = random.choice(ciudades)
        
        # Generar algunas transacciones fraudulentas (2%)
        es_fraude = random.random() < 0.02
        
        if es_fraude:
            # Transacciones fraudulentas tienen patrones distintos
            monto *= random.uniform(3, 10)  # Montos más altos
            if random.random() < 0.5:
                # Horas inusuales para fraude
                fecha_completa = fecha_completa.replace(hour=random.randint(1, 4))
        
        # Estado de la transacción
        if es_fraude and random.random() < 0.3:
            estado = 'Rechazada'
        else:
            estado = random.choices(
                ['Aprobada', 'Rechazada', 'Pendiente'],
                weights=[0.92, 0.06, 0.02]
            )[0]
        
        transacciones.append({
            'usuario_id': usuario_id,
            'fecha_hora': fecha_completa,
            'monto': monto,
            'categoria': categoria,
            'ciudad': ciudad,
            'estado': estado,
            'es_fraude': es_fraude,
            'dia_semana': fecha_completa.strftime('%A'),
            'hora': fecha_completa.hour,
            'mes': fecha_completa.month
        })
    
    df = pd.DataFrame(transacciones)
    print(f" Dataset generado: {len(df)} transacciones")
    print(f" Transacciones fraudulentas: {df['es_fraude'].sum()} ({df['es_fraude'].mean()*100:.1f}%)")
    
    return df

# ==========================================
# 2. ANÁLISIS CON PYTHON (PANDAS)
# ==========================================

def analisis_python(df):
    """
    Análisis básico con pandas (Python)
    """
    print("\n ANÁLISIS CON PYTHON (pandas)")
    print("=" * 50)
    
    # Estadísticas básicas
    print(" Estadísticas Básicas del Monto:")
    print(df['monto'].describe())
    
    # Análisis por categoría
    print("\n Análisis por Categoría:")
    categoria_stats = df.groupby('categoria').agg({
        'monto': ['count', 'mean', 'sum'],
        'es_fraude': 'sum'
    }).round(2)
    print(categoria_stats)
    
    # Detección básica de anomalías
    print("\n Detección Básica de Anomalías:")
    q99 = df['monto'].quantile(0.99)
    anomalias = df[df['monto'] > q99]
    print(f"Transacciones con monto > P99 (€{q99:.2f}): {len(anomalias)}")
    
    return df

# ==========================================
# 3. ANÁLISIS ESTADÍSTICO AVANZADO CON R
# ==========================================

def analisis_estadistico_r(df):
    """
    Análisis estadístico avanzado usando R a través de RPy2
    """
    print("\n ANÁLISIS ESTADÍSTICO AVANZADO CON R")
    print("=" * 50)
    
    try:
        # Convertir DataFrame a R
        with localconverter(pandas2ri.converter):
            df_r = pandas2ri.py2rpy(df)
            ro.globalenv['transacciones'] = df_r
        
        # 1. Análisis de distribución con tests estadísticos
        print(" Tests de Normalidad y Distribución...")
        
        resultado_shapiro = ro.r('''
            # Test de normalidad Shapiro-Wilk (muestra pequeña)
            muestra_monto <- sample(transacciones$monto, 1000)
            shapiro_test <- shapiro.test(muestra_monto)
            
            # Test de Kolmogorov-Smirnov para comparar con distribución normal
            ks_test <- ks.test(muestra_monto, "pnorm", 
                              mean = mean(muestra_monto), 
                              sd = sd(muestra_monto))
            
            list(
                shapiro_p = shapiro_test$p.value,
                ks_p = ks_test$p.value,
                distribucion_normal = shapiro_test$p.value > 0.05
            )
        ''')
        
        print(f"  Shapiro-Wilk p-value: {resultado_shapiro[0][0]:.6f}")
        print(f"  Kolmogorov-Smirnov p-value: {resultado_shapiro[1][0]:.6f}")
        print(f"  ¿Distribución normal?: {'Sí' if resultado_shapiro[2][0] else 'No'}")
        
        # 2. Análisis de varianza (ANOVA) por categoría
        print("\n Análisis de Varianza (ANOVA) por Categoría...")
        
        anova_resultado = ro.r('''
            # ANOVA para comparar montos entre categorías
            anova_resultado <- aov(monto ~ categoria, data = transacciones)
            anova_summary <- summary(anova_resultado)
            
            # Test post-hoc Tukey para comparaciones múltiples
            tukey_resultado <- TukeyHSD(anova_resultado)
            
            list(
                f_statistic = anova_summary[[1]][1,4],
                p_value = anova_summary[[1]][1,5],
                significativo = anova_summary[[1]][1,5] < 0.05
            )
        ''')
        
        print(f"  F-statistic: {anova_resultado[0][0]:.4f}")
        print(f"  P-value: {anova_resultado[1][0]:.6f}")
        print(f"  ¿Diferencias significativas?: {'Sí' if anova_resultado[2][0] else 'No'}")
        
        # 3. Modelo de regresión logística para detección de fraude
        print("\n Modelo de Regresión Logística para Detección de Fraude...")
        
        modelo_fraude = ro.r('''
            # Preparar datos para el modelo
            transacciones$hora_cat <- cut(transacciones$hora, 
                                        breaks = c(0, 6, 12, 18, 24),
                                        labels = c("Madrugada", "Mañana", "Tarde", "Noche"),
                                        include.lowest = TRUE)
            
            # Modelo de regresión logística
            modelo <- glm(es_fraude ~ monto + hora + categoria, 
                         data = transacciones, 
                         family = binomial())
            
            # Estadísticas del modelo
            modelo_summary <- summary(modelo)
            
            # Matriz de confusión
            predicciones <- predict(modelo, type = "response")
            pred_clase <- ifelse(predicciones > 0.5, TRUE, FALSE)
            matriz_confusion <- table(transacciones$es_fraude, pred_clase)
            
            # Cálculo de métricas
            precision <- matriz_confusion[2,2] / sum(matriz_confusion[,2])
            recall <- matriz_confusion[2,2] / sum(matriz_confusion[2,])
            f1_score <- 2 * (precision * recall) / (precision + recall)
            
            list(
                aic = modelo$aic,
                precision = precision,
                recall = recall,
                f1_score = f1_score,
                coeficientes = modelo$coefficients
            )
        ''')
        
        print(f"  AIC del modelo: {modelo_fraude[0][0]:.2f}")
        print(f"  Precision: {modelo_fraude[1][0]:.4f}")
        print(f"  Recall: {modelo_fraude[2][0]:.4f}")
        print(f"  F1-Score: {modelo_fraude[3][0]:.4f}")
        
        # 4. Análisis de series temporales
        print("\n Análisis de Series Temporales...")
        
        serie_temporal = ro.r('''
            library(lubridate)
            
            # Agregar transacciones por día
            transacciones$fecha <- as.Date(transacciones$fecha_hora)
            serie_diaria <- aggregate(monto ~ fecha, data = transacciones, sum)
            
            # Crear serie temporal
            ts_datos <- ts(serie_diaria$monto, frequency = 7)  # Frecuencia semanal
            
            # Descomposición de la serie
            decomp <- decompose(ts_datos)
            
            # Estadísticas de tendencia
            tendencia_media <- mean(decomp$trend, na.rm = TRUE)
            estacionalidad_var <- var(decomp$seasonal, na.rm = TRUE)
            
            list(
                tendencia_media = tendencia_media,
                varianza_estacional = estacionalidad_var,
                observaciones = length(ts_datos)
            )
        ''')
        
        print(f"  Tendencia media: €{serie_temporal[0][0]:.2f}")
        print(f"  Varianza estacional: {serie_temporal[1][0]:.2f}")
        print(f"  Observaciones: {int(serie_temporal[2][0])}")
        
    except Exception as e:
        print(f" Error en análisis R: {e}")
        print(" Verifica que R y los paquetes estén instalados correctamente")

# ==========================================
# 4. VISUALIZACIÓN AVANZADA CON GGPLOT2
# ==========================================

def visualizacion_r(df):
    """
    Crear visualizaciones avanzadas usando ggplot2 de R
    """
    print("\n VISUALIZACIÓN AVANZADA CON GGPLOT2")
    print("=" * 50)
    
    try:
        # Convertir DataFrame a R
        with localconverter(pandas2ri.converter):
            df_r = pandas2ri.py2rpy(df)
            ro.globalenv['datos_viz'] = df_r
        
        # 1. Gráfico de distribución de montos por categoría
        print("📊 Creando gráfico de distribución por categoría...")
        
        ro.r('''
            library(ggplot2)
            library(dplyr)
            
            # Gráfico de cajas y bigotes
            p1 <- ggplot(datos_viz, aes(x = categoria, y = monto, fill = categoria)) +
                geom_boxplot() +
                geom_jitter(alpha = 0.3, width = 0.2, size = 0.5) +
                theme_minimal() +
                theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                labs(title = "Distribución de Montos por Categoría",
                     subtitle = "Análisis de Transacciones con Tarjeta de Crédito",
                     x = "Categoría", y = "Monto (€)",
                     fill = "Categoría") +
                scale_fill_viridis_d()
            
            # Guardar gráfico
            ggsave("distribucion_categorias.png", p1, width = 12, height = 8, dpi = 300)
            print("Gráfico guardado: distribucion_categorias.png")
        ''')
        
        # 2. Análisis temporal de transacciones
        print("Creando gráfico de análisis temporal...")
        
        ro.r('''
            # Preparar datos temporales
            datos_viz$fecha <- as.Date(datos_viz$fecha_hora)
            datos_viz$semana <- format(datos_viz$fecha, "%Y-%U")
            
            # Agregar por semana
            datos_semana <- datos_viz %>%
                group_by(semana, es_fraude) %>%
                summarise(
                    total_transacciones = n(),
                    monto_total = sum(monto),
                    .groups = 'drop'
                )
            
            # Gráfico de series temporales
            p2 <- ggplot(datos_semana, aes(x = semana, y = total_transacciones, 
                                          color = factor(es_fraude))) +
                geom_line(aes(group = factor(es_fraude)), size = 1.2) +
                geom_point(size = 2) +
                theme_minimal() +
                theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
                labs(title = "Evolución Temporal de Transacciones",
                     subtitle = "Comparación entre Transacciones Normales y Fraudulentas",
                     x = "Semana", y = "Número de Transacciones",
                     color = "Tipo") +
                scale_color_manual(values = c("FALSE" = "#2E86AB", "TRUE" = "#F24236"),
                                 labels = c("Normal", "Fraude")) +
                facet_wrap(~factor(es_fraude), scales = "free_y", 
                          labeller = labeller(.default = c("FALSE" = "Transacciones Normales",
                                                          "TRUE" = "Transacciones Fraudulentas")))
            
            ggsave("evolucion_temporal.png", p2, width = 14, height = 8, dpi = 300)
            print(" Gráfico guardado: evolucion_temporal.png")
        ''')
        
        # 3. Heatmap de patrones por hora y día
        print(" Creando heatmap de patrones temporales...")
        
        ro.r('''
            # Preparar datos para heatmap
            datos_viz$dia_semana_num <- as.numeric(factor(datos_viz$dia_semana, 
                levels = c("Monday", "Tuesday", "Wednesday", "Thursday", 
                          "Friday", "Saturday", "Sunday")))
            
            # Agregar por hora y día
            heatmap_data <- datos_viz %>%
                group_by(hora, dia_semana, dia_semana_num) %>%
                summarise(
                    num_transacciones = n(),
                    monto_promedio = mean(monto),
                    tasa_fraude = mean(as.numeric(es_fraude)),
                    .groups = 'drop'
                )
            
            # Heatmap de actividad
            p3 <- ggplot(heatmap_data, aes(x = hora, y = reorder(dia_semana, dia_semana_num), 
                                          fill = num_transacciones)) +
                geom_tile() +
                scale_fill_gradient(low = "white", high = "darkblue", name = "Transacciones") +
                theme_minimal() +
                labs(title = "Patrón de Actividad: Transacciones por Hora y Día",
                     subtitle = "Heatmap de Intensidad de Transacciones",
                     x = "Hora del Día", y = "Día de la Semana") +
                scale_x_continuous(breaks = seq(0, 23, 2))
            
            ggsave("heatmap_actividad.png", p3, width = 12, height = 6, dpi = 300)
            print(" Gráfico guardado: heatmap_actividad.png")
        ''')
        
        print("\n Todas las visualizaciones han sido generadas exitosamente!")
        
    except Exception as e:
        print(f" Error en visualización: {e}")

# ==========================================
# 5. COMPARACIÓN PYTHON vs R
# ==========================================

def comparacion_performance():
    """
    Comparar performance entre operaciones nativas de Python y R
    """
    print("\n COMPARACIÓN DE PERFORMANCE PYTHON vs R")
    print("=" * 50)
    
    # Generar datos de prueba más grandes
    n_test = 100000
    datos_test = np.random.gamma(2, 1000, n_test)
    
    import time
    
    # Test Python
    start_time = time.time()
    media_py = np.mean(datos_test)
    std_py = np.std(datos_test)
    quantiles_py = np.percentile(datos_test, [25, 50, 75, 95, 99])
    tiempo_python = time.time() - start_time
    
    # Test R
    start_time = time.time()
    ro.globalenv['datos_test'] = ro.FloatVector(datos_test)
    resultado_r = ro.r('''
        media_r <- mean(datos_test)
        std_r <- sd(datos_test)
        quantiles_r <- quantile(datos_test, c(0.25, 0.5, 0.75, 0.95, 0.99))
        
        list(media = media_r, std = std_r, quantiles = quantiles_r)
    ''')
    tiempo_r = time.time() - start_time
    
    print(f" Python - Tiempo: {tiempo_python:.4f}s")
    print(f"   Media: {media_py:.2f}, Std: {std_py:.2f}")
    
    print(f" R - Tiempo: {tiempo_r:.4f}s")
    print(f"   Media: {resultado_r[0][0]:.2f}, Std: {resultado_r[1][0]:.2f}")
    
    print(f"\n Ratio de velocidad: {tiempo_r/tiempo_python:.2f}x")
    print(" Nota: R incluye overhead de RPy2 y conversión de datos")

# ==========================================
# FUNCIÓN PRINCIPAL
# ==========================================

def main():
    """Función principal que ejecuta todo el análisis"""
    
    print("🚀 ANÁLISIS DE TRANSACCIONES CON TARJETA DE CRÉDITO")
    print("=" * 60)
    print("Demostrando el poder de RPy2 para integrar Python y R")
    print("=" * 60)
    
    # 1. Generar datos
    df = generar_transacciones_ficticias(5000)
    
    # 2. Análisis básico con Python
    df = analisis_python(df)
    
    # 3. Análisis estadístico avanzado con R
    analisis_estadistico_r(df)
    
    # 4. Visualización con ggplot2
    visualizacion_r(df)
    
    # 5. Comparación de performance
    comparacion_performance()
    
    print("\n" + "=" * 60)
    print(" RESUMEN DE VENTAJAS DE RPy2 DEMOSTRADAS:")
    print("=" * 60)
    print(" Manipulación de datos eficiente con pandas (Python)")
    print(" Tests estadísticos avanzados con R")
    print(" Visualizaciones profesionales con ggplot2")
    print(" Modelos estadísticos especializados (GLM)")
    print(" Análisis de series temporales")
    print(" Flujo de trabajo unificado en un solo script")
    print("\n ¡RPy2 permite lo mejor de ambos mundos!")

# Ejecutar análisis
if __name__ == "__main__":
    main()
