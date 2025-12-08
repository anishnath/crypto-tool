# Basic Try/Except

print("=== Basic Try/Except ===\n")

# 1. Without exception handling - program crashes
print("1. Without try/except (would crash):")
print("   # result = 10 / 0  <- This crashes the program!")
print()

# 2. With try/except - program continues
print("2. With try/except (graceful handling):")
try:
    result = 10 / 0
except ZeroDivisionError:
    print("   Caught: Cannot divide by zero!")

print("   Program continues running!")
print()

# 3. Code that doesn't raise exception
print("3. When no exception occurs:")
try:
    result = 10 / 2
    print(f"   Result: {result}")
except ZeroDivisionError:
    print("   This won't run - no error!")
print()

# 4. Try block can have multiple lines
print("4. Multiple lines in try block:")
try:
    x = 5
    y = 10
    z = x + y
    result = z / x  # Last line might fail
    print(f"   Calculation result: {result}")
except ZeroDivisionError:
    print("   Division failed!")
print()

# 5. Only the failing line skips to except
print("5. Exception stops try block execution:")
try:
    print("   Line 1 - runs")
    print("   Line 2 - runs")
    result = 1 / 0  # Exception here!
    print("   Line 3 - SKIPPED!")
    print("   Line 4 - SKIPPED!")
except ZeroDivisionError:
    print("   Caught exception!")

print("   After try/except - program continues")
print()

# 6. Basic syntax template
print("=== Syntax Template ===")
print("""
try:
    # Code that might fail
    risky_operation()
except SomeException:
    # Handle the error
    print("Something went wrong")

# Code here runs regardless
continue_program()
""")
