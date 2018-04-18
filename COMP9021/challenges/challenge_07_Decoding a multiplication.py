'''
Decodes all multiplications of the form

                       *  *  *
                  x       *  *
                    ----------
                    *  *  *  *
                    *  *  *
                    ----------
                    *  *  *  *

such that the sum of all digits in all 4 columns is constant.
'''
def decoding (mutiple_1, mutiple_2, sum_1, sum_2, result):
    column_1 = mutiple_1%10 + mutiple_2%10 + sum_1%10 + result%10
    column_2 = mutiple_1//10%10 + mutiple_2//10 + sum_1//10%10 + sum_2%10 + result//10%10
    column_3 = mutiple_1//100 + sum_1//100%10 + sum_2//10%10 + result//100%10
    column_4 = sum_1//1000 + sum_2//100%10 + result//1000%10
    column_5 = sum_2//1000 + result//10000
    if column_1 == column_2 and column_2 == column_3 and column_3 == column_4:
        if column_5 == 0:
            return (True, column_1)
        else:
            return (False, column_1)
    else:
        return (False, column_1)

for i in range(100, 1000):
    for j in range(10, 100):
        sum_1 = i * (j % 10)
        sum_2 = i * (j // 10)
        result = i * j
        col = decoding(i, j, sum_1, sum_2,result)
        if col[0]:
            # col[0] = True
            # If it is True in def decoding.
            print (f'{i} * {j} = {result}, all columns adding up to {col[1]}.')
            # col[1] = column_1
