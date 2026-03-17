import requests
import sqlite3
import pandas as pd
from datetime import datetime

def extract_crypto_data():
    url = "https://api.coingecko.com/api/v3/coins/markets"
    params = {
        "vs_currency": "usd",
        "order": "market_cap_desc",
        "per_page": 100,
        "page": 1,
        "sparkline": "false"
    }
    
    print("Obteniendo datos de la API de CoinGecko...")
    response = requests.get(url, params=params)
    response.raise_for_status()
    data = response.json()
    
    # Transformación inicial usando Pandas
    df = pd.DataFrame(data)
    
    # Selecciono solo las columnas relevantes
    cols = [
        'id', 'symbol', 'name', 'current_price', 'market_cap', 
        'market_cap_rank', 'total_volume', 'high_24h', 'low_24h', 
        'price_change_percentage_24h', 'last_updated'
    ]
    df = df[cols]
    
    # Añado la marca temporal del proceso de extracción ETL
    df['extracted_at'] = datetime.now().isoformat()
    
    # Carga de datos en crudo (Raw Layer) usando SQLite local
    print("Guardando datos en SQLite (analytics.db)...")
    conn = sqlite3.connect('analytics.db')
    df.to_sql('raw_crypto_prices', conn, if_exists='replace', index=False)
    conn.close()
    
    print(f"✅ Extracción completada: {len(df)} registros guardados en la tabla 'raw_crypto_prices'.")

if __name__ == "__main__":
    extract_crypto_data()
