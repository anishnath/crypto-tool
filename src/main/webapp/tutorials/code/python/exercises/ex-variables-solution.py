# Exercise: Variable Swap - SOLUTION
# Task: Swap the values of two variables without using a third variable

a = 10
b = 20

print(f"Before swap: a = {a}, b = {b}")

# Solution: Python's tuple unpacking
a, b = b, a

print(f"After swap: a = {a}, b = {b}")

# Output:
# Before swap: a = 10, b = 20
# After swap: a = 20, b = 10
