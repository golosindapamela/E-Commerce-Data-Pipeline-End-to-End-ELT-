-- Select customer information from the source table.
select
    -- Primary key
    customer_id,

    -- Unique Identifier (to track repeat customers)
    customer_unique_id,

    -- Location attributes
    customer_zip_code_prefix
    customer_city
    customer_state

from {{ source('olist_raw', 'olist_customers_dataset') }}

-- The table is perfectly clean.
-- There are no missing values, and the data types are appropriate for SQL operations
-- No transformations are required.
