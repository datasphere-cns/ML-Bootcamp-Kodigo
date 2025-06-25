#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pymysql
import pandas as pd
import numpy as np
import scipy.stats as stats
import logging

# Configuración del logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    handlers=[
        logging.StreamHandler(),
        logging.FileHandler("etl_process.log")
    ]
)

# Configuración de la conexión a la base de datos
endpoint = "mat-trn-src.co4vks4ks8wo.eu-west-1.rds.amazonaws.com"
port = 3306
database = "training"
username = "srcuser"
password = "matillion"

# Pipeline 1: Carga y lectura de la base de datos
def load_data():
    logging.info("Estableciendo conexión con la base de datos.")
    try:
        connection = pymysql.connect(
            host=endpoint,
            user=username,
            password=password,
            database=database,
            port=port
        )
        with connection.cursor() as cursor:
            logging.info("Ejecutando consulta SQL.")
            sql_query = """
            SELECT `iata`, `airport`, `city`, `state`, `country`, `lat`, `long`, `num_carriers`, `is_active`
            FROM training_rds_airports;
            """
            cursor.execute(sql_query)
            results = cursor.fetchall()
            columns = ['iata', 'airport', 'city', 'state', 'country', 'lat', 'long', 'num_carriers', 'is_active']
            df = pd.DataFrame(results, columns=columns)
            logging.info("DataFrame creado a partir de los resultados.")
        return df
    except pymysql.MySQLError as e:
        logging.error(f"Error al conectar o ejecutar la consulta: {e}")
        return None
    finally:
        connection.close()
        logging.info("Conexión con la base de datos cerrada.")

# Pipeline 2: Transformaciones de la variable numérica y análisis de normalidad
def transform_and_check_normality(df):
    logging.info("Transformando columna 'is_active' a booleano.")
    df['is_active'] = df['is_active'].apply(lambda x: x == b'\x01')
    
    logging.info("Verificando normalidad de la columna 'num_carriers'.")
    shapiro_stat, shapiro_p_value = stats.shapiro(df['num_carriers'])
    ks_stat, ks_p_value = stats.kstest(df['num_carriers'], 'norm', args=(df['num_carriers'].mean(), df['num_carriers'].std()))
    
    logging.info(f"Prueba de Shapiro-Wilk: Estadístico={shapiro_stat}, p-valor={shapiro_p_value}")
    logging.info(f"Prueba de Kolmogorov-Smirnov: Estadístico={ks_stat}, p-valor={ks_p_value}")
    
    alpha = 0.05
    if shapiro_p_value > alpha and ks_p_value > alpha:
        logging.info("La columna 'num_carriers' sigue una distribución normal.")
    else:
        logging.info("La columna 'num_carriers' no sigue una distribución normal.")

    return df

# Pipeline 3: Transformaciones de Encoding
def apply_encodings(df):
    # Agregar una columna de target simulada para el ejemplo de Target Encoding
    np.random.seed(0)
    df['target_value'] = np.random.randint(0, 100, size=len(df))
    categorical_columns = ['iata', 'airport', 'city', 'state', 'country']
    
    # One-Hot Encoding
    logging.info("Aplicando One-Hot Encoding a las variables categóricas.")
    df_one_hot = pd.get_dummies(df, columns=categorical_columns)
    logging.info(f"DataFrame después de One-Hot Encoding: {df_one_hot.shape[1]} columnas.")
    
    # Frequency Encoding
    logging.info("Aplicando Frequency Encoding a las variables categóricas.")
    df_freq = df.copy()
    for column in categorical_columns:
        freq_encoding = df_freq[column].value_counts() / len(df_freq)
        df_freq[column + '_freq'] = df_freq[column].map(freq_encoding)
    df_freq = df_freq.drop(columns=categorical_columns)
    logging.info(f"DataFrame después de Frequency Encoding: {df_freq.shape[1]} columnas.")
    
    # Target Encoding
    logging.info("Aplicando Target Encoding a las variables categóricas.")
    df_target = df.copy()
    for column in categorical_columns:
        target_mean = df_target.groupby(column)['target_value'].mean()
        df_target[column + '_target'] = df_target[column].map(target_mean)
    df_target = df_target.drop(columns=categorical_columns)
    logging.info(f"DataFrame después de Target Encoding: {df_target.shape[1]} columnas.")
    
    return df_one_hot, df_freq, df_target

# Ejecución del proceso ETL completo
def main():
    logging.info("Iniciando proceso ETL.")
    
    # Pipeline 1: Cargar datos
    df = load_data()
    if df is None:
        logging.error("Error en el pipeline de carga de datos. Proceso ETL terminado.")
        return
    
    # Pipeline 2: Transformaciones en variable numérica y análisis de normalidad
    df_transformed = transform_and_check_normality(df)
    
    # Pipeline 3: Aplicación de encodings
    df_one_hot, df_freq, df_target = apply_encodings(df_transformed)
    
    logging.info("Proceso ETL completado.")

if __name__ == "__main__":
    main()

