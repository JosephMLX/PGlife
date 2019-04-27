import numpy as np
import pandas as pd

def sigmoid(inX):
    return 1.0 / (1 + np.exp(-inX))


def logistic_regression(data, labels, weights, num_epochs, learning_rate): # do not change the heading of the function
    data_matrix = np.mat(data)
    data_matrix = np.c_[np.ones(len(data_matrix)), data_matrix]
    # print(data_matrix)
    label_matrix = np.mat(labels).transpose()
    # print(label_matrix)
    weights = np.mat(weights).T
    for i in range(num_epochs):
        import pdb; pdb.set_trace()
        h1 = sigmoid(data_matrix * weights)
        error1 = label_matrix - h1
        weights = weights + learning_rate * data_matrix.transpose() * error1
    return weights

data_file='./asset/a'
raw_data = pd.read_csv(data_file, sep=',')
raw_data.head()

raw_data = pd.read_csv(data_file, sep=',')
labels=raw_data['Label'].values
data=np.stack((raw_data['Col1'].values,raw_data['Col2'].values), axis=-1)

## Fixed Parameters. Please do not change values of these parameters...
weights = np.zeros(3) # We compute the weight for the intercept as well...
num_epochs = 50000
learning_rate = 50e-5

coefficients=logistic_regression(data, labels, weights, num_epochs, learning_rate)
print(coefficients)