# The Context Manager Protocol: __enter__ and __exit__

class MyContextManager:
    """Custom context manager implementing the protocol."""
    
    def __init__(self, name):
        self.name = name
        print(f"Initializing {self.name}")
    
    def __enter__(self):
        """Setup code - called before the block."""
        print(f"Entering {self.name}")
        return self  # Return value assigned to variable after 'as'
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Cleanup code - called after the block."""
        print(f"Exiting {self.name}")
        # exc_type, exc_val, exc_tb are None if no exception occurred
        if exc_type is not None:
            print(f"Exception occurred: {exc_type.__name__}: {exc_val}")
        # Return False to propagate exception, True to suppress it
        return False


# Using the custom context manager
print("Using custom context manager:")
with MyContextManager("TestContext") as ctx:
    print("Inside the with block")
    print(f"Context name: {ctx.name}")

print("After the with block")


# Context manager that handles exceptions
class ErrorHandler:
    """Context manager that logs errors."""
    
    def __enter__(self):
        print("Error handler entered")
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is not None:
            print(f"Caught exception: {exc_type.__name__}")
            print(f"Message: {exc_val}")
            # Don't suppress - let exception propagate
        return False


print("\nException handling:")
try:
    with ErrorHandler():
        print("Inside error handler")
        # raise ValueError("Something went wrong!")  # Uncomment to test
        print("No error occurred")
except ValueError as e:
    print(f"Exception caught outside: {e}")





