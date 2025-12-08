# Practical Uses of Identity Operators

# 1. Checking for None (most common use!)
print("=== Checking for None ===")

def get_user(user_id):
    """Returns user or None if not found"""
    users = {1: "Alice", 2: "Bob"}
    return users.get(user_id)

result = get_user(3)
print(f"get_user(3) returned: {result}")

# Always use 'is' or 'is not' with None!
if result is None:
    print("User not found!")
else:
    print(f"Found user: {result}")

print()

# Why use 'is' instead of '==' for None?
print("=== Why 'is' for None? ===")
print("None is a singleton - there's only ONE None object")
print(f"id(None): {id(None)}")

# == can be overridden by classes, 'is' cannot
print("'is' is safer and faster for None checks")

print()

# 2. Checking for True/False explicitly
print("=== Boolean Identity ===")
value = True

# These are all different!
print(f"value = {value}")
print(f"value is True: {value is True}")    # Checks identity
print(f"value == True: {value == True}")    # Checks equality
print(f"if value: ... (truthy check)")      # Checks truthiness

# Be careful with non-boolean values
print()
print(f"1 == True: {1 == True}")    # True (value comparison)
# Note: Using 'is' with literals shows identity comparison
one_is_true = 1 is True
print(f"1 is True: {one_is_true}")    # False (different objects!)

print()

# 3. Checking object mutation
print("=== Detecting Object Mutation ===")
original = [1, 2, 3]
reference = original
copy = original.copy()

original.append(4)

print(f"original: {original}")
print(f"reference: {reference}")  # Also changed!
print(f"copy: {copy}")            # Not changed

print(f"reference is original: {reference is original}")  # True
print(f"copy is original: {copy is original}")            # False
