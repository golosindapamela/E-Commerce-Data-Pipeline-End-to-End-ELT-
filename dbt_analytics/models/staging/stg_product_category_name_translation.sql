-- Select category translations to map Portuguese names to English.
select
    -- Product Category names in both languages
    {{ clean_string('product_category_name') }} as product_category_name,
    {{ clean_string('product_category_name_english') }} as product_category_name_english

from {{ source('olist_raw', 'product_category_name_translation') }}

-- Both columns are cleaned using the clean_string macro