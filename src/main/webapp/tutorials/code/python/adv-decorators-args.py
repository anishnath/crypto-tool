# Decorators with Arguments

from functools import wraps

def repeat(times):
    """Decorator factory that accepts an argument."""
    def decorator(func):
        """The actual decorator."""
        @wraps(func)
        def wrapper(*args, **kwargs):
            """Wrapper that calls function multiple times."""
            for _ in range(times):
                result = func(*args, **kwargs)
            return result  # Return last result
        return wrapper
    return decorator

@repeat(3)
def greet(name):
    print(f"Hello, {name}!")

print("Decorator with arguments:")
greet("Alice")  # Prints "Hello, Alice!" 3 times


# More complex example
def retry(max_attempts=3):
    """Decorator that retries function on failure."""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            last_error = None
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_error = e
                    print(f"Attempt {attempt + 1} failed: {e}")
            raise last_error
        return wrapper
    return decorator

@retry(max_attempts=3)
def risky_operation():
    import random
    if random.random() < 0.7:
        raise ValueError("Operation failed!")
    return "Success!"

print("\nRetry decorator:")
try:
    result = risky_operation()
    print(result)
except ValueError as e:
    print(f"All attempts failed: {e}")


# Timer decorator with optional precision
def timer(precision=2):
    """Decorator that times function execution."""
    import time
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            start = time.time()
            result = func(*args, **kwargs)
            elapsed = time.time() - start
            print(f"{func.__name__} took {elapsed:.{precision}f} seconds")
            return result
        return wrapper
    return decorator

@timer(precision=4)
def slow_function():
    import time
    time.sleep(0.1)
    return "Done"

print("\nTimer decorator:")
slow_function()

