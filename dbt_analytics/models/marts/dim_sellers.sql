-- Base seller data from staging
with sellers as (
    select * from {{ ref('stg_olist_sellers') }}
),

-- Geolocation reference data (deduplicated by zip code)
geolocation as (
    select * from {{ ref('stg_olist_geolocation') }}
)

select
    -- Primary Key
    s.seller_id,

    -- Seller location details
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state,

    -- Geographic coordinates (Enrichment from geolocation)
    g.geolocation_lat,
    g.geolocation_lng

from sellers s

-- Left join ensures we keep all sellers even if coordinates are missing 
left join geolocation g
    on s.seller_zip_code_prefix = g.geolocation_zip_code_prefix