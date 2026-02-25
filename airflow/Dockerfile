FROM apache/airflow:2.7.1

# Switch to root to install system-level dependencies
USER root
RUN apt-get update && apt-get install -y git && apt-get clean

# Switch back to the airflow user for security and library installation
USER airflow

# Copy and install Python dependencies (pandas, dbt-postgres, etc.)
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt