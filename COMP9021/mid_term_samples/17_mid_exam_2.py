odd = [1,3,5,7,9]
even = [0,2,4,6,8]

for i in range(100,1000):
    if i % 10 not in even:
        continue
    if (i // 10 % 10) not in even:
        continue
    if (i // 100 % 10) not in odd:
        continue
    for j in range(10, 100):
        if j % 10 not in even:
            continue
        if (j // 10 % 10) not in even:
            continue
        middle_1 = i * (j % 10)
        if len(str(middle_1)) != 4:
            continue
        if middle_1 % 10 not in even:
            continue
        if (middle_1 // 10 % 10) not in even:
            continue
        if (middle_1 // 100 % 10) not in odd:
            continue
        if (middle_1 // 1000 % 10) not in even:
            continue
        middle_2 = i * (j // 10 % 10)
        if len(str(middle_2)) != 3:
            continue
        if middle_2 % 10 not in even:
            continue
        if (middle_2 // 10 % 10) not in odd:
            continue
        if (middle_2 // 100 % 10) not in even:
            continue
        result = middle_1 + middle_2 * 10
        if len(str(result)) != 4:
            continue
        if result % 10 not in even:
            continue
        if (result // 10 % 10) not in even:
            continue
        if (result // 100 % 10) not in odd:
            continue
        if (result // 1000 % 10) not in odd:
            continue

        print(f'{i}')
        print(f'x{j}')
        print(f'----')
        print(f'{middle_1}')
        print(f'{middle_2}')
        print(f'----')
        print(f'{result}')
