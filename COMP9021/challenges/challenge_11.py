num = eval(input('Enter strictly positive number: '))
try:
    if num <= 0:
        raise ValueError
except ValueError:
    print('Wrong input, giving up.')

array = [[0] * (2 * num - 1) for _ in range(num)]
# set a series of lists whose lengths are the length of the last line

def triangle_of_chr(n):
    center = n - 1
    array[0][center] = 65
    if n != 1:
        for i in range(1, n):
            center_of_last_line = array[i-1][center]
            array[i][center] = center_of_last_line + 1 + i
            left_and_right = array[i][center] - 1
            move = 1
            # E.g center of the first line is 65, the center of the second
            # line is 67, move 67 to 66 for both sides
            while left_and_right > center_of_last_line:
                array[i][center - move] = left_and_right
                array[i][center + move] = left_and_right
                left_and_right -= 1
                move += 1
            for j in range(2 * n -1):
                while array[i][j] > 90:
                    array[i][j] -= 26
    return array
def print_triangle():
    for i in range(num):
        for j in range(2 * num - 1):
            if array[i][j] == 0:
                if j < num - i:
                    print(' ',end = '')
                else:
                    print('',end = '')
            else:
                print(chr(array[i][j]),end = '')
        print()
triangle_of_chr(num)
print_triangle()
