{% macro clean_string(column_name) %}
    -- Standardizes text by trimming spaces, converting to lowercase,
    -- and replacing underscores with spaces
    lower(
        replace(
            trim({{ column_name }}),
            '_',
            ' '
        )
    )
{% endmacro %}
