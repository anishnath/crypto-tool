# Calling Functions in Python

# 1. Basic function call
print("=== Basic Calls ===")
def say_hello():
    print("Hello!")

# Call with parentheses - executes the function
say_hello()

# Without parentheses - reference to function object
print(f"Function object: {say_hello}")
print(f"Type: {type(say_hello)}")
print()

# 2. Calling with arguments
print("=== With Arguments ===")
def add(a, b):
    return a + b

# Positional arguments
result = add(3, 5)
print(f"add(3, 5) = {result}")

# Named/keyword arguments
result = add(a=10, b=20)
print(f"add(a=10, b=20) = {result}")

# Mixed (positional first, then keyword)
result = add(7, b=3)
print(f"add(7, b=3) = {result}")
print()

# 3. Storing function results
print("=== Storing Results ===")
def multiply(x, y):
    return x * y

# Store result in variable
product = multiply(6, 7)
print(f"Product: {product}")

# Use result directly in expressions
total = multiply(3, 4) + multiply(5, 2)
print(f"3*4 + 5*2 = {total}")

# Pass result to another function
def double(n):
    return n * 2

doubled = double(multiply(2, 3))
print(f"double(multiply(2, 3)) = {doubled}")
print()

# 4. Functions calling other functions
print("=== Functions Calling Functions ===")
def square(n):
    return n * n

def sum_of_squares(a, b):
    return square(a) + square(b)

result = sum_of_squares(3, 4)
print(f"3² + 4² = {result}")
