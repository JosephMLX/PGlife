# Finds all triples of consecutive positive three-digit integers
# each of which is the sum of two squares.


# Insert you code here
from math import sqrt
from collections import defaultdict

max = int(sqrt(1000))
l = defaultdict(list)

for i in range(0, max):
    for j in range(i, max + 1):
        sum = i ** 2 + j ** 2
        if 99 < sum < 1000:
            l[sum] = (i, j)

all_sum = []
for i in l.keys():
    all_sum.append(int(i))
all_sum = sorted(all_sum)

for i in all_sum:
    if i + 1 in all_sum and i + 2 in all_sum:
        print(f'({i}, {i + 1}, {i + 2}) (equal to ({l[i][0]}^2+{l[i][1]}^2,'
                                        f' {l[i+1][0]}^2+{l[i+1][1]}^2, {l[i+2][0]}^2+{l[i+2][1]}^2)) is a solution.')
