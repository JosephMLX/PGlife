import sqlite3
import pandas as pd
import numpy as np
from pandas.io import sql

filename = 'Demographic_Statistics_By_Zip_Code.csv'
table_name = 'Demographic_Statistics'
database_file = 'Demographic_Statistics.db'

def read_csv(csv_file):
    df = pd.read_csv(csv_file)
    return df

def write_in_sqlite(dataframe, database_file, table_name):
    cnx = sqlite3.connect(database_file)
    sql.to_sql(dataframe, name = table_name, con = cnx)

def read_from_sqlite(database_file, table_name):
    cnx = sqlite3.connect(database_file)
    return sql.read_sql('select * from ' + table_name, cnx)

dataframe = read_csv(filename)

print("Creating database")
write_in_sqlite(dataframe, database_file, table_name)

print("Querying the database")
queried_df = read_from_sqlite(database_file, table_name)
