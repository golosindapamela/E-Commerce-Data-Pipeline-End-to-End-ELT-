from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

# Define the DAG
with DAG(
    'olist_ecommerce_transformation',
    description='Full orchestration for Olist: Ingest -> dbt Run -> dbt Test',
    start_date=datetime(2026, 2, 20),
    schedule_interval='@daily',  # Scheduled to run once every day
    catchup=False,
    tags=['olist', 'orchestration'],
) as dag:

    # Data Ingestion Task
    # Updated to match the path in your docker-compose volumes
    ingest_data = BashOperator(
        task_id='ingest_olist_data',
        bash_command='python3 /opt/airflow/scripts/ingest_to_postgres.py'
    )

    # dbt Run
    # Updated to the path where dbt is mounted for Airflow
    dbt_run = BashOperator(
        task_id='dbt_run_models',
        bash_command='cd /opt/airflow/dbt && dbt run --profiles-dir .'
    )

    # dbt Test
    # Updated to the path where dbt is mounted for Airflow
    dbt_test = BashOperator(
        task_id='dbt_test_models',
        bash_command='cd /opt/airflow/dbt && dbt test --profiles-dir .'
    )

    # Define Dependencies
    ingest_data >> dbt_run >> dbt_test