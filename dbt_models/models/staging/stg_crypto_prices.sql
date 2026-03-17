{{ config(
    materialized='view'
) }}

with raw_data as (
    select * from {{ source('crypto_raw', 'raw_crypto_prices') }}
)

select
    -- Identificadores
    id as coin_id,
    symbol as coin_symbol,
    name as coin_name,
    
    -- Métricas Financieras
    current_price as price_usd,
    market_cap as market_cap_usd,
    market_cap_rank,
    total_volume as volume_24h_usd,
    high_24h as price_high_24h_usd,
    low_24h as price_low_24h_usd,
    price_change_percentage_24h as price_change_pct_24h,
    
    -- Timestamps
    last_updated as last_updated_at,
    extracted_at

from raw_data
