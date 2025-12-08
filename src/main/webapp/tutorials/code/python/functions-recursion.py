# Recursion
# Recursion is a common mathematical and programming concept. It means that a function calls itself.

# 1. Factorial Example
def factorial(n):
    if n == 1:
        return 1
    else:
        return n * factorial(n-1)

print(f"Factorial of 5: {factorial(5)}")

# 2. Fibonacci Sequence
def fibonacci(n):
    if n <= 1:
        return n
    else:
        return(fibonacci(n-1) + fibonacci(n-2))

nterms = 10
print("Fibonacci sequence:")
for i in range(nterms):
    print(fibonacci(i), end=" ")
print() # Newline

# 3. Recursion Limit
import sys
print(f"Recursion Limit: {sys.getrecursionlimit()}")
