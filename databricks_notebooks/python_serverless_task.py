from data.addcol import with_status

df = (spark.createDataFrame(
  schema = ["first_name", "last_name", "email"],
  data = [
    ("paula", "white", "paula.white@example.com"),
    ("john", "baer", "john.baer@example.com")
  ]
))

new_df = with_status(df)

new_df.show()