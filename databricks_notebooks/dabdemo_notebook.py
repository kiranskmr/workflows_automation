# Databricks notebook source

# COMMAND -----------

# Restart Python after installing the Python wheel.
dbutils.library.restartPython()

# COMMAND -----------

from data.addcol import with_status

df = (spark.createDataFrame(
  schema = ["first_name", "last_name", "email"],
  data = [
    ("paula", "white", "paula.white@example.com"),
    ("john", "baer", "john.baer@example.com")
  ]
))

new_df = with_status(df)

display(new_df)

# Expected output:
#
# +------------+-----------+-------------------------+---------+
# │ first_name │ last_name │ email                   │ status  │
# +============+===========+=========================+=========+
# │ paula      │ white     │ paula.white@example.com │ checked │
# +------------+-----------+-------------------------+---------+
# │ john       │ baer      │ john.baer@example.com   │ checked │
# +------------+-----------+-------------------------+---------+