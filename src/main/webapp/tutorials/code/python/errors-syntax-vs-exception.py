# Syntax Errors vs Exceptions

# SYNTAX ERRORS occur during parsing (before code runs)
# Python can't even understand the code!

print("=== Syntax Errors ===")
print("""
These would cause SyntaxError (don't run!):

# Missing colon
if True
    print("oops")

# Unmatched parentheses
print("hello"

# Invalid assignment
5 = x

# Missing quotes
print(hello world)
""")

# EXCEPTIONS occur during execution (while code runs)
# Python understands the code, but something goes wrong!

print("=== Runtime Exceptions ===")

# 1. ZeroDivisionError - divide by zero
print("\n1. ZeroDivisionError:")
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"   Error: {e}")

# 2. TypeError - wrong type for operation
print("\n2. TypeError:")
try:
    result = "hello" + 5
except TypeError as e:
    print(f"   Error: {e}")

# 3. NameError - undefined variable
print("\n3. NameError:")
try:
    print(undefined_variable)
except NameError as e:
    print(f"   Error: {e}")

# 4. ValueError - right type, wrong value
print("\n4. ValueError:")
try:
    number = int("abc")
except ValueError as e:
    print(f"   Error: {e}")

# Key difference
print("\n=== Key Difference ===")
print("""
Syntax Error: Code won't even start running
             Python parser can't understand it
             Must be fixed before program runs

Exception:    Code starts, then fails at runtime
              Python understood but couldn't execute
              Can be caught and handled with try/except
""")
