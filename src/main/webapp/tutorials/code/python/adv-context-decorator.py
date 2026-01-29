# Using @contextmanager Decorator

from contextlib import contextmanager

# Creating context manager from generator function
@contextmanager
def my_context():
    """Simple context manager using @contextmanager."""
    print("Entering context")
    yield  # Everything before yield is __enter__, after is __exit__
    print("Exiting context")

print("Using @contextmanager:")
with my_context():
    print("Inside context")


# Context manager with exception handling
@contextmanager
def error_context():
    """Context manager that handles exceptions."""
    print("Setup: Entering error context")
    try:
        yield
    except Exception as e:
        print(f"Caught exception: {e}")
    finally:
        print("Cleanup: Exiting error context")

print("\nException handling:")
try:
    with error_context():
        print("Inside context")
        # raise ValueError("Test error")  # Uncomment to test
except ValueError:
    print("Exception propagated outside")


# Practical: Temporary directory or file
@contextmanager
def temporary_file(content):
    """Context manager that creates and cleans up a temporary file."""
    import tempfile
    import os
    
    # Setup: Create temp file
    fd, path = tempfile.mkstemp()
    print(f"Created temporary file: {path}")
    
    try:
        with open(fd, 'w') as f:
            f.write(content)
        yield path  # Return the path
    finally:
        # Cleanup: Remove temp file
        os.remove(path)
        print(f"Removed temporary file: {path}")

print("\nTemporary file context manager:")
with temporary_file("Hello, temporary!") as temp_path:
    with open(temp_path, 'r') as f:
        print("Content:", f.read())


# Timer context manager
@contextmanager
def timer():
    """Context manager for timing code blocks."""
    import time
    start = time.time()
    try:
        yield
    finally:
        elapsed = time.time() - start
        print(f"Time elapsed: {elapsed:.4f}s")

print("\nTimer context manager:")
with timer():
    import time
    time.sleep(0.1)
    print("Some operation")





