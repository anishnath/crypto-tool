# Short-Circuit Evaluation

# AND short-circuits on False
# If first operand is False, second is never evaluated
print("=== AND Short-Circuit ===")

def check_a():
    print("  Checking A...")
    return False

def check_b():
    print("  Checking B...")
    return True

print("False and check_b():")
result = False and check_b()  # check_b() never called!
print(f"Result: {result}\n")

print("check_a() and check_b():")
result = check_a() and check_b()  # check_b() never called because check_a() is False
print(f"Result: {result}\n")

# OR short-circuits on True
# If first operand is True, second is never evaluated
print("=== OR Short-Circuit ===")

print("True or check_b():")
result = True or check_b()  # check_b() never called!
print(f"Result: {result}\n")

# Practical use: Safe attribute access
print("=== Practical Use ===")
user = None

# Safe check - won't crash even if user is None
if user is not None and user.get("name"):
    print(f"Hello, {user['name']}")
else:
    print("No user or no name")
