-- Select registered seller information from the source table.
select
    -- Primary Key
    seller_id,

    -- Location Details
    seller_zip_code_prefix,
    {{ clean_string('seller_city') }} as seller_city,
    seller_state

from {{ source('olist_raw', 'olist_sellers_dataset') }}

-- The table is clean and ready.
-- There are no missing values in the primary key (seller_id).
