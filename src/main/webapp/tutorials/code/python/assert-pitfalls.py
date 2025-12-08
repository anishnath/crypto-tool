# Assert Pitfalls - When NOT to Use Assert

print("=== Assert Pitfalls ===\n")

# 1. NEVER use assert for input validation
print("1. WRONG: Assert for user input validation")
print("""
# WRONG - assert can be disabled!
def set_age(age):
    assert age > 0, "Age must be positive"  # DANGEROUS!
    self.age = age

# RIGHT - use proper validation
def set_age(age):
    if age <= 0:
        raise ValueError("Age must be positive")
    self.age = age
""")

def bad_set_age(age):
    assert age > 0, "Age must be positive"  # Can be bypassed with -O!
    return age

def good_set_age(age):
    if age <= 0:
        raise ValueError("Age must be positive")
    return age

print("   With normal Python, both work:")
try:
    bad_set_age(-5)
except AssertionError as e:
    print(f"   bad_set_age(-5): AssertionError - {e}")

try:
    good_set_age(-5)
except ValueError as e:
    print(f"   good_set_age(-5): ValueError - {e}")

print("\n   With python -O, assert is REMOVED!")
print("   bad_set_age(-5) would SUCCEED with invalid data!")
print()

# 2. NEVER use assert for security checks
print("2. WRONG: Assert for security/auth")
print("""
# WRONG - security bypassed with -O flag!
def delete_user(user_id, current_user):
    assert current_user.is_admin, "Admin required!"  # DANGEROUS!
    database.delete(user_id)

# RIGHT - always check permissions
def delete_user(user_id, current_user):
    if not current_user.is_admin:
        raise PermissionError("Admin required!")
    database.delete(user_id)
""")
print()

# 3. Assert with side effects
print("3. WRONG: Assert with side effects")
print("""
# WRONG - side effect removed with -O!
assert items.pop() is not None  # pop() won't happen!

# WRONG - file never closed with -O!
assert file.close() is None

# RIGHT - separate the operation
item = items.pop()
assert item is not None  # Now safe, pop() already happened
""")
print()

# 4. Assert with tuple (always true!)
print("4. BUG: Assert with tuple is always True")

# This is a BUG - tuple is always truthy!
try:
    x = -5
    # Note: This syntax creates a tuple, not an assertion!
    # Python sees: assert (x > 0, "message") which is assert (False, "message")
    # The tuple (False, "message") is truthy, so assert passes!
    assert (x > 0, "x must be positive")  # ALWAYS passes! (SyntaxWarning)
    print("   assert(x > 0, 'msg') - passes even though x=-5!")
    print("   Reason: (False, 'msg') is a non-empty tuple = truthy!")
except AssertionError:
    print("   This won't print")

# Correct syntax (no parentheses around condition)
try:
    assert x > 0, "x must be positive"  # Correct!
except AssertionError as e:
    print(f"   assert x > 0, 'msg' - properly fails: {e}")
print()

# 5. Assertions removed in optimized mode
print("5. Assertions disabled with -O flag:")
print(f"   Current __debug__ = {__debug__}")
print("""
   python script.py      -> __debug__ = True, asserts work
   python -O script.py   -> __debug__ = False, asserts REMOVED
   python -OO script.py  -> Same + docstrings removed
""")
print()

# 6. Summary: Assert vs Raise
print("=== Assert vs Raise ===")
print("""
Use ASSERT for:                    Use RAISE for:
----------------------             ----------------------
- Catching bugs                    - Handling bad input
- Internal invariants              - User input validation
- Development checks               - Security checks
- Things that should NEVER fail    - Expected error conditions
- Can be disabled                  - Must NEVER be disabled

Rule: If it could fail in production due to external
factors (user input, network, files), use raise!
""")

# 7. Quick reference
print("=== Quick Reference ===")
print("""
# Development/debugging check
assert result > 0, f"Bug: negative result {result}"

# User input validation
if not user_input.isdigit():
    raise ValueError("Input must be a number")

# Security check
if not user.has_permission('delete'):
    raise PermissionError("Deletion not allowed")

# File/network operations
if not file.exists():
    raise FileNotFoundError(f"File {file} not found")
""")
