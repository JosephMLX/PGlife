# import modules here
# import pandas as pd
import numpy as np

EMPTY = -1
################# Question 1 #################


def sse(arr):
    if len(arr) == 0:
        return 0.0

    avg = np.average(arr)
    val = sum([(x - avg) ** 2 for x in arr])
    return val


def init_arr(arr):
    zeros = len(arr) - 1
    start = len(arr) - 1
    for i in range(len(arr)):
        for j in range(start, start + zeros):
            arr[i][j] = 0
        start -= 1
    return arr


def v_opt_dp(x, num_bins):  # do not change the heading of the function
    matrix = []
    matrix_index = []
    bins = []
    for i in range(num_bins):
        matrix.append([EMPTY] * len(x))
    for i in range(num_bins):
        matrix_index.append([EMPTY] * len(x))

    init_arr(matrix)
    init_arr(matrix_index)
    for i in range(num_bins):
        for j in range(len(x)):
            # if matrix[i][j] != -1:
            if i == 0:
                matrix[i][j] = sse(x[j:])
            elif (num_bins-i-j) < 2 and len(x)-j-i > 0:
                candidates = []
                for k in range(j, len(x)):
                    tmp = sse(x[j: k+1])
                    if k < len(x) - 1:
                        candidates.append(tmp + matrix[i-1][k+1])
                matrix[i][j] = min(candidates)
                # import pdb; pdb.set_trace()
                matrix_index[i][j] = candidates.index(min(candidates)) + j + 1

        if matrix[i][j] == 0:
            matrix[i][j] = int(matrix[i][j])

    start = matrix_index[-1][0]
    bins.append(x[0:start])
    end = start
    for i in range(num_bins - 2, 0, -1):
        tmp = matrix_index[i][start]
        start = tmp
        bins.append(x[end:start])
        end = start
    bins.append(x[end:])
    if num_bins == 1:
        bins = x
    return matrix, bins
