str_1 = input('Please input the first string: ')
str_2 = input('Please input the second string: ')
str_3 = input('Please input the third string: ')
if len(str_1) > len(str_2):
    if len(str_1) > len(str_3):
        long = str_1
        if len(str_2) > len(str_3):
            mid, short = str_2, str_3
        else:
            mid, short = str_3, str_2
    else:
        long, mid, short = str_3, str_1, str_2
else:
    if len(str_2) > len(str_3):
        long = str_2
        if len(str_1) > len(str_3):
            mid, short = str_1, str_3
        else:
            mid, short = str_3, str_1
    else:
        long, mid, short = str_3, str_2, str_1

if len(str_1) == len(long):
    string = 'first'
if len(str_2) == len(long):
    string = 'second'
if len(str_3) == len(long):
    string = 'third'
def merge(l, m, s):
    if l[0] == m[0]:
        l = l[1:]
        m = m[1:]
        if l == '':
            return True
        elif m == '':
            if l == s:
                return True
        return merge(l, m, s)
    elif l[0] == s[0]:
        l = l[1:]
        s = s[1:]
        if l == '':
            return True
        elif s == '':
            if l == m:
                return True
        return merge(l, m, s)
    return False
if merge(long, mid, short) is True:
    print(f'The {string} string can be obtained by merging the other two.')
else:
    print('No solution')
