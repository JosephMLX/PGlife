import sys
from math import sqrt


def f(a, b):
    '''
    The prime numbers between 2 and 12 (both included) are: 2, 3, 5, 7, 11
    The gaps between successive primes are: 0, 1, 1, 3.
    Hence the maximum gap is 3.
    
    Won't be tested for b greater than 10_000_000
    
    >>> f(3, 3)
    The maximum gap between successive prime numbers in that interval is 0
    >>> f(3, 4)
    The maximum gap between successive prime numbers in that interval is 0
    >>> f(3, 5)
    The maximum gap between successive prime numbers in that interval is 1
    >>> f(2, 12)
    The maximum gap between successive prime numbers in that interval is 3
    >>> f(5, 23)
    The maximum gap between successive prime numbers in that interval is 3
    >>> f(20, 106)
    The maximum gap between successive prime numbers in that interval is 7
    >>> f(31, 291)
    The maximum gap between successive prime numbers in that interval is 13
    '''
    if a <= 0 or b < a:
        sys.exit()
    max_gap = 0
    # Insert your code here
    def prime(a, b):
        primelist = []
        for i in range(a ,b + 1):
            flag = 1
            for j in range(2, int(sqrt(i)) + 1):
                if i % j == 0:
                    flag = 0
            if flag == 1:
                primelist.append(i)
        return primelist
    def gap(a, b):
        primelist = sorted(prime(a, b))
        max_gap = 0
        for i in range(1, len(primelist)):
            gap = primelist[i] - primelist[i - 1]
            if gap > max_gap:
                max_gap = gap
        return max_gap
    max_gap = gap(a, b)
    if max_gap >= 1:
        max_gap -= 1
    print('The maximum gap between successive prime numbers in that interval is', max_gap)


if __name__ == '__main__':
    import doctest
    doctest.testmod()
