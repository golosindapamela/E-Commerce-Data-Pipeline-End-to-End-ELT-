-- Base seller data from staging
with sellers as (
    -- Use DISTINCT ON to ensure each seller_id is unique for the dimension table
    select distinct on (seller_id)
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
    from {{ ref('stg_olist_sellers') }}
    order by seller_id -- Required for DISTINCT ON syntax
),

geolocation as (
    -- Deduplicate geolocation so there is only 1 row per zip code
    select distinct on (geolocation_zip_code_prefix)
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng
    from {{ ref('stg_olist_geolocation') }}
    order by geolocation_zip_code_prefix
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