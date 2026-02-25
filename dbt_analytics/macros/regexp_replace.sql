{% macro normalize_characters(column_name) %}
    -- Normalize accented characters to their ASCII equivalents
    -- This improves consistency for joins, filtering, and grouping

    regexp_replace(
        -- Replace special characters related to "a"
        regexp_replace(
            -- Replace special characters related to "i"
            regexp_replace(
                -- Replace special characters related to "u"
                regexp_replace(
                    -- Replace special characters related to "e"
                    regexp_replace(
                        -- Replace special characters related to "o"
                        regexp_replace(
                            -- Input column to be normalized
                            {{ column_name }},
                            '[ãâàáä]', 'a'
                        ),
                        '[íîì]', 'i'
                    ),
                    '[úûùü]', 'u'
                ),
                '[éêèë]', 'e'
            ),
            '[óõôòö]', 'o'
        ),
        -- Replace special character "ç"
        '[ç]', 'c'
    )
{% endmacro %}
