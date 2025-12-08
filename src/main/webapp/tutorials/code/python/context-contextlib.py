# contextlib Module - Easy Context Managers

import os
from contextlib import contextmanager, closing, suppress

# 1. @contextmanager decorator - the easy way!
print("=== @contextmanager Decorator ===")

@contextmanager
def open_file(filename, mode):
    """Simple file context manager using decorator."""
    print(f"Opening {filename}")
    f = open(filename, mode)
    try:
        yield f  # This is what 'as' receives
    finally:
        print(f"Closing {filename}")
        f.close()

with open_file("test.txt", "w") as f:
    f.write("Using contextlib!")

with open_file("test.txt", "r") as f:
    print(f"Content: {f.read()}")
print()

# 2. Timer using @contextmanager
print("=== Timer with @contextmanager ===")

import time

@contextmanager
def timer(label):
    start = time.time()
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"{label}: {elapsed:.4f}s")

with timer("Computation"):
    total = sum(x**2 for x in range(10000))
    print(f"Sum computed: {total}")
print()

# 3. Temporary directory changer
print("=== Directory Changer ===")

@contextmanager
def change_dir(path):
    """Temporarily change directory."""
    old_dir = os.getcwd()
    try:
        os.chdir(path)
        print(f"Changed to: {os.getcwd()}")
        yield
    finally:
        os.chdir(old_dir)
        print(f"Restored to: {os.getcwd()}")

with change_dir("/tmp"):
    print(f"Working in: {os.getcwd()}")
print()

# 4. suppress() - ignore specific exceptions
print("=== suppress() - Ignore Exceptions ===")

# Without suppress
try:
    os.remove("nonexistent.txt")
except FileNotFoundError:
    pass  # Ignore

# With suppress (cleaner!)
with suppress(FileNotFoundError):
    os.remove("nonexistent.txt")
    print("This won't print if file missing")

print("Program continues normally")
print()

# 5. closing() - for objects with .close()
print("=== closing() - Auto-close Objects ===")

class Resource:
    def __init__(self, name):
        self.name = name
        print(f"Resource {name} acquired")

    def close(self):
        print(f"Resource {self.name} released")

    def use(self):
        print(f"Using {self.name}")

# closing() calls .close() automatically
with closing(Resource("Database")) as r:
    r.use()
print()

# 6. Combining context managers
print("=== Combined Context Managers ===")

@contextmanager
def logged_operation(name):
    print(f"[START] {name}")
    try:
        yield
    finally:
        print(f"[END] {name}")

with timer("Total"), logged_operation("Data processing"):
    with suppress(ZeroDivisionError):
        result = 1 / 0  # Error suppressed
    print("Processing data...")

# Cleanup
if os.path.exists("test.txt"):
    os.remove("test.txt")
print("\n(Cleaned up)")
