# Prompts the user for two numbers, say available_digits and desired_sum, and
# outputs the number of ways of selecting digits from available_digits
# that sum up to desired_sum.


import sys

# Insert your code here
def sum_of_digits(a_d, d_s):
    if d_s < 0:
        return 0
    if sum(a_d) == 0:
        if d_s == 0:
            return 1
        return 0
    return sum_of_digits(a_d[0:-1], d_s) + sum_of_digits(a_d[0:-1], d_s - a_d[-1])

available_digits = int(input('Input a number that we will use as available digits: '))
desired_sum = int(input('Input a number that represents the desired sum: '))
a_d_l = sorted(list(map(int, list(str(available_digits)))))
solutions = sum_of_digits(a_d_l, desired_sum)
if solutions == 1:
    print('There is a unique solution.')
elif solutions == 0:
    print('There is no solution.')
else:
    print(f'There are {solutions} solutions.')
