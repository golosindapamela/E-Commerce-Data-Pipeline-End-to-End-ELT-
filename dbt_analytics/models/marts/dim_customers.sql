-- Base customer data from staging
with customers as (
    select * from {{ ref('stg_olist_customers') }}
),

-- Geolocation reference data (deduplicated by zip code)
geolocation as (
    select * from {{ ref('stg_olist_geolocation') }}
)

select
    -- Customer identifiers
    c.customer_id,
    c.customer_unique_id,

    -- Customer location info
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,

    -- Latitude & longitude (from zip code match)
    g.geolocation_lat,
    g.geolocation_lng

from customers c

-- Left join to keep all customers, even if specific geolocation coordinates are missing
left join geolocation g
    on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix