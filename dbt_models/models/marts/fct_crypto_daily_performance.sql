{{ config(
    materialized='table'
) }}

with staging_crypto as (
    select * from {{ ref('stg_crypto_prices') }}
)

select
    coin_id,
    coin_symbol,
    coin_name,
    price_usd,
    market_cap_rank,
    
    -- Lógica de negocio (ej: clasificar las monedas según su crecimiento diario)
    case 
        when price_change_pct_24h > 5 then 'High Growth'
        when price_change_pct_24h > 0 and price_change_pct_24h <= 5 then 'Moderate Growth'
        when price_change_pct_24h < 0 then 'Decline'
        else 'Stable'
    end as daily_performance_category,
    
    price_change_pct_24h,
    market_cap_usd,
    volume_24h_usd,
    extracted_at

from staging_crypto
where market_cap_rank <= 50 -- Filtro para enfocarnos solo en el Top 50
