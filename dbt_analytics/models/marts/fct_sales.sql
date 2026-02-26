-- Base orders data for status and timestamps
with orders as (
    select * from {{ ref('stg_olist_orders') }}
),

-- Order line items for pricing and foreign keys (The primary grain of the fact table)
order_items as (
    select * from {{ ref('stg_olist_order_items') }}
),

-- Aggregate payments to order level to prevent row duplication (fan-out)
order_payments as (
    select 
        order_id,
        sum(total_payment_amount) as total_order_value,
        max(payment_installments) as max_installments
    from {{ ref('stg_olist_order_payments') }}
    group by 1
),

-- Aggregate review scores to order level
order_reviews as (
    select
        order_id,
        avg(review_score) as avg_review_score
    from {{ ref('stg_olist_order_reviews') }}
    group by 1
)

select
    -- Degenerate Dimension (Identifies the transaction)
    oi.order_id,
    o.order_status,

    -- Foreign Keys (Links to Dimension Tables)
    oi.product_id,
    oi.seller_id,
    o.customer_id,
    o.order_purchase_at::date as order_date_key,

    -- Item-level metrics (Facts) 
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) as total_item_value,

    -- Order-level metrics 
    p.total_order_value,
    p.max_installments,
    
    -- Customer Satisfaction 
    r.avg_review_score,

    -- Timestamps and Logistics Performance 
    o.order_purchase_at,
    o.order_delivered_customer_at,
    -- PostgreSQL function to calculate lead time 
    age(o.order_delivered_customer_at, o.order_purchase_at) as actual_delivery_time

from order_items oi
inner join orders o 
    on oi.order_id = o.order_id
left join order_payments p 
    on o.order_id = p.order_id
left join order_reviews r
    on o.order_id = r.order_id