# Python Try Except
# The 'try' block lets you test a block of code for errors.
# The 'except' block lets you handle the error.

# 1. Basic Try/Except
try:
    print(x)
except:
    print("An exception occurred: x is not defined")

# 2. Catching Specific Exceptions
try:
    print(10 / 0)
except NameError:
    print("Variable not defined")
except ZeroDivisionError:
    print("Cannot divide by zero")

# 3. Catching Multiple Exceptions
try:
    # num = int("abc")
    res = 10 / 0
except (ValueError, ZeroDivisionError):
    print("A Value or ZeroDivision error occurred")
