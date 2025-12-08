# Function Docstrings in Python

# 1. Basic docstring
print("=== Basic Docstring ===")
def greet(name):
    """Greet someone by name."""
    return f"Hello, {name}!"

# Access docstring
print(greet("Alice"))
print(f"Docstring: {greet.__doc__}")
print()

# 2. Multi-line docstring
print("=== Multi-line Docstring ===")
def calculate_area(length, width):
    """
    Calculate the area of a rectangle.

    Parameters:
        length: The length of the rectangle
        width: The width of the rectangle

    Returns:
        The area (length * width)
    """
    return length * width

print(f"Area: {calculate_area(5, 3)}")
print("Docstring:")
print(calculate_area.__doc__)
print()

# 3. Using help() to view documentation
print("=== Using help() ===")
def is_even(number):
    """
    Check if a number is even.

    Args:
        number: An integer to check

    Returns:
        True if number is even, False otherwise

    Example:
        >>> is_even(4)
        True
        >>> is_even(7)
        False
    """
    return number % 2 == 0

# help(is_even)  # Uncomment to see full help
print(f"is_even(4) = {is_even(4)}")
print(f"is_even(7) = {is_even(7)}")
print()

# 4. Why docstrings matter
print("=== Why Docstrings Matter ===")
print("1. Self-documenting code")
print("2. IDE shows them as tooltips")
print("3. help() function displays them")
print("4. Auto-documentation tools use them")
print("5. Makes your code professional")
