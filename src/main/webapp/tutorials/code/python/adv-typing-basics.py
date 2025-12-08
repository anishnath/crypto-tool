# Basic Type Annotations

# Function type hints
def add(a: int, b: int) -> int:
    """Add two integers."""
    return a + b

def greet(name: str) -> str:
    """Greet someone."""
    return f"Hello, {name}!"

def divide(a: float, b: float) -> float:
    """Divide two floats."""
    return a / b


# Using the functions
print("Type hints in action:")
result = add(5, 3)
print(f"add(5, 3) = {result}")

message = greet("Alice")
print(f"greet('Alice') = {message}")

quotient = divide(10.0, 2.0)
print(f"divide(10.0, 2.0) = {quotient}")


# Type hints don't enforce types at runtime
# This still works (Python is dynamically typed)
result = add("hello", "world")  # No error at runtime!
print(f"\nType hints are not enforced: {result}")


# Variable annotations
name: str = "Alice"
age: int = 30
height: float = 5.6

print("\nVariable annotations:")
print(f"name: {name} (type: {type(name).__name__})")
print(f"age: {age} (type: {type(age).__name__})")
print(f"height: {height} (type: {type(height).__name__})")


# Multiple return types (without Union - Python 3.10+)
def get_value(mode: str) -> int | str:
    """Return different types based on mode."""
    if mode == "number":
        return 42
    else:
        return "default"

print("\nUnion types (Python 3.10+ syntax):")
print(get_value("number"))  # int
print(get_value("text"))    # str

