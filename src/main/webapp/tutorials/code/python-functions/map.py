
def myfunc(n):
    return len(n)

x = map(myfunc, ('apple', 'banana', 'cherry'))

# Convert map object to list
print(list(x))


def calculate_square(n):
    return n * n

numbers = (1, 2, 3, 4)
result = map(calculate_square, numbers)
print(list(result))

# Using lambda
result_lambda = map(lambda a: a * a, numbers)
print(list(result_lambda))

# Multiple iterables
def add(a, b):
    return a + b

n1 = [1, 2, 3]
n2 = [4, 5, 6]
res = map(add, n1, n2)
print(list(res))
