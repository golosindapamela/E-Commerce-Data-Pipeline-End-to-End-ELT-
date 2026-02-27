-- Each line item should have a positive price and freight value.
-- Returns rows where the math doesn't add up.
select
    order_id,
    total_item_value
from {{ ref('fct_sales') }}
where total_item_value <= 0