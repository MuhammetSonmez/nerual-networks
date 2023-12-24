def exp(x, terms=10):
    result = 1.0
    factorial = 1.0

    for i in range(1, terms + 1):
        factorial *= i
        result += (x ** i) / factorial

    return result

e = exp(1)
