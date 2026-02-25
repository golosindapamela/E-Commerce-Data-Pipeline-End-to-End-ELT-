-- Select customer order information from the source table.
select
    -- Primary and Foreign Keys
    order_id,
    customer_id,

    -- Status
    order_status,

    -- Timestamp Conversions (Casting text to timestamp)
    order_purchase_timestamp::timestamp as order_purchase_at,
    order_approved_at::timestamp as order_approved_at,
    order_delivered_carrier_date::timestamp as order_delivered_carrier_at,
    order_delivered_customer_date::timestamp as order_delivered_customer_at,
    order_estimated_delivery_date::timestamp as order_estimated_delivery_at

from {{ source('olist_raw', 'olist_orders_dataset') }}

-- We will intentionally leave the null values in the timestamp columns untouched,
-- as they represent real-world scenarios (e.g., orders were canceled or are still in transit).
