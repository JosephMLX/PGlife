min_i = 10
max_i = 76
max_j = 87
max_k = 98

for i in range(min_i, max_i + 1):
    i_digits = {i // 10, i % 10}
    if len(i_digits) != 2:
        continue
    for j in range(i + 1, max_j +1):
        i_and_j_digits = i_digits.union((j //10, j % 10))
        if len(i_and_j_digits) != 4:
            continue
        for k in range(j + 1, max_k + 1):
            i_and_j_and_k_digits = i_and_j_digits.union((k //10, k % 10))
            if len(i_and_j_and_k_digits) != 6:
                continue
            multiple = i * j * k

            if len(str(multiple)) != 6:
                break
            if set(int(element) for element in str(multiple)) == i_and_j_and_k_digits:
                print(f'{i} x {j} x {k} = {multiple} is a solution.')
