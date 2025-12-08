# Context Manager Basics - The 'with' Statement

import os

# Create a test file
with open("test.txt", "w") as f:
    f.write("Hello, Context Managers!")

# 1. Basic usage - file is automatically closed
print("=== Basic Context Manager ===")
with open("test.txt", "r") as f:
    content = f.read()
    print(f"Inside 'with': f.closed = {f.closed}")
    print(f"Content: {content}")

print(f"Outside 'with': f.closed = {f.closed}")
print()

# 2. Compare with manual approach
print("=== Manual vs Context Manager ===")

# Manual approach (error-prone)
f = open("test.txt", "r")
try:
    content = f.read()
    print("Manual: Read successful")
finally:
    f.close()
    print("Manual: File closed")
print()

# Context manager approach (safer, cleaner)
with open("test.txt", "r") as f:
    content = f.read()
    print("With: Read successful")
print("With: File auto-closed")
print()

# 3. Exception handling is automatic
print("=== Exception Handling ===")
try:
    with open("test.txt", "r") as f:
        content = f.read()
        # Simulate an error
        raise ValueError("Oops!")
except ValueError as e:
    print(f"Caught error: {e}")
    print(f"File still closed? {f.closed}")  # Yes!
print()

# 4. The context manager protocol
print("=== What 'with' Does ===")
print("""
with open("file.txt") as f:
    # do work

Is equivalent to:

f = open("file.txt")
try:
    # do work
finally:
    f.close()
""")

# Cleanup
os.remove("test.txt")
print("(Cleaned up test file)")
