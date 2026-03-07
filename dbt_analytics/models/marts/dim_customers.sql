-- Base customer data from staging
with customers as (
    -- Use DISTINCT ON to ensure each customer_id appears only once
    select distinct on (customer_id)
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    from {{ ref('stg_olist_customers') }}
    order by customer_id
),

-- Geolocation reference data (deduplicated by zip code)
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
    -- Customer identifiers (Primary Key)
    c.customer_id,
    c.customer_unique_id,

    -- Customer location info
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,

    -- Latitude & longitude (Enriched from zip code match)
    g.geolocation_lat,
    g.geolocation_lng

from customers c

-- Left join ensures we keep all customers even if coordinates are missing 
left join geolocation g
    on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix