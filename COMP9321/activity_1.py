import pandas as pd
import numpy as np

#csv_file = 'Demographic_Statistics_By_Zip_Code.csv'
def read_csv(csv_file):
    dataframe = pd.read_csv(csv_file)
    print(",".join(([col for col in dataframe])))
    for index, row in dataframe.iterrows():
        print(",".join([str(row[column]) for column in dataframe]))
    return dataframe
dataframe = read_csv('Demographic_Statistics_By_Zip_Code.csv')
print(dataframe)
dataframe.to_csv('new.csv', sep = ',', encoding = 'utf-8')
dataframe.to_html('new.html')

'''
def print_columns(dataframe):
    print(list(dataframe))

def print_rows(dataframe):
    for index, row in dataframe.iterrows():
        print()

print_columns(dataframe)
print_rows(dataframe)

def write_in_csv(dataframe, file):
    dataframe.to_csv(file, sep = ',', encoding = 'utf-8')
'''
