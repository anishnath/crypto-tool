# Exercise: Create a Timing Decorator
# Create a decorator that measures and prints the execution time of a function.
# Use the time module and the @ syntax.

import time
from functools import wraps

# TODO: Implement the timing decorator
def timing(func):
    """
    Decorator that measures function execution time.
    
    Should:
    - Record start time before calling the function
    - Record end time after calling the function
    - Print the elapsed time in seconds
    - Use functools.wraps to preserve function metadata
    - Return the function's result
    """
    # TODO: Use @wraps(func) here
    # TODO: Define wrapper function that accepts *args, **kwargs
    # TODO: Record start time
    # TODO: Call the original function and store result
    # TODO: Record end time
    # TODO: Calculate and print elapsed time
    # TODO: Return the result
    pass


# Test the decorator
@timing
def slow_function():
    """Simulates a slow operation."""
    time.sleep(0.5)  # Sleep for 0.5 seconds
    return "Done"

@timing
def fast_function(n):
    """Performs quick calculation."""
    return sum(range(n))

# Test
slow_function()
fast_function(1000000)
