from pyspark.sql import DataFrame, functions as F

def lowercase_names(df:DataFrame)->DataFrame:
 
    for col in df.columns:
        df = df.withColumnRenamed(col, col.lower())
    return df 

def uppercase_names(df:DataFrame)->DataFrame:

    for col in df.columns:
        df = df.withColumnRenamed(col, col.upper())
    return df 

def metadata(df:DataFrame, field_dict:dict)->DataFrame:
    for pair in field_dict.items():
        df = df.withColumn(pair[0], F.lit(pair[1]))
    return df