-- Base product data from staging
with products as (
    select * from {{ ref('stg_olist_products') }}
),

-- Category name translations (Portuguese → English)
translations as (
    select * from {{ ref('stg_product_category_name_translation') }}
)

select
    -- Primary Key
    p.product_id,

    -- Category Names
    coalesce(t.product_category_name_english, p.product_category_name) as category_name,
    p.product_category_name as product_category_name_pt,

    -- Product Details (Use the names defined in stg_olist_products)
    p.product_name_length,
    p.product_description_length,
    p.product_photos_count,

    -- Physical Attributes
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

from products p
left join translations t
    on p.product_category_name = t.product_category_name