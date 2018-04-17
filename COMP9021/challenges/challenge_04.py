import sys
from random import seed, randint
from math import sqrt
from statistics import mean, median, pstdev

# Prompt the user for a seed for the random number generator,
# and for a strictly positive number, nb_of_elements.
#
# See previous challenge.
arg_for_seed = input ('Input a seed for the random number generator: ')
try:
    arg_for_seed = int(arg_for_seed)
except ValueError:
    print ('Input is not an integer, giving up.')
    sys.exit()

nb_of_elements = input ('How many elements do you want to generate? ')
try:
    nb_of_elements = int(nb_of_elements)
except ValueError:
    print ('Input is not an integer, giving up.')
    sys.exit()
if nb_of_elements <= 0:
    print ('Input should be strictly positive, giving up.')
    sys.exit()

# Generate a list of nb_of_elements random integers between -50 and 50.
#
# See previous challenge.
seed(arg_for_seed)
L = [randint(-50,51) for _ in range(nb_of_elements)]

# Print out the list, compute the mean, standard deviation and median of the list,
# and print them out.
#
print (f'\nThe list is: {L}')
print ()
sort_L = sorted(L)
mean_sum = 0
for i in range (nb_of_elements):
    mean_sum = mean_sum + sort_L[i]
mean_L = mean_sum / nb_of_elements
print (f'The mean is {mean_L:0.2f}.')
if nb_of_elements % 2 == 0:
    median_L = (sort_L[nb_of_elements//2] + sort_L[nb_of_elements//2-1]) / 2
else:
    median_L = (sort_L[(nb_of_elements-1)//2])
print (f'The median is {median_L:0.2f}.')
standardDeviation_sum = 0
for i in range(nb_of_elements):
    standardDeviation_sum += (sort_L[i] - mean_L) ** 2
standardDeviation = (standardDeviation_sum / nb_of_elements) ** 0.5
print (f'The standard deviation is {standardDeviation:0.2f}.')
print ('\nConfirming by XXX')
print (f'The mean is {mean(L):0.2f}.')
print (f'The median is {median(L):0.2f}.')
print (f'The standard deviation is {pstdev(L):0.2f}.')
# To compute the mean, use the builtin sum() function.
# To compute the standard deviation, use sum(), the sqrt() from the math module,
# and the ** operator (exponentiation).
# To compute the median, first sort the list.
#
# The following interaction at the python prompt gives an idea of how these functions work:
# >>> from math import sqrt
# >>> sqrt(16)
# 4.0
# >>> L = [2, 1, 3, 4, 0, 5]
# >>> L.sort()
# >>> L
# [0, 1, 2, 3, 4, 5]
# >>> L = [2, 1, 3, 4, 0, 5]
# >>> sum(L)
# 15
# >>> sum(x ** 2 for x in L)
# 55
# >>> L.sort()
# >>> L
# [0, 1, 2, 3, 4, 5]
#
# Then use the imported functions from the statistics module to check the results.
