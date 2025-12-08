# Exercise: Create a Timer Context Manager
# Create a custom context manager class that measures execution time.
# Use __enter__ and __exit__ methods, and print the elapsed time when exiting.

import time

# TODO: Implement the Timer class
class Timer:
    """
    Context manager for measuring execution time.
    
    Should:
    - Record start time in __enter__
    - Calculate and print elapsed time in __exit__
    - Handle exceptions properly (don't suppress them)
    """
    def __init__(self):
        # TODO: Initialize any needed attributes
        pass
    
    def __enter__(self):
        # TODO: Record start time
        # TODO: Return self (or something else if needed)
        pass
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        # TODO: Record end time
        # TODO: Calculate elapsed time
        # TODO: Print elapsed time
        # TODO: Return False to allow exceptions to propagate
        pass


# Test the Timer context manager
print("Test 1: Simple operation")
with Timer():
    time.sleep(0.5)  # Simulate some work

print("\nTest 2: Calculation")
with Timer() as timer:
    total = sum(range(1000000))
    print(f"Sum result: {total}")
