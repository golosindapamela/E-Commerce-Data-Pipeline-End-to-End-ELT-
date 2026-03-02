-- Create the 'raw' schema
-- This is where Python scripts will load the Olist CSV files.
CREATE SCHEMA IF NOT EXISTS raw;

-- Create the 'analytics' schema
-- This is where dbt will build Fact and Dimension tables (Star Schema).
CREATE SCHEMA IF NOT EXISTS analytics;

-- Optional: Set search path for the olist_user
ALTER ROLE olist_user SET search_path TO raw, analytics, public;