from random import seed, randint

arg_of_seed = input('Input a seed for the random number generator: ')
try:
    arg_of_seed = int(arg_of_seed)
except ValueError:
    print ('Input is not an integer, giving up')
    sys.exit()
nb_of_elements = input('How many elements do you want to generate? ')
try:
    nb_of_elements = int(nb_of_elements)
except ValueError:
    print('Input is not an integer, giving up')
    sys.exit()
seed(arg_of_seed)
L = [randint(0,99) for _ in range (nb_of_elements)]

print ('\nThe list is ', L)
max_element = 0
for e in L:
    if e > max_element:
        max_element = e
min_element = 100
for e in L:
    if e < min_element:
        min_element = e
print ('\nThe difference between the maximum and minimum in this list is ', max_element - min_element)
print ('Confirming with builtin operation:', max(L) - min(L))

print ()
