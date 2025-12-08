# Functions in Python

def greet(name):
    """Simple greeting function"""
    return f"Hello, {name}!"

def add(a, b):
    """Add two numbers"""
    return a + b

def calculate_area(length, width=1):
    """Calculate area with default width"""
    return length * width

# Using the functions
print(greet("Alice"))
print(greet("Bob"))

print(f"\n5 + 3 = {add(5, 3)}")
print(f"10 + 20 = {add(10, 20)}")

print(f"\nArea (5x3): {calculate_area(5, 3)}")
print(f"Area (5x1): {calculate_area(5)}")
