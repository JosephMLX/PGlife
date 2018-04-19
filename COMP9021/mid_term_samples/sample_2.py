import sys
from math import factorial


def f(n):
    '''
    >>> f(0)
    0 factorial is 1
    It has 1 digit, the trailing 0's excepted
    >>> f(4)
    4 factorial is 24
    It has 2 digits, the trailing 0's excepted
    >>> f(6)
    6 factorial is 720
    It has 2 digits, the trailing 0's excepted
    >>> f(10)
    10 factorial is 3628800
    It has 5 digits, the trailing 0's excepted
    >>> f(20)
    20 factorial is 2432902008176640000
    It has 15 digits, the trailing 0's excepted
    >>> f(30)
    30 factorial is 265252859812191058636308480000000
    It has 26 digits, the trailing 0's excepted
    >>> f(40)
    40 factorial is 815915283247897734345611269596115894272000000000
    It has 39 digits, the trailing 0's excepted
    '''
    if n < 0:
        sys.exit()
    def factorial(n):
        if n <= 1:
            return 1
        if n > 1:
            result = 1
            for i in range(1, n + 1):
                result *= i
            return result
    n_factorial = factorial(n)
    new_n_factorial = n_factorial
    while True:
        if new_n_factorial % 10 == 0:
            new_n_factorial = new_n_factorial // 10
        else:
            break
    str_new_n_factorial = str(new_n_factorial)
    nb_of_digits_excluding_the_trailing_0s = len(str_new_n_factorial)
    # Insert your code here

    print(f'{n} factorial is {n_factorial}')
    if nb_of_digits_excluding_the_trailing_0s == 1:
        print(f'It has 1 digit, the trailing 0\'s excepted')
    else:
        print(f'It has {nb_of_digits_excluding_the_trailing_0s} digits, the trailing 0\'s excepted')


if __name__ == '__main__':
    import doctest
    doctest.testmod()
