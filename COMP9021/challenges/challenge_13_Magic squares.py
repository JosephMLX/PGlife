# Given a positive integer n, a magic square of order n is a matrix of size n x n
# that stores all numbers from 1 up to n^2 and such that the sum of the n rows,
# the sum of the n columns, and the sum of the two diagonals is constant,
# hence equal to n(n^2+1)/2.
def print_square(square):
	for i in range(len(square)):
		for j in range(len(square)):
			if j < len(square) - 1:
				print(square[i][j], end = ' ')
			else:
				print(square[i][j], end = '')
		print()
	# Replace pass above with your code

def is_magic_square(square):
    n = len(square)
    sum = int(n * (n ** 2  + 1) / 2)
    sum_row = [0] * n
    sum_column = [0] * n
    sum_diagonal = [0] * 2
    set_n = set(range(1, n ** 2 + 1))
    set_square = set()
    for i in range(n):
        for j in range(n):
            set_square.add(square[i][j])
            sum_row[i] += square[i][j]
            sum_column[j] += square[i][j]
            if i == j:
                sum_diagonal[0] += square[i][j]
            if i + j == n - 1:
                sum_diagonal[1] += square[i][j]
    if set_square != set_n:
        return False
    for e in sum_row:
        if e != sum:
            return False
    for e in sum_column:
        if e != sum:
            return False
    for e in sum_diagonal:
        if e != sum:
            return False
    return True


	# Replace pass above with your code

# Possibly define other functions
