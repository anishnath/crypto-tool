# The @ Syntax - Syntactic Sugar

def my_decorator(func):
    def wrapper():
        print("Before function call")
        func()
        print("After function call")
    return wrapper

# These two are equivalent:

# Method 1: Manual decoration
def greet1():
    print("Hello!")
greet1 = my_decorator(greet1)

# Method 2: @ syntax (preferred)
@my_decorator
def greet2():
    print("Hello!")

print("Method 1 (manual):")
greet1()

print("\nMethod 2 (@ syntax):")
greet2()

# The @ decorator is applied at definition time
print("\nWhen @ is applied:")
print("Function defined:", greet2.__name__)  # Shows 'wrapper' (we'll fix this with wraps)


# Multiple decorators can be stacked
def bold(func):
    def wrapper():
        return f"<b>{func()}</b>"
    return wrapper

def italic(func):
    def wrapper():
        return f"<i>{func()}</i>"
    return wrapper

@bold
@italic
def get_text():
    return "Hello World"

print("\nMultiple decorators (applied bottom to top):")
print(get_text())  # <b><i>Hello World</i></b>





