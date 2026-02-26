-- Select customer order reviews from the source table.
select distinct
    -- Primary and Foreign Keys
    review_id,
    order_id,

    -- Review Content and Score
    review_score,
    coalesce({{ clean_string('review_comment_title') }}, 'sem título') as review_comment_title,
    coalesce({{ clean_string('review_comment_message') }}, 'sem comentário') as review_comment_message,

    -- Timestamp Conversions (Casting text to timestamp)
    review_creation_date::timestamp as review_created_at,
    review_answer_timestamp::timestamp as review_answered_at

from {{ source('olist_raw', 'olist_order_reviews_dataset') }}

-- We intentionally retain all rows regardless of missing text,
-- as the review_score is essential for rating analysis.
-- Instead, we will fill the missing text values with a default string
-- like 'Sem Título' (No Title) and 'Sem Comentário' (No Comment).
