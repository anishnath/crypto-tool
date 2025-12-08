# Python Raising Exceptions
# As a Python developer you can choose to throw an exception if a condition occurs.
# To throw (or raise) an exception, use the 'raise' keyword.

# 1. Raise an Exception
x = -1

if x < 0:
    # raise Exception("Sorry, no numbers below zero")
    print("Exception raised (commented out to prevent crash)")

# 2. Raise a TypeError
x = "hello"

if not type(x) is int:
    # raise TypeError("Only integers are allowed")
    print("TypeError raised (commented out)")

# 3. Custom Exceptions (Inheritance)
class MyCustomError(Exception):
    pass

# raise MyCustomError("This is a custom error")
print("Custom Error defined")
