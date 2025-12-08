# Python Context Managers
# Context managers allow you to allocate and release resources precisely when you want to.
# The most widely used example of context managers is the `with` statement.

# 1. File Management using `with`
# When you open a file using `with`, the file is automatically closed after the block of code is executed, even if an exception occurs.

# Writing to a file
with open('example.txt', 'w') as f:
    f.write('Hello, world!')

# Reading from a file
with open('example.txt', 'r') as f:
    content = f.read()
    print(content)

# 2. Creating a Context Manager Class
# To create a context manager, you need to define a class with `__enter__` and `__exit__` methods.

class FileManager:
    def __init__(self, filename, mode):
        self.filename = filename
        self.mode = mode
        self.file = None

    def __enter__(self):
        print("Opening file...")
        self.file = open(self.filename, self.mode)
        return self.file

    def __exit__(self, exc_type, exc_value, exc_traceback):
        print("Closing file...")
        if self.file:
            self.file.close()

# Usage
with FileManager('test.txt', 'w') as f:
    f.write('Testing context manager class')

print(f.closed) # True

# 3. Using contextlib
# Python's contextlib module provides utilities for working with context managers.
from contextlib import contextmanager

@contextmanager
def open_file(name):
    print("Opening file (generator)...")
    f = open(name, 'w')
    try:
        yield f
    finally:
        print("Closing file (generator)...")
        f.close()

with open_file('test2.txt') as f:
    f.write('Testing contextlib')
