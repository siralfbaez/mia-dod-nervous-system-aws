import sys
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from transforms.vector_engine import Vectorizer

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Initialize our custom "Nervous System" Vectorizer
vectorizer = Vectorizer()

# Process data and store in Aurora Vector Store
# (Mapping logic we defined in main_pipeline.py)

job.commit()