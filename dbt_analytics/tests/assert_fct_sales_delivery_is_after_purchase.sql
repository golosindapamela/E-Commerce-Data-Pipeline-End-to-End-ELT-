-- Delivery cannot happen before the purchase.
-- Returns rows where the delivery timestamp is earlier than the purchase timestamp.
select
    order_id,
    order_purchase_at,
    order_delivered_customer_at
from {{ ref('fct_sales') }}
where order_delivered_customer_at < order_purchase_at