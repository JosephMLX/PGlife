def factoria(n):
    if n <= 1:
        return 1
    if n > 1:
        return n * factoria(n - 1)


print(factoria(5))
