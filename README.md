# 🚀 Analytics Engineering Pipeline: Crypto Market Data

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

Este proyecto es un pipeline de datos **end-to-end** diseñado para extraer, cargar y modelar datos en tiempo real del mercado de criptomonedas, aplicando las mejores prácticas de **Analytics Engineering**.

## 🎯 Objetivo del Proyecto
El propósito principal es demostrar la automatización de la ingesta de datos a través de una API pública y la transformación mediante modelos SQL testeables y versionados, transicionando los datos desde un formato crudo (Raw) hasta un Data Mart final listo para visualización (BI).

## 🏗️ Arquitectura y Tecnologías
1. **Extracción (Python + Requests):** Script desarrollado en Python (`extract.py`) que consume el Top 100 de criptomonedas directamente desde la **API pública de CoinGecko** y limpia el formato JSON crudo usando `pandas`.
2. **Carga y Almacenamiento (SQLite):** Una base de datos local y ligera (`analytics.db`) actúa como nuestro *Data Warehouse*, almacenando la capa cruda en la tabla `raw_crypto_prices`.
3. **Transformación (dbt Core):** Data Build Tool gestiona el modelado SQL:
   * **Capa Staging:** Se estandarizan nombres de columnas, tipos de datos y se separan métricas financieras de identificadores (`stg_crypto_prices.sql`).
   * **Capa Mart (Negocio):** Se enriquece la data agregando reglas de negocio, como la categorización de rendimiento diario (`High Growth`, `Decline`, etc.) en la tabla final `fct_crypto_daily_performance.sql`.
4. **Calidad de Datos (Data Testing):** dbt asegura la integridad referencial y de esquema mediante tests automáticos (`not_null`, `unique`, `accepted_values`) definidos en `schema.yml`.
5. **CI/CD (GitHub Actions):** Flujo de integración continua que ejecuta el pipeline completo en la nube ante cada nuevo *push*, garantizando que el código subido a la rama `main` extraiga datos nuevos y pase satisfactoriamente todos los tests de dbt.

---

## 💻 ¿Cómo ejecutar este proyecto localmente?

Si deseas correr este pipeline de datos en tu propia máquina, sigue estos pasos:

### 1. Clonar y Configurar Entorno
Clona este repositorio y navega a su carpeta:
```bash
git clone https://github.com/TabisiAugusto/etl_project.git
cd etl_project
```

Crea un entorno virtual de Python y actívalo (Mac/Linux):
```bash
python3 -m venv .venv
source .venv/bin/activate
```

Instala las dependencias necesarias:
```bash
pip install -r requirements.txt
```

### 2. Extracción de Datos (E)
Corre el script principal para obtener los datos más recientes del mercado y guardarlos en la base de datos local:
```bash
python extract.py
```
> *Si es exitoso, notarás que se generó un archivo `analytics.db` en tu directorio.*

### 3. Transformación y Modelado (T)
Entra a la carpeta de dbt para construir los modelos finales partiendo de la data cruda:
```bash
cd dbt_models
dbt run
```

### 4. Testing de Calidad
Verifica que los datos cumplan con las reglas de negocio y no haya valores nulos o duplicados críticos:
```bash
dbt test
```

## 📊 Próximos Pasos (Escalabilidad)
- [ ] Conectar un motor de BI (ej. Tableau o PowerBI) a la base `analytics.db` para visualizar el rendimiento clasificado del Data Mart.
- [ ] Migrar el almacenamiento de SQLite a un Data Warehouse en la Nube (ej. Snowflake o BigQuery) y montar la ejecución recurrente en Apache Airflow.