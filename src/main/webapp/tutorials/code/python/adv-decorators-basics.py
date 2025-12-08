# Understanding Decorators - Basic Concept

def my_decorator(func):
    """A simple decorator that wraps a function."""
    def wrapper():
        print("Something is happening before the function is called.")
        func()  # Call the original function
        print("Something is happening after the function is called.")
    return wrapper  # Return the wrapper function

def say_hello():
    print("Hello!")

# Manual decoration (without @ syntax)
print("Manual decoration:")
decorated_hello = my_decorator(say_hello)
decorated_hello()

# Using @ syntax (cleaner)
@my_decorator
def say_goodbye():
    print("Goodbye!")

print("\nUsing @ syntax:")
say_goodbye()


# Decorator that adds behavior
def uppercase_decorator(func):
    """Decorator that converts function output to uppercase."""
    def wrapper():
        result = func()
        return result.upper()
    return wrapper

@uppercase_decorator
def get_message():
    return "hello world"

print("\nUppercase decorator:")
print(get_message())  # "HELLO WORLD"

