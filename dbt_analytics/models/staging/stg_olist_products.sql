-- Select product information, including descriptions and sizes, from the source table.
select
    -- Primary Key
    product_id,

    -- Product Category (Handling nulls, 'Outros' (Others), and cleaning strings)
    coalesce({{ clean_string('product_category_name') }}, 'Outros') as product_category_name,

    -- Product Metadata (Fixing 'lenght' typo, Clarifying 'qty')
    product_name_lenght as product_name_length,
    product_description_lenght as product_description_length,
    product_photos_qty as product_photos_count,

    -- Physical Attributes
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

from {{ source('olist_raw', 'olist_products_dataset') }}

-- we will fill the missing product_category_name values with 'Outros' (Others)
-- Keeping nulls for data integrity.
