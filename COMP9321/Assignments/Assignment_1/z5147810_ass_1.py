import pandas as pd
import matplotlib.pyplot as plt
from copy import deepcopy

# make set to print each row in one line
pd.set_option('expand_frame_repr', False)
# get csv_1 and csv_2 into dataframes
df1 = pd.read_csv('Olympics_dataset1.csv', index_col=0, skiprows=1)
df2 = pd.read_csv('Olympics_dataset2.csv', index_col=0, skiprows=1)
# merge two dataframe by index
df = pd.merge(df1, df2, left_index=True, right_index=True)
# rename the columns to be more readable
df = df.rename(columns={'Number of Games the country participated in_x': 'Number of Games the country participated in summer games',
                        'Gold_x': 'Gold_Summer', 'Silver_x': 'Silver_Summer', 'Bronze_x': 'Bronze_Summer', 'Total_x': 'Total_Summer',
                        'Number of Games the country participated in_y': 'Number of Games the country participated in winter games',
                        'Gold_y': 'Gold_Winter', 'Silver_y': 'Silver_Winter', 'Bronze_y': 'Bronze_Winter', 'Total_y': 'Total_Winter',
                        'Number of Games the country participated in.1': 'Number of Games the country participated in total',
                        'Gold.1': 'Gold', 'Silver.1': 'Silver', 'Bronze.1': 'Bronze', 'Total.1': 'Total'})

df.columns = df.columns.str.replace(' ', '_')
df.index = df.index.str.replace(' ','_')
df.index = df.index.str[1:]
df = df.rename(index={'otals':'Totals'})

def transformat(dataframe):
    # transform data type of dataframe to string, deleting blank space between columns to print each row in one line 
    dataframe = dataframe.to_string()
    dataframe = dataframe.split('\n')
    for i in range(len(dataframe)):
        dataframe[i] = dataframe[i].split()
    for i in range(len(dataframe)):
        print(','.join(dataframe[i]))
    print('================================================================================================================================================================================================================================')

def question_1():
    print('Question 1:\n')
    dataframe = deepcopy(df)
    # select first five rows
    dataframe = df.head(5)
    transformat(dataframe)
    
def question_2():
    print('Question 2:\n')
    dataframe = deepcopy(df)
    # set index name to 'Country name' and select the first country
    dataframe.index.name = 'Country_name'
    dataframe = dataframe.head(1)
    transformat(dataframe)

def question_3():
    print('Question 3:\n')
    dataframe = deepcopy(df)
    # drop one line, axis=1 denotes that we are referring to a column, not a row
    dataframe = df.drop('Rubish', axis=1)
    dataframe = dataframe.head(5)
    transformat(dataframe)
    
def question_4():
    print('Question 4:\n')
    dataframe = deepcopy(df)
    # drop the whole row as long as there is a NaN value
    dataframe = dataframe.dropna()
    dataframe = dataframe.tail(10)
    transformat(dataframe)

def question_5():
    print('Question 5:\n')
    col = 'Gold_Summer'
    dataframe = deepcopy(df)
    # delete all rows with NaN values
    dataframe = dataframe.dropna()
    # delete all commas and set the data type to integer
    dataframe[col] = dataframe[col].str.replace(',','')
    dataframe[col] = dataframe[col].astype(int)
    # sort the values in descending order
    dataframe = dataframe.sort_values(by=col, ascending=False)
    # selete the country won the most gold medals in summer games, except for 'total'
    dataframe = dataframe.head(2).tail(1)
    transformat(dataframe)

def question_6():
    print('Question 6:\n')
    col_1 = 'Gold_Summer'
    col_2 = 'Gold_Winter'
    dataframe = deepcopy(df)
    dataframe = dataframe.dropna()
    dataframe[col_1] = dataframe[col_1].str.replace(',','')
    dataframe[col_1] = dataframe[col_1].astype(int)
    dataframe[col_2] = dataframe[col_2].str.replace(',','')
    dataframe[col_2] = dataframe[col_2].astype(int)
    # column 'diff' is the difference between gold medals in summer and winter games
    dataframe['Diff'] = (dataframe[col_1] - dataframe[col_2]).abs()
    dataframe = dataframe.sort_values(by='Diff', ascending=False)
    dataframe = dataframe.head(2).tail(1)
    transformat(dataframe)

def question_7():
    print('Question 7:\n')
    col = 'Total'
    dataframe = deepcopy(df)
    dataframe = dataframe.dropna()
    dataframe[col] = dataframe[col].str.replace(',','')
    dataframe[col] = dataframe[col].astype(int)
    dataframe = dataframe.sort_values(by=col, ascending=False)
    data_top = dataframe[1:6]
    data_bottom = dataframe.tail(5)
    # append last five rows to first five rows
    dataframe = data_top.append(data_bottom)
    transformat(dataframe)

def question_8():
    print('Question 8:\n')
    cols = ['Total_Summer', 'Total_Winter', 'Total']
    dataframe = deepcopy(df)
    dataframe = dataframe.dropna()
    for col in cols:
        dataframe[col] = dataframe[col].str.replace(',','')
        dataframe[col] = dataframe[col].astype(int)
    dataframe = dataframe.sort_values(by='Total', ascending=False)
    dataframe = dataframe[1:11]
    dataframe = dataframe[['Total_Winter', 'Total_Summer']]
    # horizontal stacked bar
    dataframe.plot.barh(stacked=True)
    plt.show()
  
def question_9():
    print('Question 9:\n')
    dataframe = deepcopy(df)
    dataframe = dataframe.dropna()
    countries = ['United_States_(USA)_[P]_[Q]_[R]_[Z]',
                 'Australia_(AUS)_[AUS]_[Z]',
                 'Great_Britain_(GBR)_[GBR]_[Z]',
                 'Japan_(JPN)', 'New_Zealand_(NZL)_[NZL]']
    cols = ['Gold_Winter', 'Silver_Winter', 'Bronze_Winter']
    # select countries in question
    dataframe = dataframe.ix[countries]
    dataframe = dataframe[cols]
    for col in cols:
        dataframe[col] = dataframe[col].str.replace(',','')
        dataframe[col] = dataframe[col].astype(int)
    dataframe = dataframe.rename(index = {'United_States_(USA)_[P]_[Q]_[R]_[Z]':'United States',
                                          'Australia_(AUS)_[AUS]_[Z]':'Australia',
                                          'Great_Britain_(GBR)_[GBR]_[Z]':'Great Britain',
                                          'Japan_(JPN)':'Japan',
                                          'New_Zealand_(NZL)_[NZL]':'New Zealand'})
    dataframe.plot.bar(fontsize=8)
    plt.show()

if __name__ == '__main__':
    question_1()
    question_2()
    question_3()
    question_4()
    question_5()
    question_6()
    question_7()
    question_8()
    question_9()
