-- Generate continuous daily date series using dbt_utils
with date_series as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2016-01-01' as date)",
        end_date="cast('2020-12-31' as date)"
    ) }}

),

-- Derive calendar attributes based on the outlined star schema
final as (

    select
        -- Primary Key (Date)
        date_day,

        -- Temporal Hierarchies
        extract(year from date_day) as date_year,
        extract(month from date_day) as date_month,
        extract(quarter from date_day) as date_quarter,
        extract(day from date_day) as date_day_of_month,

        -- Formatted Names for Reporting
        to_char(date_day, 'Month') as month_name,
        to_char(date_day, 'Day') as day_name,

        -- Weekend Flag for Sales Pattern Analysis
        -- (ISO Saturday=6, Sunday=7)
        case 
            when extract(isodow from date_day) in (6, 7) then true 
            else false 
        end as is_weekend

    from date_series
)

-- Final date dimension output
select * from final