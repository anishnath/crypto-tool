# The typing Module

from typing import List, Dict, Tuple, Optional, Union

# List type hints
def process_numbers(numbers: List[int]) -> List[int]:
    """Process a list of integers."""
    return [x * 2 for x in numbers]

# Dict type hints
def get_contact(name: str) -> Dict[str, str]:
    """Get contact information."""
    return {"name": name, "email": f"{name}@example.com"}

# Tuple type hints
def get_coordinates() -> Tuple[float, float]:
    """Get x, y coordinates."""
    return (10.5, 20.3)


print("Typing module examples:")
numbers = [1, 2, 3, 4, 5]
doubled = process_numbers(numbers)
print(f"Doubled: {doubled}")

contact = get_contact("Alice")
print(f"Contact: {contact}")

coords = get_coordinates()
print(f"Coordinates: {coords}")


# Python 3.9+ can use built-in types directly
def modern_process_numbers(numbers: list[int]) -> list[int]:
    """Modern syntax (Python 3.9+)."""
    return [x * 2 for x in numbers]

def modern_get_contact(name: str) -> dict[str, str]:
    """Modern syntax (Python 3.9+)."""
    return {"name": name, "email": f"{name}@example.com"}


# Complex types
def process_data(data: List[Dict[str, Union[int, str]]]) -> Dict[str, int]:
    """Process complex nested data structures."""
    result = {}
    for item in data:
        key = item.get("key", "")
        value = item.get("value", 0)
        if isinstance(value, int):
            result[key] = value
    return result

print("\nComplex types:")
data = [{"key": "a", "value": 1}, {"key": "b", "value": 2}]
processed = process_data(data)
print(f"Processed: {processed}")


# Function type hints
from typing import Callable

def apply_function(func: Callable[[int, int], int], a: int, b: int) -> int:
    """Apply a function to two integers."""
    return func(a, b)

print("\nFunction type hints:")
result = apply_function(lambda x, y: x + y, 5, 3)
print(f"apply_function(lambda x, y: x + y, 5, 3) = {result}")

