# Prompts the user for a number N and prints out the first N + 1 lines of Pascal triangle.



# Insert you code here
while True:
    num = int(input('Enter a nonnegative integer: '))
    try:
        if num < 0:
            raise ValueError
        break
    except ValueError:
        print('Incorrect input, try again')

array = [[0] * (2 * num + 3) for _ in range(num + 1)]
array[0][num + 1] = 1

def pascal(n):
    if n > 1:
        for i in range(1, n + 1):
            for j in range(1, 2 * n + 2):
                array[i][j] = array[i - 1][j - 1] + array[i - 1][j + 1]

def print_triangle():
    width = len(str(max(array[-1])))
    for i in range(0, num + 1):
        for j in range(1, 2 * num + 3):
            if array[i][j] == 0:
                if j <= num + i:
                    print(' ' * width, sep = '', end = '')
                else:
                    print('', end = '')
            else:
                print(' ' * (width - len(str(array[i][j]))), array[i][j], sep = '', end = '')
        print()

pascal(num)
print_triangle()
