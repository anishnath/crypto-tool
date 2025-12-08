# Re-raising Exceptions

print("=== Re-raising Exceptions ===\n")

# 1. Basic re-raise with bare 'raise'
print("1. Re-raise after logging:")

def process_data(data):
    try:
        return int(data) * 2
    except ValueError:
        print(f"   [LOG] Failed to process: {data!r}")
        raise  # Re-raise the same exception

try:
    process_data("not a number")
except ValueError as e:
    print(f"   Caught: {e}")
print()

# 2. Re-raise preserves traceback
print("2. Traceback is preserved:")

def level1():
    raise ValueError("Original from level1")

def level2():
    try:
        level1()
    except ValueError:
        print("   [LOG] Error in level2, re-raising")
        raise  # Traceback shows level1 as origin

def level3():
    level2()

try:
    level3()
except ValueError as e:
    print(f"   Caught at top: {e}")
print()

# 3. Modify and re-raise (anti-pattern warning)
print("3. Adding context before re-raise:")

def process_file(filename):
    try:
        with open(filename) as f:
            return f.read()
    except FileNotFoundError:
        # Log and re-raise - don't lose the original
        print(f"   [LOG] File not found: {filename}")
        raise

try:
    process_file("missing.txt")
except FileNotFoundError as e:
    print(f"   Caught: {e.filename}")
print()

# 4. Common pattern: cleanup then re-raise
print("4. Cleanup before re-raise:")

class Connection:
    def __init__(self, name):
        self.name = name
        self.open = False

    def connect(self):
        self.open = True
        print(f"   Connected to {self.name}")

    def close(self):
        self.open = False
        print(f"   Closed {self.name}")

def risky_operation(conn):
    conn.connect()
    try:
        # Simulate failure
        raise RuntimeError("Operation failed!")
    except RuntimeError:
        print("   Cleaning up before re-raising...")
        conn.close()
        raise

conn = Connection("database")
try:
    risky_operation(conn)
except RuntimeError as e:
    print(f"   Caught: {e}")
    print(f"   Connection open: {conn.open}")  # False - cleaned up!
print()

# 5. Wrong: raising new exception loses context
print("5. Wrong: Creating new exception loses context:")

def bad_reraise():
    try:
        int("not a number")
    except ValueError as e:
        # BAD: Creates new exception, loses original traceback
        raise ValueError(f"Failed: {e}")  # New exception!

def good_reraise():
    try:
        int("not a number")
    except ValueError:
        # GOOD: Preserves original
        print("   [LOG] Conversion failed")
        raise  # Same exception, same traceback

print("   Bad way: raise ValueError(f'...')")
print("   Good way: just 'raise'")
print()

# 6. When to use new exception vs re-raise
print("6. Guidelines:")
print("""
Use bare 'raise' when:
- Logging but letting caller handle
- Cleanup before propagating
- Adding context without changing type

Use 'raise NewException()' when:
- Converting internal errors to API errors
- Hiding implementation details
- Exception chaining (next section!)
""")
