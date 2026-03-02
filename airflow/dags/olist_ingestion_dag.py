from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import os
import sys

# Add the scripts folder to the Python path so we can import custom modules
sys.path.append('/opt/airflow/scripts')
from ingest_to_postgres import load_csv_to_postgres

with DAG(
    'olist_data_ingestion',
    description='Ingest Olist CSV files into a designated "raw data landing" directory/table in PostgreSQL.',
    start_date=datetime(2026, 2, 20),
    schedule_interval=None, # Set to None for manual runs
    catchup=False,
    tags=['olist', 'ingest']
) as dag:

    DATA_DIR = '/opt/airflow/data'
    # List all CSV files in the data directory
    csv_files = [f for f in os.listdir(DATA_DIR) if f.endswith('.csv')]

    # Create one PythonOperator per CSV file
    for csv_file in csv_files:
        t_name = csv_file.replace('.csv', '') # Table name from file name
        f_path = os.path.join(DATA_DIR, csv_file) # Full path to the CSV

        PythonOperator(
            task_id=f'ingest_{t_name}', # Task ID dynamically generated
            python_callable=load_csv_to_postgres,
            op_kwargs={'file_path': f_path, 'table_name': t_name}
        )