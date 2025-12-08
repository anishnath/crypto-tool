# Preserving Function Metadata with functools.wraps

from functools import wraps

def my_decorator_without_wraps(func):
    """Decorator that doesn't preserve metadata."""
    def wrapper(*args, **kwargs):
        """Wrapper function."""
        return func(*args, **kwargs)
    return wrapper

def my_decorator_with_wraps(func):
    """Decorator that preserves metadata using wraps."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        """Wrapper function."""
        return func(*args, **kwargs)
    return wrapper


@my_decorator_without_wraps
def example_function():
    """This is an example function."""
    return "Hello"

@my_decorator_with_wraps
def example_function2():
    """This is an example function."""
    return "Hello"


print("Without functools.wraps:")
print("Name:", example_function.__name__)  # 'wrapper' - wrong!
print("Docstring:", example_function.__doc__)  # 'Wrapper function.' - wrong!

print("\nWith functools.wraps:")
print("Name:", example_function2.__name__)  # 'example_function2' - correct!
print("Docstring:", example_function2.__doc__)  # 'This is an example function.' - correct!

# This is important for debugging and introspection
import inspect
print("\nInspect signature (with wraps):")
print(inspect.signature(example_function2))  # Works correctly

