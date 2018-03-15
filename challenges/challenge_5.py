import sys
from math import factorial

num_N = input ('Input a nonnegative integer: ')
try:
    num_N = int(num_N)
except ValueError:
    print ('Incorrect input, giving up.')
    sys.exit()
if num_N < 0:
    print ('Incorrect input, giving up.')
    sys.exit()

result = factorial(num_N)

def first_method(n):
    num_of_zero = 0
    while n % 10 == 0:
        num_of_zero += 1
        n = n // 10
    return num_of_zero

def second_method(n):
    num_of_zero = 0
    str_N = str(n)
    while str_N[-1] == '0':
        num_of_zero += 1
        str_N = str_N[:-1]
    return num_of_zero

def third_method_2(n):
    num_of_zero = 0
    for i in range (1, n+1):
        num_of_zero += third_method_1(i)
    return num_of_zero

def third_method_1(n):
    num_of_zero = 0
    while (n % 5 == 0):
        num_of_zero += 1
        n //= 5
    return num_of_zero

def my_method(n):
    num = 0
    for i in range (1, n+1):
        if i % 5 == 0:
            num += 1
            if i % 25 == 0:
                num += 1
                if i % 125 == 0:
                    num += 1
                    if i % 625 == 0:
                        num += 1
    return num

print (f'Computing the number of trailing 0s in {num_N}! by dividing by 10 for long enough:',first_method(result))
print (f'Computing the number of trailing 0s in {num_N}! by converting it into a string:',second_method(result))
print (f'Computing the number of trailing 0s in {num_N}! the smart way:',my_method(num_N))
