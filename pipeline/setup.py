from setuptools import setup, find_packages

setup(
    name="mia_dod_pipeline",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        "psycopg2-binary",
        "pgvector",
        "openai",
        "boto3"
    ],
    description="Custom ETL and Agentic Library for MIA-DoD AWS Nervous System",
)