# Filename: addcol.py test
import pyspark.sql.functions as F

def with_status(df):
  return df.withColumn("status", F.lit("checked"))