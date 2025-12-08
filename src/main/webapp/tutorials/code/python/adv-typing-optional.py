# Optional and Union Types

from typing import Optional, Union, List, Dict

# Optional[Type] is the same as Union[Type, None]
def find_user(name: str) -> Optional[dict]:
    """Find user, return None if not found."""
    users = {"Alice": {"age": 30}, "Bob": {"age": 25}}
    return users.get(name)

def get_age(name: str) -> Union[int, None]:  # Same as Optional[int]
    """Get user age, return None if not found."""
    users = {"Alice": 30, "Bob": 25}
    return users.get(name)


print("Optional types:")
user = find_user("Alice")
if user:
    print(f"Found user: {user}")
else:
    print("User not found")

user = find_user("Charlie")
if user is None:
    print("User not found")


# Union for multiple types
def process_value(value: Union[int, str, float]) -> str:
    """Process value of different types."""
    return str(value)

print("\nUnion types:")
print(process_value(42))      # int
print(process_value("hello")) # str
print(process_value(3.14))    # float


# Python 3.10+ syntax: Type1 | Type2
def modern_find_user(name: str) -> dict | None:
    """Modern syntax (Python 3.10+)."""
    users = {"Alice": {"age": 30}, "Bob": {"age": 25}}
    return users.get(name)

def modern_process_value(value: int | str | float) -> str:
    """Modern syntax (Python 3.10+)."""
    return str(value)


# Optional with default None
def create_config(name: Optional[str] = None) -> dict:
    """Create config with optional name."""
    return {"name": name or "default"}

print("\nOptional with defaults:")
print(create_config("custom"))
print(create_config())  # None


# Complex optional types
def parse_data(data: Optional[List[Dict[str, Union[int, str]]]]) -> Optional[Dict[str, int]]:
    """Parse optional complex data."""
    if data is None:
        return None
    result = {}
    for item in data:
        key = item.get("key", "")
        value = item.get("value", 0)
        if isinstance(value, int):
            result[key] = value
    return result

print("\nComplex optional types:")
data = [{"key": "a", "value": 1}, {"key": "b", "value": 2}]
result = parse_data(data)
print(f"Parsed: {result}")

result = parse_data(None)
print(f"Parsed None: {result}")

