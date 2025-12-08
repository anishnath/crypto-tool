# Accessing Exception Details

print("=== Accessing Exception Info ===\n")

# 1. Using 'as' to capture the exception
print("1. Capture exception with 'as':")
try:
    result = int("hello")
except ValueError as e:
    print(f"   Exception object: {e}")
    print(f"   Type: {type(e).__name__}")
    print(f"   Args: {e.args}")
print()

# 2. Different exceptions have different attributes
print("2. Exception-specific attributes:")

# FileNotFoundError has filename
try:
    open("nonexistent.txt")
except FileNotFoundError as e:
    print(f"   FileNotFoundError:")
    print(f"   - Message: {e}")
    print(f"   - Filename: {e.filename}")
    print(f"   - Errno: {e.errno}")
print()

# KeyError includes the missing key
try:
    data = {"name": "Alice"}
    value = data["age"]
except KeyError as e:
    print(f"   KeyError:")
    print(f"   - Missing key: {e.args[0]}")
print()

# 3. String representation vs args
print("3. str(e) vs e.args:")
try:
    x = 1 / 0
except ZeroDivisionError as e:
    print(f"   str(e): '{e}'")
    print(f"   e.args: {e.args}")
    print(f"   repr(e): {repr(e)}")
print()

# 4. Re-raise after logging
print("4. Log and re-raise:")
def process_data():
    try:
        return int("invalid")
    except ValueError as e:
        print(f"   Logging error: {e}")
        raise  # Re-raise the same exception

try:
    process_data()
except ValueError:
    print("   Caught re-raised exception")
print()

# 5. Get exception type name dynamically
print("5. Dynamic exception handling:")

def handle_any_exception(func):
    try:
        return func()
    except Exception as e:
        error_type = type(e).__name__
        error_msg = str(e)
        print(f"   {error_type}: {error_msg}")
        return None

handle_any_exception(lambda: 1 / 0)
handle_any_exception(lambda: int("x"))
handle_any_exception(lambda: [1][5])
print()

# 6. Exception chaining info
print("6. Exception with context:")
try:
    try:
        x = int("bad")
    except ValueError:
        raise RuntimeError("Conversion failed")
except RuntimeError as e:
    print(f"   Exception: {e}")
    print(f"   Caused by: {e.__context__}")
