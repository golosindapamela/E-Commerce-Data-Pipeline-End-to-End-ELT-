-- Select order item information from the source table.
select
    -- Primary and Foreign Keys
    order_id,
    order_item_id as item_sequence, -- Renamed to prevents confusion with a unique primary key.
    product_id,
    seller_id,
   
    -- Timestamp Conversion
    shipping_limit_date::timestamp as shipping_limit_at,
   
    -- Numeric values
    price,
    freight_value
   
from {{ source('olist_raw', 'olist_order_items_dataset') }}

-- There are zero missing values across all its rows.
-- Both the foreign keys (order_id, product_id, seller_id)
-- and the financial metrics are fully populated and correctly typed,
-- meaning no further cleaning is required for this table.
