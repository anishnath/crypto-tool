# Python Functions
# A function is a block of code which only runs when it is called.

# 1. Defining a Function
def my_function():
    print("Hello from a function")

# 2. Calling a Function
my_function()

# 3. Function with Parameters
def greet(name):
    print(f"Hello, {name}!")

greet("Alice")
greet("Bob")

# 4. Docstrings
def square(n):
    """Returns the square of a number."""
    return n * n

print(f"Square of 5: {square(5)}")
print(f"Docstring: {square.__doc__}")
