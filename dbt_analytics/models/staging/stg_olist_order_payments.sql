-- Select payment information for orders from the source table.
select
    -- Foreign Key
    order_id,
   
    -- Payment Details
    payment_sequential,
    {{ clean_string('payment_type') }} as payment_type,
    payment_installments,

    -- Numeric value
    payment_value as total_payment_amount

from {{ source('olist_raw', 'olist_order_payments_dataset') }}

-- The table is completely clean with zero missing values.
-- The data types are perfectly aligned for numerical aggregations (SUM, AVG).
-- No further transformations are necessary.
