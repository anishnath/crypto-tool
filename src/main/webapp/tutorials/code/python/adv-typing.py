# Python Type Hinting
# Type hinting is a formal solution to statically indicate the type of a value within your Python code.
# It was specified in PEP 484 and introduced in Python 3.5.

# 1. Basic Type Hints
def greeting(name: str) -> str:
    return 'Hello ' + name

print(greeting("John"))

# 2. Variable Annotation
age: int = 25
height: float = 5.9
is_student: bool = True

# 3. The typing Module
# For more complex types, we use the typing module.
from typing import List, Dict, Tuple, Optional, Union, Any

# List of integers
numbers: List[int] = [1, 2, 3, 4]

# Dictionary with string keys and integer values
scores: Dict[str, int] = {"Alice": 90, "Bob": 85}

# Tuple
coordinates: Tuple[int, int] = (10, 20)

# Optional (can be None)
def get_user(user_id: int) -> Optional[str]:
    if user_id == 1:
        return "Admin"
    return None

# Union (can be one of multiple types)
def process_input(data: Union[int, str]) -> None:
    print(data)

# Any (can be anything)
def log_data(data: Any) -> None:
    print(data)

# 4. Type Checking
# Python runtime does not enforce function and variable type annotations.
# They can be used by third party tools such as type checkers (mypy), IDEs, linters, etc.
