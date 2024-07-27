from pyspark.sql import Row
from databricks.connect import DatabricksSession

import pandas as pd
from datetime import datetime

from src.utils import *


def test_lowercase_names():
    test_data = [
        {
            "ID": 1,
            "First_Name": "Kiran",
            "Last_Name": "Sreekumar",
            "Age": 35
        },
        {
            "ID": 2,
            "First_Name": "Sachin",
            "Last_Name": "Tendulkar",
            "Age": 45
        }
    ]

    spark = DatabricksSession.builder.getOrCreate()
    test_df = spark.createDataFrame(map(lambda x: Row(**x), test_data))

    # ACT TEST
    output_df = lowercase_names(test_df)

    output_df_as_pd = output_df.toPandas()

    expected_output_df = pd.DataFrame({
        "id": [1, 2],
        "first_name": ["Kiran", "Sachin"],
        "last_name": ["Sreekumar", "Tendulkar"],
        "age": [35, 45]
    })
    # ASSERT
    pd.testing.assert_frame_equal(left=expected_output_df,right=output_df_as_pd, check_exact=True)

def test_uppercase_names():
    # ASSEMBLE
    test_data = [
        {
            "ID": 1,
            "First_Name": "Kiran",
            "Last_Name": "Sreekumar",
            "Age": 35
        },
        {
            "ID": 2,
            "First_Name": "Sachin",
            "Last_Name": "Tendulkar",
            "Age": 45
        }
    ]

    spark = DatabricksSession.builder.getOrCreate()
    test_df = spark.createDataFrame(map(lambda x: Row(**x), test_data))
    
    # ACT 
    output_df = uppercase_names(test_df)

    output_df_as_pd = output_df.toPandas()

    expected_output_df = pd.DataFrame({
        "ID": [1, 2],
        "FIRST_NAME": ["Kiran", "Sachin"],
        "LAST_NAME": ["Sreekumar", "Tendulkar"],
        "AGE": [35, 45]
    })
    # ASSERT 
    pd.testing.assert_frame_equal(left=expected_output_df,right=output_df_as_pd, check_exact=True)


