import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from transforms.vector_engine import Vectorizer

## @params: [JOB_NAME]
args = getResolvedOptions(sys.argv, ['JOB_NAME'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# 1. Sense: Read from the Landing Zone (S3)
datasource0 = glueContext.create_dynamic_frame.from_catalog(
    database = "mia_dod_catalog",
    table_name = "raw_telemetry"
)

# 2. Process: Apply Agentic Vectorization
# We use our custom library 'transforms'
vectorizer = Vectorizer()
vectorized_dyf = Map.apply(frame = datasource0, f = vectorizer.generate_embeddings)

# 3. Remember: Write to Aurora PostgreSQL (Vector Store)
glueContext.write_dynamic_frame.from_jdbc_conf(
    frame = vectorized_dyf,
    catalog_connection = "aurora_vector_conn",
    connection_options = {"dbtable": "nervous_system.telemetry_vectors", "database": "postgres"}
)

job.commit()