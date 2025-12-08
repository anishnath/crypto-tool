# Basic Return Statements

# 1. Simple return
print("=== Simple Return ===")
def add(a, b):
    """Return the sum of two numbers."""
    return a + b

result = add(3, 5)
print(f"3 + 5 = {result}")

# The return value can be used directly
print(f"10 + 20 = {add(10, 20)}")
print()

# 2. Return ends the function
print("=== Return Ends Function ===")
def check_age(age):
    """Check if age is valid and return status."""
    if age < 0:
        return "Invalid age"
    if age < 18:
        return "Minor"
    return "Adult"
    # Code after return never executes
    print("This never runs!")

print(check_age(-5))
print(check_age(15))
print(check_age(25))
print()

# 3. Functions without explicit return
print("=== Implicit Return (None) ===")
def greet(name):
    """Print a greeting - no return statement."""
    print(f"Hello, {name}!")

result = greet("Alice")
print(f"Return value: {result}")
print(f"Type: {type(result)}")
print()

# 4. Explicit return None
print("=== Explicit Return None ===")
def find_item(items, target):
    """Return item if found, None otherwise."""
    for item in items:
        if item == target:
            return item
    return None  # Explicit is better than implicit

found = find_item([1, 2, 3], 2)
print(f"Found 2: {found}")

not_found = find_item([1, 2, 3], 5)
print(f"Found 5: {not_found}")
