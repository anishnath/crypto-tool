# Multiple Decorators

def bold(func):
    @wraps(func)
    def wrapper():
        return f"<b>{func()}</b>"
    return wrapper

def italic(func):
    @wraps(func)
    def wrapper():
        return f"<i>{func()}</i>"
    return wrapper

def underline(func):
    @wraps(func)
    def wrapper():
        return f"<u>{func()}</u>"
    return wrapper

# Decorators are applied bottom to top
# The one closest to the function is applied first
@bold
@italic
@underline
def get_text():
    return "Hello World"

print("Multiple decorators:")
print(get_text())  # <b><i><u>Hello World</u></i></b>
print("\nOrder: underline -> italic -> bold (bottom to top)")


# Example: Logging and timing
def logger(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__} with args={args}, kwargs={kwargs}")
        result = func(*args, **kwargs)
        print(f"{func.__name__} returned: {result}")
        return result
    return wrapper

def timer(func):
    import time
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        elapsed = time.time() - start
        print(f"{func.__name__} executed in {elapsed:.4f}s")
        return result
    return wrapper

@logger
@timer
def add(a, b):
    return a + b

print("\nCombining logger and timer decorators:")
result = add(5, 3)





