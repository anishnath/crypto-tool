# Lambda Functions
# A lambda function is a small anonymous function.
# Syntax: lambda arguments : expression

# 1. Basic Lambda
x = lambda a : a + 10
print(f"x(5): {x(5)}")

# 2. Multiple Arguments
multiply = lambda a, b : a * b
print(f"multiply(5, 6): {multiply(5, 6)}")

# 3. Why use Lambda? (Inside other functions)
def myfunc(n):
    return lambda a : a * n

doubler = myfunc(2)
tripler = myfunc(3)

print(f"Doubler(11): {doubler(11)}")
print(f"Tripler(11): {tripler(11)}")

# 4. With filter() and map()
numbers = [1, 2, 3, 4, 5, 6]

evens = list(filter(lambda x: x % 2 == 0, numbers))
print(f"Evens: {evens}")

squares = list(map(lambda x: x**2, numbers))
print(f"Squares: {squares}")
