# Assert Statement Basics

print("=== Assert Basics ===\n")

# 1. Basic assert - passes silently when true
print("1. Assert that passes:")
x = 10
assert x > 0  # True - nothing happens
print(f"   x = {x}, assertion passed!")
print()

# 2. Assert with message
print("2. Assert with message (will fail):")
try:
    y = -5
    assert y > 0, f"y must be positive, got {y}"
except AssertionError as e:
    print(f"   AssertionError: {e}")
print()

# 3. Assert is equivalent to...
print("3. Assert is shorthand for:")
print("""
   assert condition, message

   # Is equivalent to:
   if __debug__:
       if not condition:
           raise AssertionError(message)
""")

# 4. Multiple conditions
print("4. Assert with multiple conditions:")
age = 25
name = "Alice"

# All conditions must be true
assert age > 0 and age < 150, "Invalid age"
assert name and len(name) > 0, "Name required"
print(f"   age={age}, name={name} - both assertions passed!")
print()

# 5. Assert returns None (not the condition)
print("5. Assert returns None:")
# result = (assert True)  # SyntaxError - can't use assert in expressions
# Can't use assert in expressions!
print("   assert can't be used in expressions")
print("   It's a statement, not a function")
print("   # result = (assert True)  # This would be a SyntaxError")
print()

# 6. Assert with expressions
print("6. Assert with any expression:")

# Any truthy/falsy value works
assert [1, 2, 3]      # Non-empty list is truthy
assert {"key": "val"} # Non-empty dict is truthy
assert "hello"        # Non-empty string is truthy
assert 42             # Non-zero number is truthy
print("   Truthy assertions passed!")

# These would fail:
# assert []          # Empty list is falsy
# assert {}          # Empty dict is falsy
# assert ""          # Empty string is falsy
# assert 0           # Zero is falsy
# assert None        # None is falsy
print()

# 7. The __debug__ variable
print("7. The __debug__ variable:")
print(f"   __debug__ = {__debug__}")
print("""
   - __debug__ is True by default
   - Running with 'python -O' sets it to False
   - When False, assert statements are REMOVED!
""")
