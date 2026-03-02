import os
import pandas as pd
from sqlalchemy import create_engine

# DB Connection string
DB_URL = "postgresql+psycopg2://olist_user:olist_password@postgres:5432/olist_db"

def load_csv_to_postgres(file_path, table_name):
    """
    Reads a specific Olist CSV and writes it to the PostgreSQL 'raw' schema.
    """
    engine = create_engine(DB_URL)
    
    # Read the local CSV file
    df = pd.read_csv(file_path)
    
    # Load into the 'raw' schema
    df.to_sql(
        name=table_name,
        con=engine,
        schema='raw',
        if_exists='replace',
        index=False
    )
    print(f"Success: {table_name} ingested into the raw schema.")