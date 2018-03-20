from math import sqrt

#n = int(input('Enter an interger: '))
def isPrime(m):
    for n in range(2,int(sqrt(m))+1):
        if not m % n:
            return False
    return True

print ('The solutions are:\n')
for i in range(10000,100000,1):
    if isPrime(i) is True and isPrime(i+2) is True and isPrime(i+6) is True and isPrime(i+12) is True and isPrime(i+20) is True and isPrime(i+30) is True:
        if isPrime(i+14) is False and isPrime(i+16) is False and isPrime(i+18) is False:
            if isPrime(i+22) is False and isPrime(i+24) is False and isPrime(i+26) is False:
                print (i,i+2,i+6,i+12,i+20,i+30,sep='  ',end='\n')
