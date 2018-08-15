import pandas as pd
from copy import deepcopy


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
                        'Number of Games the country participated in_.1': 'Number of Games the country participated in total',
                        'Gold.1': 'Gold', 'Silver.1': 'Silver', 'Bronze.1': 'Bronze', 'Total.1': 'Total'})

def question_1():
    print('Question 1:\n')
    # select first five rows
    print(df.head(5), '\n')

def question_2():
    print('Question 2:\n')
    dataframe = deepcopy(df)
    # set index name to 'Country name' and select the first country
    dataframe.index.name = 'Country name'
    print(dataframe.head(1), '\n')

def question_3():
    print('Question 3:\n')
    dataframe = deepcopy(df)
    # drop one line, axis=1 denotes that we are referring to a column, not a row
    dataframe = df.drop('Rubish', axis=1)
    print(dataframe.head(5), '\n')

def question_4():
    print('Question 4:\n')
    dataframe = deepcopy(df)
    # drop the whole row as long as there is a NaN value
    dataframe = dataframe.dropna()
    print(dataframe.tail(10), '\n')

def question_5():
    print('Question 5:\n')
    dataframe = deepcopy(df)
    # delete all rows with NaN values
    dataframe = dataframe.dropna()
    # delete all commas and set the data type to integer
    dataframe['Gold_Summer'] = dataframe['Gold_Summer'].str.replace(',','')
    dataframe['Gold_Summer'] = dataframe['Gold_Summer'].astype(int)
    # sort the values in descending order
    dataframe = dataframe.sort_values(by='Gold_Summer', ascending=False)
    # selete the country won the most gold medals in summer games, except for 'total'
    print(dataframe.head(2).tail(1))

def question_6():
    print('Question 6:\n')
    dateframe = deepcopy(df)


def question_7():
    print('Question 7:\n')

if __name__ == '__main__':
    question_1()
    question_2()
    question_3()
    question_4()
    question_5()
    question_6()
    question_7()
    #question_8()
    #question_9()
