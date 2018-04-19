
def is_heterosquare(square):
    '''
    A heterosquare of order n is an arrangement of the integers 1 to n**2 in a square,
    such that the rows, columns, and diagonals all sum to DIFFERENT values.
    In contrast, magic squares have all these sums equal.
    
    
    >>> is_heterosquare([[1, 2, 3],\
                         [8, 9, 4],\
                         [7, 6, 5]])
    True
    >>> is_heterosquare([[1, 2, 3],\
                         [9, 8, 4],\
                         [7, 6, 5]])
    False
    >>> is_heterosquare([[2, 1, 3, 4],\
                         [5, 6, 7, 8],\
                         [9, 10, 11, 12],\
                         [13, 14, 15, 16]])
    True
    >>> is_heterosquare([[1, 2, 3, 4],\
                         [5, 6, 7, 8],\
                         [9, 10, 11, 12],\
                         [13, 14, 15, 16]])
    False
    '''
    n = len(square)
    if any(len(line) != n for line in square):
        return False
    all_sums = set()
    sum_columns = [0] * n
    sum_rows = [0] * n
    sum_diagonals = [0] * 2
    for i in range(n):
        for j in range(n):
            sum_columns[j] += square[i][j]
            sum_rows[i] += square[i][j]
            if i == j:
                sum_diagonals[0] += square[i][j]
            if i + j == n - 1:
                sum_diagonals[1] += square[i][j]
    all_sums = all_sums.union(set(sum_rows))
    all_sums = all_sums.union(set(sum_columns))
    all_sums = all_sums.union(set(sum_diagonals))
    if len(all_sums) != n * 2 + 2:
        return False
    return True
    # Insert your code here

# Possibly define other functions

    
if __name__ == '__main__':
    import doctest
    doctest.testmod()
