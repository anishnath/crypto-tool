# Constants in Python
# Python doesn't have true constants, but uses naming convention

# Convention: ALL_CAPS for constants
PI = 3.14159
MAX_SIZE = 100
DATABASE_URL = "localhost:5432"
DEBUG_MODE = False

print("Constants (by convention):")
print(f"PI = {PI}")
print(f"MAX_SIZE = {MAX_SIZE}")
print(f"DATABASE_URL = {DATABASE_URL}")
print(f"DEBUG_MODE = {DEBUG_MODE}")

# Warning: Python won't prevent you from changing them!
PI = 3.0  # This works but violates convention
print(f"\nPI changed to {PI} (bad practice!)")

# For true constants, use typing.Final (Python 3.8+)
from typing import Final

GRAVITY: Final = 9.81
print(f"\nGRAVITY (Final) = {GRAVITY}")
# Type checkers will warn if you try to reassign GRAVITY
