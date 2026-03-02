--- Select and clean geolocation data, deduplicating by zip code.
select
    -- Zip Code Prefix (Primary Key for joins)
    geolocation_zip_code_prefix,

    -- Coordinates (Averaged to get a single central point per zip code)
    avg(geolocation_lat) as geolocation_lat,
    avg(geolocation_lng) as geolocation_lng,

    -- Location Details (Cleaned via macro)
    {{ normalize_characters(clean_string('geolocation_city')) }} as geolocation_city,
    geolocation_state

from {{ source('olist_raw', 'olist_geolocation_dataset') }}

group by 1, 4, 5

-- We group by zip, city, and state to remove redundant coordinate rows.
-- Averaging Lat/Lng provides a geographic center for each zip code prefix.
