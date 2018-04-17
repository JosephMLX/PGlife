import sys


n = input ('Input an integer: ')
try:
    n = int(n)
except ValueError:
    print ('Incorrect input, giving up.')
    sys.exit()
if n < 0:
    print ('Incorrect input, giving up.')
    sys.exit()

def find_perfect_number(n):
    perfect_number = []
    for i in range (1, n):
        if n % i == 0:
            perfect_number.append(i)
    sum = 0
    for j in perfect_number:
        sum += j
    if sum == n:
        return True
    else:
        return False

for i in range (1, n+1):
    if find_perfect_number(i):
         print (f'{i:d} is a perfect number.')
