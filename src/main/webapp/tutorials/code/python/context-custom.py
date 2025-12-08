# Creating Custom Context Managers

import os

# 1. Basic custom context manager class
print("=== Custom Context Manager Class ===")

class FileManager:
    """A simple file context manager."""

    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode
        self.file = None

    def __enter__(self):
        print(f"Opening {self.filename}")
        self.file = open(self.filename, self.mode)
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Closing {self.filename}")
        if self.file:
            self.file.close()
        # Return False to propagate exceptions
        return False

# Use it like built-in open()
with FileManager("custom.txt", "w") as f:
    f.write("Hello from custom manager!")

with FileManager("custom.txt", "r") as f:
    print(f"Content: {f.read()}")
print()

# 2. Context manager with exception handling
print("=== Exception Handling in __exit__ ===")

class SafeFileManager:
    """Context manager that handles exceptions."""

    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode
        self.file = None

    def __enter__(self):
        self.file = open(self.filename, self.mode)
        return self.file

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.file.close()
        if exc_type is not None:
            print(f"Caught exception: {exc_type.__name__}: {exc_val}")
            # Return True to suppress the exception
            return True
        return False

# Exception is caught and suppressed
with SafeFileManager("safe.txt", "w") as f:
    f.write("Test")
    raise ValueError("This won't crash!")

print("Program continues after exception")
print()

# 3. Non-file context manager example
print("=== Timer Context Manager ===")

import time

class Timer:
    """Measure execution time of a code block."""

    def __init__(self, label=""):
        self.label = label

    def __enter__(self):
        self.start = time.time()
        return self

    def __exit__(self, *args):
        self.elapsed = time.time() - self.start
        print(f"{self.label}: {self.elapsed:.4f} seconds")
        return False

# Time a code block
with Timer("Loop"):
    total = sum(range(100000))

with Timer("List comprehension"):
    squares = [x**2 for x in range(1000)]
print()

# 4. Context manager returning self
print("=== Returning Self ===")

class Connection:
    """Simulated database connection."""

    def __init__(self, host):
        self.host = host
        self.connected = False

    def __enter__(self):
        print(f"Connecting to {self.host}...")
        self.connected = True
        return self  # Return the connection object

    def __exit__(self, *args):
        print(f"Disconnecting from {self.host}")
        self.connected = False
        return False

    def query(self, sql):
        if self.connected:
            return f"Result for: {sql}"

with Connection("localhost") as conn:
    result = conn.query("SELECT * FROM users")
    print(result)

# Cleanup
for name in ["custom.txt", "safe.txt"]:
    if os.path.exists(name):
        os.remove(name)
print("\n(Cleaned up)")
