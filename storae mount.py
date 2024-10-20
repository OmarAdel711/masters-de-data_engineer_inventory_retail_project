# Databricks notebook source
configs = {
    "fs.azure.account.auth.type": "CustomAccessToken",
    "fs.azure.account.custom.token.provider.class": spark.conf.get("spark.databricks.passthrough.adls.gen2.tokenProviderClassName")
}

# Mount ADLS Gen2 to Databricks file system
dbutils.fs.mount(
    source = "abfss://bronze@masterssg.dfs.core.windows.net/",
    mount_point = "/mnt/bronze",
    extra_configs = configs)

# COMMAND ----------

dbutils.fs.ls("/mnt/bronze")

# COMMAND ----------

dbutils.fs.ls("/mnt/bronze/sales")

# COMMAND ----------

dbutils.fs.ls("/mnt/bronze/production")

# COMMAND ----------

dbutils.fs.mount(
    source = "abfss://silver@masterssg.dfs.core.windows.net/",
    mount_point = "/mnt/silver",
    extra_configs = configs)

dbutils.fs.mount(
    source = "abfss://gold@masterssg.dfs.core.windows.net/",
    mount_point = "/mnt/gold",
    extra_configs = configs)

