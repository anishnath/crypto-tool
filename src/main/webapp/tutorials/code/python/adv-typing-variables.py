# Variable Type Annotations

from typing import List, Dict, Optional

# Simple variable annotations
name: str = "Alice"
age: int = 30
is_active: bool = True

print("Simple variable annotations:")
print(f"name: {name}, type: {type(name).__name__}")
print(f"age: {age}, type: {type(age).__name__}")
print(f"is_active: {is_active}, type: {type(is_active).__name__}")


# Collection annotations
numbers: List[int] = [1, 2, 3, 4, 5]
contacts: Dict[str, str] = {"Alice": "alice@example.com", "Bob": "bob@example.com"}

print("\nCollection annotations:")
print(f"numbers: {numbers}")
print(f"contacts: {contacts}")


# Optional variables
maybe_name: Optional[str] = None
maybe_age: Optional[int] = 25

print("\nOptional variables:")
print(f"maybe_name: {maybe_name}")
print(f"maybe_age: {maybe_age}")

# Later assignment
maybe_name = "Bob"
print(f"maybe_name after assignment: {maybe_name}")


# Complex nested types
user_data: List[Dict[str, Union[int, str]]] = [
    {"name": "Alice", "age": 30},
    {"name": "Bob", "age": 25}
]

print("\nComplex nested types:")
for user in user_data:
    print(f"User: {user}")


# Class attribute annotations
class User:
    name: str
    age: int
    email: Optional[str] = None
    
    def __init__(self, name: str, age: int, email: Optional[str] = None):
        self.name = name
        self.age = age
        self.email = email

print("\nClass with type annotations:")
user = User("Alice", 30, "alice@example.com")
print(f"User: {user.name}, Age: {user.age}, Email: {user.email}")


# Module-level constants
MAX_USERS: int = 100
DEFAULT_TIMEOUT: float = 30.0
SUPPORTED_LANGUAGES: List[str] = ["Python", "Java", "Go"]

print("\nModule-level constants:")
print(f"MAX_USERS: {MAX_USERS}")
print(f"DEFAULT_TIMEOUT: {DEFAULT_TIMEOUT}")
print(f"SUPPORTED_LANGUAGES: {SUPPORTED_LANGUAGES}")


# Type hints without initial value (requires type checker)
# This is valid Python, but mypy will check the type
def process_user():
    user_id: int
    user_id = 123  # Must assign before use
    return user_id

print(f"\nVariable assigned later: {process_user()}")





