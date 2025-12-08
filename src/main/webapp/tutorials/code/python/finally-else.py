# The Else Clause in Try/Except

print("=== The Else Clause ===\n")

# 1. Basic else - runs only if NO exception
print("1. Else runs only when no exception:")
try:
    result = 10 / 2
    print(f"   Try: Calculated {result}")
except ZeroDivisionError:
    print("   Except: Division failed")
else:
    print("   Else: No exception occurred!")
    print(f"   Else: Can safely use result: {result}")
finally:
    print("   Finally: Always runs")
print()

# 2. Else does NOT run when exception occurs
print("2. Else skipped when exception occurs:")
try:
    result = 10 / 0  # Will raise exception
    print("   Try: This won't print")
except ZeroDivisionError:
    print("   Except: Caught division by zero")
else:
    print("   Else: This won't run!")
finally:
    print("   Finally: Still runs")
print()

# 3. Why use else? Keep try block minimal
print("3. Why else? Keeps try block minimal:")

def process_data(value):
    # BAD: too much in try block
    # try:
    #     number = int(value)
    #     squared = number ** 2
    #     result = squared * 100 / number  # What if THIS fails?
    # except ValueError:
    #     return "Invalid number"

    # GOOD: only risky code in try
    try:
        number = int(value)  # Only this can raise ValueError
    except ValueError:
        return "Invalid number"
    else:
        # This code is safe from ValueError
        # But if it fails, we WANT to see the error!
        squared = number ** 2
        return f"{value} -> {squared}"

print(f"   process_data('5'): {process_data('5')}")
print(f"   process_data('x'): {process_data('x')}")
print()

# 4. Complete try/except/else/finally
print("4. Complete structure:")
print("""
try:
    # Code that might fail
    risky_operation()
except SomeError:
    # Handle the error
    handle_error()
else:
    # Only if NO exception
    process_success()
finally:
    # Always runs - cleanup
    cleanup()
""")

# 5. Practical example: File processing
print("5. Practical Example - File Processing:")

def read_config(filename):
    try:
        f = open(filename)
    except FileNotFoundError:
        print(f"   Config '{filename}' not found, using defaults")
        return {"setting": "default"}
    else:
        # Only runs if open succeeded
        print(f"   Reading config from '{filename}'")
        # Process file (any error here is NOT caught as FileNotFoundError)
        content = f.read()
        return {"setting": content[:20] if content else "empty"}
    finally:
        # Would close file if opened
        print("   Cleanup complete")

config = read_config("nonexistent.conf")
print(f"   Config: {config}")
print()

# 6. Execution order
print("6. Execution Order:")
print("   1. try block executes")
print("   2. If exception: except runs, else skipped")
print("   3. If no exception: else runs")
print("   4. finally ALWAYS runs last")
